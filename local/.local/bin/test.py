#!/usr/bin/env python3

"""
test.py - Natural movement simulator for macOS Tahoe (26.x)

Moves the mouse in a human-like way using layered Perlin noise, variable speed,
micro-jitter, and occasional pauses.

Requirements:
  pip3 install pyobjc-framework-Quartz

Usage:
  python3 test.py                         # Full screen, runs until Ctrl+C
  python3 test.py --bbox 100,200,1400,900 # constrain to a bbox
  python3 test.py --duration 90           # Run for 90 seconds, then stop
  python3 test.py --speed slow            # slow / normal / fast
  python3 test.py --verbose               # print coords to stdout

Stop anytime with Ctrl+C - the cursor is yours again instantly
"""

import argparse
import math
import random
import signal
import sys
import time

try:
    from Quartz.CoreGraphics import (
        CGEventCreateMouseEvent,
        CGEventPost,
        CGEventCreate,
        CGEventGetLocation,
        CGDisplayBounds,
        CGMainDisplayID,
        kCGEventMouseMoved,
        kCGMouseButtonLeft,
        kCGHIDEventTap,
    )
except ImportError:
    print(
        "Error: pyobjc-framework-Quartz is required.\n"
        "Install it with:  pip3 install pyobjc-framework-Quartz\n"
        "On macOS Tahoe you may also need:  pip3 install pyobjc-core"
    )
    sys.exit(1)

# ============================================================================
# Perlin Noise - self-contained implementation (no external deps)
# Based on Ken Perlin's improved noise (2002) with the standard permutation
# table and 5th-degree smoothstep.
# ============================================================================


class PerlinNoise:
    """1-D Perlin noise sampler with configurable octaves."""

    def __init__(self, seed: int | None = None) -> None:
        self.perm = list(range(256))
        rng = random.Random(seed)
        rng.shuffle(self.perm)
        self.perm *= 2  # duplicate so we never need to mod-256 during lookup

    @staticmethod
    def _fade(t: float) -> float:
        """5th-degree smoothstep: 6t' - 15t' + 10t'"""
        return t * t * t * (t * (t * 6.0 - 15.0) + 10.0)

    @staticmethod
    def _lerp(a: float, b: float, t: float) -> float:
        return a + t * (b - a)

    def _grad(self, hash_val: int, x: float) -> float:
        """Pseudo-random gradient from the permutation table."""
        h = hash_val & 0xF
        grad = 1.0 + (h & 7)  # gradient value 1...8
        if h & 8:
            grad = -grad
        return grad * x

    def noise(self, x: float) -> float:
        """Return noise value in approximately [-1, 1] for coordinate x."""
        xi = int(math.floor(x)) & 255
        xf = x - math.floor(x)
        u = self._fade(xf)
        a = self.perm[xi]
        b = self.perm[xi + 1]
        return self._lerp(self._grad(a, xf), self._grad(b, xf - 1.0), u) / 8.0

    def fractal(self, x: float, octaves: int = 4, persistence: float = 0.5) -> float:
        """Fractal Brownian Motion - sum of multiple octaves for richer detail."""
        total = 0.0
        amplitude = 1.0
        frequency = 1.0
        max_amp = 0.0
        for _ in range(octaves):
            total += self.noise(x * frequency) * amplitude
            max_amp += amplitude
            amplitude *= persistence
            frequency *= 2.0
        return total / max_amp  # normalized to [-1, 1]


# ============================================================================
# Mouse helpers
# ============================================================================


def get_screen_bounds() -> tuple[int, int, int, int]:
    """Return (x, y, width, height) of the main display."""
    bounds = CGDisplayBounds(CGMainDisplayID())
    return (
        int(bounds.origin.x),
        int(bounds.origin.y),
        int(bounds.size.width),
        int(bounds.size.height),
    )


def get_current_mouse_pos() -> tuple[float, float]:
    event = CGEventCreate(None)
    loc = CGEventGetLocation(event)
    return (loc.x, loc.y)


def move_mouse(x: float, y: float) -> None:
    event = CGEventCreateMouseEvent(
        None, kCGEventMouseMoved, (x, y), kCGMouseButtonLeft
    )
    CGEventPost(kCGHIDEventTap, event)


# ============================================================================
# Bézier helpers
# ============================================================================


def cubic_bezier(
    t: float,
    p0: tuple[float, float],
    p1: tuple[float, float],
    p2: tuple[float, float],
    p3: tuple[float, float],
) -> tuple[float, float]:
    """Evaluate cubic Bézier at parameter t in [0, 1]."""
    u = 1.0 - t
    uu = u * u
    tt = t * t
    w0 = uu * u
    w1 = 3.0 * uu * t
    w2 = 3.0 * u * tt
    w3 = tt * t
    return (
        w0 * p0[0] + w1 * p1[0] + w2 * p2[0] + w3 * p3[0],
        w0 * p0[1] + w1 * p1[1] + w2 * p2[1] + w3 * p3[1],
    )


def random_control_points(
    start: tuple[float, float],
    end: tuple[float, float],
    spread: float,
) -> tuple[tuple[float, float], tuple[float, float]]:
    """
    Generate two Bézier control points that pull the path into a
    natural-looking curve.  `spread` is how far off the straight
    line the controls can wander (pixels).
    """
    dx = end[0] - start[0]
    dy = end[1] - start[1]
    dist = math.hypot(dx, dy)
    if dist < 1.0:
        return (start, end)

    # Perpendicular direction
    perp_x = -dy / dist
    perp_y = dx / dist

    # Control point 1: 20-45% along the line, offset perpendicularly
    t1 = random.uniform(0.2, 0.45)
    offset1 = random.uniform(-spread, spread)
    along1 = random.uniform(-0.1, 0.1) * dist
    cp1 = (
        start[0] + dx * t1 + perp_x * offset1 + (dx / dist) * along1,
        start[1] + dy * t1 + perp_y * offset1 + (dy / dist) * along1,
    )

    # Control point 2: 55-85% along the line
    # 70% chance: same-side arc (humans tend to sweep, not S-curve)
    # 30% chance: opposite-side S-curve
    t2 = random.uniform(0.55, 0.85)
    if random.random() < 0.3:
        offset2 = random.uniform(-spread, spread)
    else:
        offset2 = offset1 * random.uniform(0.3, 1.0)
    along2 = random.uniform(-0.08, 0.08) * dist
    cp2 = (
        start[0] + dx * t2 + perp_x * offset2 + (dx / dist) * along2,
        start[1] + dy * t2 + perp_y * offset2 + (dy / dist) * along2,
    )

    return (cp1, cp2)


# ============================================================================
# Natural movement engine
# ============================================================================


class NaturalMovementEngine:
    """
    Waypoint-based mouse mover.

    Each "leg" of travel:
      1. Pick a random destination anywhere in the bounding box.
      2. Build a cubic Bézier from current pos -> destination with
         randomised control points (arced path, not a straight line).
      3. Walk the Bézier with eased speed + Perlin speed jitter.
      4. Layer Perlin perturbation that peaks mid-leg (organic wobble).
      5. Layer constant micro-tremor (tiny hand-shake).
      6. On arrival, dwell with live micro-tremor (not frozen).
      7. Repeat.
    """

    SPEED_PROFILES = {
        "slow": {
            "px_per_sec": 280,
            "dwell": (20.0, 45.0),
            "curve_spread": 120,
            "perturb": 30,
        },
        "normal": {
            "px_per_sec": 550,
            "dwell": (15.00, 30.0),
            "curve_spread": 180,
            "perturb": 45,
        },
        "fast": {
            "px_per_sec": 1000,
            "dwell": (0.08, 15.0),
            "curve_spread": 220,
            "perturb": 55,
        },
    }

    def __init__(
        self,
        bbox: tuple[int, int, int, int] | None = None,
        speed: str = "normal",
        verbose: bool = False,
    ):
        sx, sy, sw, sh = get_screen_bounds()
        if bbox:
            self.x_min, self.y_min, self.x_max, self.y_max = bbox
        else:
            self.x_min, self.y_min = sx + 20, sy + 20
            self.x_max, self.y_max = sx + sw - 20, sy + sh - 20

        profile = self.SPEED_PROFILES.get(speed, self.SPEED_PROFILES["normal"])
        self.px_per_sec = profile["px_per_sec"]
        self.dwell_range = profile["dwell"]
        self.curve_spread = profile["curve_spread"]
        self.perturb_amp = profile["perturb"]

        self.verbose = verbose

        seed_base = random.randint(0, 100_000)
        self.noise_x_perturb = PerlinNoise(seed=seed_base)
        self.noise_y_perturb = PerlinNoise(seed=seed_base + 1)
        self.noise_x_micro = PerlinNoise(seed=seed_base + 2)
        self.noise_y_micro = PerlinNoise(seed=seed_base + 3)
        self.noise_speed = PerlinNoise(seed=seed_base + 4)

        self.t = random.uniform(0, 1000)  # random phase so each run is unique

    def _pick_waypoint(self) -> tuple[float, float]:
        margin = 10
        return (
            random.uniform(self.x_min + margin, self.x_max - margin),
            random.uniform(self.y_min + margin, self.y_max - margin),
        )
        self.leg_progress = 0.0  # 0 -> 1 over each leg

    def _clamp_pos(self, x: float, y: float) -> tuple[float, float]:
        return (
            max(self.x_min, min(self.x_max, x)),
            max(self.y_min, min(self.y_max, y)),
        )

    def _travel_leg(self, start: tuple[float, float], end: tuple[float, float]):
        """
        Generator: animate one leg from start to end.
        Yields (x, y) at ~83 Hz.  Caller is responsible for
        calling move_mouse() and sleeping.
        """
        dist = math.hypot(end[0] - start[0], end[1] - start[1])
        if dist < 2.0:
            yield end
            return

        # Build Bézier
        cp1, cp2 = random_control_points(start, end, self.curve_spread)

        # Travel time: base from speed, jittered ±30%
        base_time = dist / self.px_per_sec
        travel_time = base_time * random.uniform(0.7, 1.3)
        travel_time = max(0.08, travel_time)

        tick = 0.012
        elapsed = 0.0

        while elapsed < travel_time:
            # Raw progress 0 → 1
            raw_t = min(elapsed / travel_time, 1.0)

            # Eased progress: fast acceleration, cruise, soft deceleration
            # Using a quintic ease-in-out for a snappier feel
            if raw_t < 0.5:
                eased_t = 16.0 * raw_t**5
            else:
                p = -2.0 * raw_t + 2.0
                eased_t = 1.0 - (p**5) / 2.0

            # Perlin speed jitter: wobble the eased_t slightly
            speed_jitter = self.noise_speed.noise(self.t * 1.2) * 0.03
            eased_t = max(0.0, min(1.0, eased_t + speed_jitter))

            # Position on the Bézier
            bx, by = cubic_bezier(eased_t, start, cp1, cp2, end)

            # Perlin perturbation — peaks at mid-leg, zero at endpoints
            envelope = math.sin(raw_t * math.pi)
            dx_perturb = (
                self.noise_x_perturb.fractal(self.t * 0.5, octaves=3)
                * self.perturb_amp
                * envelope
            )
            dy_perturb = (
                self.noise_y_perturb.fractal(self.t * 0.45, octaves=3)
                * self.perturb_amp
                * envelope
            )

            # Micro tremor
            dx_micro = self.noise_x_micro.noise(self.t * 4.0) * 2.5
            dy_micro = self.noise_y_micro.noise(self.t * 4.3) * 2.5

            x, y = self._clamp_pos(
                bx + dx_perturb + dx_micro, by + dy_perturb + dy_micro
            )
            yield (x, y)

            # Advance with slight tick-rate jitter
            tick_jitter = 1.0 + self.noise_speed.noise(self.t * 2.0) * 0.25
            actual_tick = tick * max(0.6, tick_jitter)
            elapsed += actual_tick
            self.t += actual_tick * 0.4
            time.sleep(actual_tick)

        # Final position: land right at the target (plus micro tremor)
        dx_micro = self.noise_x_micro.noise(self.t * 4.0) * 1.5
        dy_micro = self.noise_y_micro.noise(self.t * 4.3) * 1.5
        yield self._clamp_pos(end[0] + dx_micro, end[1] + dy_micro)

    def _dwell(
        self,
        pos: tuple[float, float],
        seconds: float,
        start_time: float,
        duration: float | None,
    ):
        """
        Dwell at a position with live micro-tremor so cursor isn't frozen.
        Returns the final position after dwell.
        """
        dwell_end = time.monotonic() + seconds
        x, y = pos
        while time.monotonic() < dwell_end:
            if duration and (time.monotonic() - start_time) >= duration:
                raise _DurationReached()
            self.t += 0.005
            dx = self.noise_x_micro.noise(self.t * 4.0) * 1.8
            dy = self.noise_y_micro.noise(self.t * 4.3) * 1.8
            cx, cy = self._clamp_pos(x + dx, y + dy)
            move_mouse(cx, cy)
            time.sleep(0.025)
        return (x, y)

    def run(self, duration: float | None = None):
        """Main loop: pick waypoints, travel, dwell, repeat."""
        run_start = time.monotonic()
        current = get_current_mouse_pos()

        print(
            f"🖱  Natural mouse mover running  |  "
            f"bounds=({self.x_min},{self.y_min})→({self.x_max},{self.y_max})  |  "
            f"Ctrl+C to stop"
        )

        try:
            while True:
                target = self._pick_waypoint()
                dist = math.hypot(target[0] - current[0], target[1] - current[1])

                if self.verbose:
                    elapsed = time.monotonic() - run_start
                    print(
                        f"\n  🎯  t={elapsed:.1f}s  target=({target[0]:.0f}, {target[1]:.0f})"
                        f"  dist={dist:.0f}px"
                    )

                # --- Animate travel ---
                for pos in self._travel_leg(current, target):
                    if duration and (time.monotonic() - run_start) >= duration:
                        raise _DurationReached()
                    move_mouse(pos[0], pos[1])
                    current = pos

                # --- Dwell ---
                dwell_secs = random.uniform(*self.dwell_range)
                if self.verbose:
                    print(f"  ⏸  dwell {dwell_secs:.2f}s")
                current = self._dwell(current, dwell_secs, run_start, duration)

        except (KeyboardInterrupt, _DurationReached):
            pass

        elapsed = time.monotonic() - run_start
        print(f"\n✓  Stopped after {elapsed:.1f}s")


class _DurationReached(Exception):
    pass


# ============================================================================
# CLI
# ============================================================================


def parse_bbox(s: str) -> tuple[int, int, int, int]:
    """Parse 'x1,y1,x2,y2' string into a 4-tuple."""
    parts = [int(p.strip()) for p in s.split(",")]
    if len(parts) != 4:
        raise argparse.ArgumentTypeError("bbox must be x1,y1,x2,y2 (4 integers)")
    x1, y1, x2, y2 = parts
    if x2 <= x1 or y2 <= y1:
        raise argparse.ArgumentTypeError("bbox must satisfy x2 > x1 and y2 > y1")
    return (x1, y1, x2, y2)


def main():
    parser = argparse.ArgumentParser(
        description="Move the mouse cursor naturally using waypoints + Bézier curves.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Examples:\n"
            "   python3 test.py\n"
            "   python3 test.py --bbox 100,200,1400,900 --speed slow\n"
            "   python3 test.py --duration 30 --verbose\n"
        ),
    )

    parser.add_argument(
        "--bbox",
        type=parse_bbox,
        default=None,
        help="Bounding box x1, y1, x2, y2 to constrain movement (default: full screen)",
    )

    parser.add_argument(
        "--duration",
        type=float,
        default=None,
        help="Run for N seconds then stop (default: run until Ctrl+C)",
    )

    parser.add_argument(
        "--speed",
        choices=["slow", "normal", "fast"],
        default="normal",
        help="Movement speed profile (default: normal)",
    )

    parser.add_argument(
        "--verbose",
        "-v",
        action="store_true",
        help="Print cursor coordinates as it moves",
    )
    args = parser.parse_args()

    # Graceful Ctrl+C
    signal.signal(signal.SIGINT, lambda *_: sys.exit(0))

    mover = NaturalMovementEngine(
        bbox=args.bbox,
        speed=args.speed,
        verbose=args.verbose,
    )
    mover.run(duration=args.duration)


if __name__ == "__main__":
    main()
