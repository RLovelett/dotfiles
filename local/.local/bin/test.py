#!/usr/bin/env python3

"""
test.py - Natural movement simulator for macOS

Moves the mouse in a human-like way using layered Perlin noise, variable speed,
micro-jitter, occasional pauses, scrolling, and app switching (Cmd+Tab).

Requirements:
  pip3 install pyobjc-framework-Quartz

Usage:
  python3 test.py                         # Full screen, runs until Ctrl+C
  python3 test.py --bbox 100,200,1400,900 # Constrain to a bounding box
  python3 test.py --duration 90           # Run for 90 seconds, then stop
  python3 test.py --verbose               # Print actions to stdout

Stop anytime with Ctrl+C - the cursor is yours again instantly
"""

import argparse
import math
import random
import signal
import sys
import time
from abc import ABC, abstractmethod
from dataclasses import dataclass

try:
    from Quartz.CoreGraphics import (
        CGEventCreate,
        CGEventCreateKeyboardEvent,
        CGEventCreateMouseEvent,
        CGEventCreateScrollWheelEvent,
        CGEventGetLocation,
        CGEventPost,
        CGEventSetFlags,
        CGDisplayBounds,
        CGMainDisplayID,
        kCGEventFlagMaskCommand,
        kCGEventMouseMoved,
        kCGHIDEventTap,
        kCGMouseButtonLeft,
        kCGScrollEventUnitPixel,
    )
except ImportError:
    print(
        "Error: pyobjc-framework-Quartz is required.\n"
        "Install it with:  pip3 install pyobjc-framework-Quartz\n"
        "On macOS Tahoe you may also need:  pip3 install pyobjc-core"
    )
    sys.exit(1)

# macOS virtual key codes
_KEYCODE_TAB = 48
_KEYCODE_COMMAND = 55  # Left Command — used to release the modifier after Cmd+Tab

# Micro-pause lognormal params (between actions within a group, not CLI-exposed)
_MICRO_PAUSE_MEDIAN = 1.2   # seconds
_MICRO_PAUSE_SIGMA  = 0.55
_MICRO_PAUSE_MIN    = 0.5   # seconds
_MICRO_PAUSE_MAX    = 3.0   # seconds


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
# Mouse / keyboard helpers
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


def post_scroll(dy: int, dx: int = 0) -> None:
    """Post a single scroll wheel event. dy > 0 = up, dy < 0 = down."""
    if dx != 0:
        event = CGEventCreateScrollWheelEvent(
            None, kCGScrollEventUnitPixel, 2, dy, dx
        )
    else:
        event = CGEventCreateScrollWheelEvent(
            None, kCGScrollEventUnitPixel, 1, dy
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
# Distributions
# ============================================================================


def lognormal_sample(
    median: float,
    sigma: float,
    min_val: float,
    max_val: float,
    rng: random.Random,
) -> float:
    """
    Sample from a lognormal distribution clamped to [min_val, max_val].

    median: the median of the distribution in the original units (e.g. seconds)
    sigma:  shape parameter — std dev of the underlying normal (dimensionless)
            higher = more spread / heavier tail
    """
    mu = math.log(median)
    value = math.exp(rng.gauss(mu, sigma))
    return max(min_val, min(max_val, value))


# ============================================================================
# ScrollParams dataclass
# ============================================================================


@dataclass
class ScrollParams:
    dy: int           # vertical pixels total (positive = up, negative = down)
    dx: int           # horizontal pixels total (0 = vertical only)
    ticks: int        # number of individual scroll events to spread across
    tick_delay: float # base seconds between ticks (Perlin-jittered at runtime)


def random_scroll_params(rng: random.Random) -> ScrollParams:
    direction = rng.choices([1, -1], weights=[35, 65])[0]  # bias downward
    h_active = rng.choices([0, 1], weights=[85, 15])[0]
    dx = h_active * rng.choice([-1, 1]) * rng.randint(40, 150)
    return ScrollParams(
        dy=direction * rng.randint(80, 400),
        dx=dx,
        ticks=rng.randint(5, 20),
        tick_delay=0.025,
    )


# ============================================================================
# Actions
# ============================================================================


class Action(ABC):
    @abstractmethod
    def execute(self, engine: "NaturalMovementEngine") -> None: ...

    @abstractmethod
    def describe(self) -> str: ...


class TravelAction(Action):
    def describe(self) -> str:
        return "travel"

    def execute(self, engine: "NaturalMovementEngine") -> None:
        target = engine._pick_waypoint()
        if engine.verbose:
            elapsed = time.monotonic() - engine._run_start
            dist = math.hypot(
                target[0] - engine._current_pos[0],
                target[1] - engine._current_pos[1],
            )
            print(
                f"  -> t={elapsed:.1f}s  "
                f"target=({target[0]:.0f},{target[1]:.0f})  dist={dist:.0f}px"
            )
        for pos in engine._travel_leg(engine._current_pos, target):
            if engine._duration and (time.monotonic() - engine._run_start) >= engine._duration:
                raise _DurationReached()
            move_mouse(*pos)
            engine._current_pos = pos


class ScrollAction(Action):
    def __init__(self, params: ScrollParams) -> None:
        self._params = params

    def describe(self) -> str:
        direction = "up" if self._params.dy > 0 else "down"
        axis = "" if self._params.dx == 0 else " + horizontal"
        return (
            f"scroll {direction}{axis}  "
            f"{abs(self._params.dy)}px vertical over {self._params.ticks} ticks"
        )

    def execute(self, engine: "NaturalMovementEngine") -> None:
        p = self._params
        dy_per_tick = p.dy / p.ticks
        dx_per_tick = p.dx / p.ticks
        for _ in range(p.ticks):
            noise = engine.noise_speed.noise(engine.t * 2.0) * 0.2
            tick_dy = int(dy_per_tick * (1.0 + noise))
            tick_dx = int(dx_per_tick * (1.0 + noise))
            post_scroll(tick_dy, tick_dx)
            jitter = 1.0 + engine.noise_speed.noise(engine.t * 1.5) * 0.3
            delay = p.tick_delay * max(0.5, jitter)
            engine.t += delay * 0.3
            time.sleep(delay)


class CmdTabAction(Action):
    def __init__(self, n_tabs: int) -> None:
        self._n_tabs = n_tabs

    def describe(self) -> str:
        return f"Cmd+Tab x{self._n_tabs}"

    def execute(self, engine: "NaturalMovementEngine") -> None:
        for i in range(self._n_tabs):
            # Tab keydown with Command modifier held
            down = CGEventCreateKeyboardEvent(None, _KEYCODE_TAB, True)
            CGEventSetFlags(down, kCGEventFlagMaskCommand)
            CGEventPost(kCGHIDEventTap, down)

            time.sleep(engine._rng.uniform(0.05, 0.12))

            # Tab keyup, still with Command modifier
            up = CGEventCreateKeyboardEvent(None, _KEYCODE_TAB, False)
            CGEventSetFlags(up, kCGEventFlagMaskCommand)
            CGEventPost(kCGHIDEventTap, up)

            if i < self._n_tabs - 1:
                time.sleep(engine._rng.uniform(0.10, 0.25))

        # Release the Command key to finalise the app switch
        cmd_up = CGEventCreateKeyboardEvent(None, _KEYCODE_COMMAND, False)
        CGEventPost(kCGHIDEventTap, cmd_up)


class DwellAction(Action):
    def __init__(self, seconds: float) -> None:
        self._seconds = seconds

    def describe(self) -> str:
        return f"dwell {self._seconds:.1f}s"

    def execute(self, engine: "NaturalMovementEngine") -> None:
        engine._current_pos = engine._dwell(
            engine._current_pos,
            self._seconds,
            engine._run_start,
            engine._duration,
        )


# ============================================================================
# Action group builder
# ============================================================================

# Soft ordering: lower value = earlier in the group
_ACTION_ORDER = {"travel": 0, "scroll": 1, "cmd_tab": 1, "dwell": 2}


def build_action_group(
    rng: random.Random,
    weight_travel: float,
    weight_scroll: float,
    weight_dwell: float,
    weight_cmd_tab: float,
    group_weights: list[float],
) -> list[Action]:
    """
    Pick 1–3 actions with weighted sampling, respecting max-count rules,
    then apply soft ordering: travel first, dwell last, others shuffled between.
    """
    n = rng.choices([1, 2, 3], weights=group_weights)[0]

    # max 2 occurrences for travel/scroll/cmd_tab, max 1 for dwell
    pool_spec = [
        ("travel",  weight_travel,  2),
        ("scroll",  weight_scroll,  2),
        ("cmd_tab", weight_cmd_tab, 2),
        ("dwell",   weight_dwell,   1),
    ]
    weight_map  = {key: w  for key, w, _  in pool_spec}
    remaining   = {key: mx for key, _, mx in pool_spec}

    chosen_keys: list[str] = []
    for _ in range(n):
        eligible = [k for k in weight_map if remaining[k] > 0]
        if not eligible:
            break
        weights = [weight_map[k] for k in eligible]
        key = rng.choices(eligible, weights=weights)[0]
        chosen_keys.append(key)
        remaining[key] -= 1

    # Soft ordering: travel → [scroll/cmd_tab shuffled] → dwell
    # Ties within the same order bucket are broken randomly.
    chosen_keys.sort(key=lambda k: (_ACTION_ORDER[k], rng.random()))

    # Instantiate
    actions: list[Action] = []
    for key in chosen_keys:
        if key == "travel":
            actions.append(TravelAction())
        elif key == "scroll":
            actions.append(ScrollAction(random_scroll_params(rng)))
        elif key == "cmd_tab":
            n_tabs = rng.choices([1, 2, 3], weights=[60, 30, 10])[0]
            actions.append(CmdTabAction(n_tabs))
        elif key == "dwell":
            seconds = lognormal_sample(
                median=20.0, sigma=0.8, min_val=5.0, max_val=60.0, rng=rng
            )
            actions.append(DwellAction(seconds))

    return actions


# ============================================================================
# Natural movement engine
# ============================================================================


class NaturalMovementEngine:
    """
    Action-group-based mouse mover.

    Each iteration:
      1. Build an action group (1–3 actions, weighted).
      2. Execute each action in order; insert a lognormal micro-pause between them.
      3. After the group completes, wait a lognormal inter-group delay (30s–5min).
      4. Repeat.
    """

    def __init__(
        self,
        bbox: tuple[int, int, int, int] | None = None,
        px_per_sec: float = 550,
        curve_spread: float = 180,
        perturb_amp: float = 45,
        weight_travel: float = 0.6,
        weight_scroll: float = 0.5,
        weight_dwell: float = 0.4,
        weight_cmd_tab: float = 0.2,
        group_weights: list[float] | None = None,
        wait_median: float = 60.0,
        wait_sigma: float = 1.1,
        wait_min: float = 30.0,
        wait_max: float = 300.0,
        verbose: bool = False,
    ):
        sx, sy, sw, sh = get_screen_bounds()
        if bbox:
            self.x_min, self.y_min, self.x_max, self.y_max = bbox
        else:
            self.x_min, self.y_min = sx + 20, sy + 20
            self.x_max, self.y_max = sx + sw - 20, sy + sh - 20

        self.px_per_sec   = px_per_sec
        self.curve_spread = curve_spread
        self.perturb_amp  = perturb_amp

        self.weight_travel  = weight_travel
        self.weight_scroll  = weight_scroll
        self.weight_dwell   = weight_dwell
        self.weight_cmd_tab = weight_cmd_tab
        self.group_weights  = group_weights if group_weights is not None else [0.6, 0.3, 0.1]

        self.wait_median = wait_median
        self.wait_sigma  = wait_sigma
        self.wait_min    = wait_min
        self.wait_max    = wait_max

        self.verbose = verbose
        self._rng = random.Random()

        # State shared with actions during run()
        self._current_pos: tuple[float, float] = (0.0, 0.0)
        self._run_start: float = 0.0
        self._duration: float | None = None

        seed_base = random.randint(0, 100_000)
        self.noise_x_perturb = PerlinNoise(seed=seed_base)
        self.noise_y_perturb = PerlinNoise(seed=seed_base + 1)
        self.noise_x_micro   = PerlinNoise(seed=seed_base + 2)
        self.noise_y_micro   = PerlinNoise(seed=seed_base + 3)
        self.noise_speed     = PerlinNoise(seed=seed_base + 4)

        self.t = random.uniform(0, 1000)  # random phase so each run is unique

    def _pick_waypoint(self) -> tuple[float, float]:
        margin = 10
        return (
            random.uniform(self.x_min + margin, self.x_max - margin),
            random.uniform(self.y_min + margin, self.y_max - margin),
        )

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
    ) -> tuple[float, float]:
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

    def _interruptible_sleep(self, seconds: float) -> None:
        """Sleep for `seconds`, waking every 0.5s to check --duration."""
        deadline = time.monotonic() + seconds
        while time.monotonic() < deadline:
            if self._duration and (time.monotonic() - self._run_start) >= self._duration:
                raise _DurationReached()
            time.sleep(min(0.5, deadline - time.monotonic()))

    def run(self, duration: float | None = None) -> None:
        """Main loop: build action groups, execute, wait, repeat."""
        self._run_start = time.monotonic()
        self._duration = duration
        self._current_pos = get_current_mouse_pos()

        print(
            f"Natural mouse mover running  |  "
            f"bounds=({self.x_min},{self.y_min})->({self.x_max},{self.y_max})  |  "
            f"Ctrl+C to stop"
        )

        try:
            while True:
                if duration and (time.monotonic() - self._run_start) >= duration:
                    raise _DurationReached()

                group = build_action_group(
                    self._rng,
                    self.weight_travel,
                    self.weight_scroll,
                    self.weight_dwell,
                    self.weight_cmd_tab,
                    self.group_weights,
                )

                if self.verbose:
                    names = " → ".join(a.describe() for a in group)
                    print(f"\n[group] {names}")

                for i, action in enumerate(group):
                    if self.verbose:
                        print(f"  [action] {action.describe()}")
                    action.execute(self)
                    if duration and (time.monotonic() - self._run_start) >= duration:
                        raise _DurationReached()
                    if i < len(group) - 1:
                        pause = lognormal_sample(
                            median=_MICRO_PAUSE_MEDIAN,
                            sigma=_MICRO_PAUSE_SIGMA,
                            min_val=_MICRO_PAUSE_MIN,
                            max_val=_MICRO_PAUSE_MAX,
                            rng=self._rng,
                        )
                        if self.verbose:
                            print(f"  [micro-pause {pause:.2f}s]")
                        self._interruptible_sleep(pause)

                wait = lognormal_sample(
                    median=self.wait_median,
                    sigma=self.wait_sigma,
                    min_val=self.wait_min,
                    max_val=self.wait_max,
                    rng=self._rng,
                )
                if self.verbose:
                    print(f"  [wait {wait:.1f}s]")
                self._interruptible_sleep(wait)

        except (KeyboardInterrupt, _DurationReached):
            pass

        elapsed = time.monotonic() - self._run_start
        print(f"\nStopped after {elapsed:.1f}s")


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


def parse_group_weights(s: str) -> list[float]:
    """Parse '0.6,0.3,0.1' into a list of three floats."""
    parts = [float(p.strip()) for p in s.split(",")]
    if len(parts) != 3:
        raise argparse.ArgumentTypeError(
            "group-weights must be exactly 3 comma-separated values, e.g. 0.6,0.3,0.1"
        )
    if any(w < 0 for w in parts):
        raise argparse.ArgumentTypeError("group-weights values must be non-negative")
    return parts


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Move the mouse cursor naturally using action groups + Bézier curves.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Examples:\n"
            "   python3 test.py\n"
            "   python3 test.py --bbox 100,200,1400,900\n"
            "   python3 test.py --duration 30 --verbose\n"
            "   python3 test.py --wait-median 120 --wait-sigma 0.8\n"
            "   python3 test.py --weight-travel 0.8 --weight-cmd-tab 0.05\n"
        ),
    )

    # General
    parser.add_argument(
        "--bbox", type=parse_bbox, default=None,
        help="Bounding box x1,y1,x2,y2 to constrain movement (default: full screen)",
    )
    parser.add_argument(
        "--duration", type=float, default=None,
        help="Run for N seconds then stop (default: run until Ctrl+C)",
    )
    parser.add_argument(
        "--verbose", "-v", action="store_true",
        help="Print actions as they occur",
    )

    # Movement
    mv = parser.add_argument_group("movement")
    mv.add_argument(
        "--px-per-sec", type=float, default=550, metavar="N",
        help="Mouse speed in pixels/second (default: 550)",
    )
    mv.add_argument(
        "--curve-spread", type=float, default=180, metavar="N",
        help="Bézier control-point spread in pixels (default: 180)",
    )
    mv.add_argument(
        "--perturb-amp", type=float, default=45, metavar="N",
        help="Perlin perturbation amplitude in pixels (default: 45)",
    )

    # Wait timing
    wt = parser.add_argument_group("wait timing (inter-group)")
    wt.add_argument(
        "--wait-median", type=float, default=60.0, metavar="S",
        help="Median wait between groups in seconds (default: 60)",
    )
    wt.add_argument(
        "--wait-sigma", type=float, default=1.1, metavar="S",
        help="Lognormal shape — higher = more spread/heavier tail (default: 1.1)",
    )
    wt.add_argument(
        "--wait-min", type=float, default=30.0, metavar="S",
        help="Minimum wait in seconds (default: 30)",
    )
    wt.add_argument(
        "--wait-max", type=float, default=300.0, metavar="S",
        help="Maximum wait in seconds (default: 300)",
    )

    # Action weights and group size
    aw = parser.add_argument_group("action selection")
    aw.add_argument(
        "--weight-travel", type=float, default=0.6, metavar="W",
        help="Relative weight for travel (default: 0.6)",
    )
    aw.add_argument(
        "--weight-scroll", type=float, default=0.5, metavar="W",
        help="Relative weight for scroll (default: 0.5)",
    )
    aw.add_argument(
        "--weight-dwell", type=float, default=0.4, metavar="W",
        help="Relative weight for dwell (default: 0.4)",
    )
    aw.add_argument(
        "--weight-cmd-tab", type=float, default=0.2, metavar="W",
        help="Relative weight for Cmd+Tab (default: 0.2)",
    )
    aw.add_argument(
        "--group-weights", type=parse_group_weights, default=[0.6, 0.3, 0.1],
        metavar="W1,W2,W3",
        help="Weights for group size 1, 2, 3 (default: 0.6,0.3,0.1)",
    )

    args = parser.parse_args()

    signal.signal(signal.SIGINT, lambda *_: sys.exit(0))

    mover = NaturalMovementEngine(
        bbox=args.bbox,
        px_per_sec=args.px_per_sec,
        curve_spread=args.curve_spread,
        perturb_amp=args.perturb_amp,
        weight_travel=args.weight_travel,
        weight_scroll=args.weight_scroll,
        weight_dwell=args.weight_dwell,
        weight_cmd_tab=args.weight_cmd_tab,
        group_weights=args.group_weights,
        wait_median=args.wait_median,
        wait_sigma=args.wait_sigma,
        wait_min=args.wait_min,
        wait_max=args.wait_max,
        verbose=args.verbose,
    )
    mover.run(duration=args.duration)


if __name__ == "__main__":
    main()
