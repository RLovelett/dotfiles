/*
 * Parametric trellis finial
 *
 * Recreates the finial from "Trellis Finial Assembly" by mtairymd:
 * https://www.instructables.com/Trellis-Finial-Assembly/
 *
 * The referenced design is licensed under CC BY-NC-SA 4.0:
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * Customizer dimensions are in inches. Geometry is converted to millimeters
 * internally because STL files and slicers conventionally use millimeters.
 */

/* [Tower] */

// Overall height from the ground to the tip of the finial.
tower_height = 72.4; // [4:0.1:144]

// Diameter through the pole centerlines at ground level.
footprint_diameter = 23.5; // [1:0.1:72]

/* [Pole sockets] */

// Nominal pole diameter.
pole_diameter = 7 / 16; // [0.125:0.001:0.75]

// Added to the pole diameter to produce a practical slip fit.
socket_clearance = 0.016; // [0:0.001:0.05]

/* [Preview] */

// Show translucent poles and the requested footprint circle. Preview helpers
// are background geometry and are not included in STL exports.
show_assembly_preview = false;

/* [Quality] */

// Number of fragments used for circles and rounded features.
facet_count = 72; // [24:12:144]

/* [Hidden] */

inch = 25.4;
epsilon = 0.02;

// Dimensions taken from the article drawings and attached STEP model.
body_side = 1.75 * inch;
body_height = 2 * inch;
skirt_height = 0.5 * inch;
socket_depth = 0.75 * inch;
socket_offset = 0.4 * inch;
body_edge_radius = 0.175 * inch;
base_inradius = body_side * sqrt(3) / 6;

// Hook envelope measured from the attached STEP model and simplified into
// printable, self-supporting L brackets.
hook_width = 0.414 * inch;
hook_projection = 0.19 * inch;
hook_thickness = 0.063 * inch;
hook_lip_height = 0.21 * inch;
hook_bottom = 0.99 * inch;
hook_edge_radius = 0.03125 * inch;

// The rounded shell is the Minkowski sum of a smaller triangular pyramid and
// a sphere. These dimensions preserve the original 1.75-by-2-inch envelope.
pyramid_core_height = body_height - skirt_height - body_edge_radius;
pyramid_core_inradius = base_inradius
    - body_edge_radius / cos(14);
pyramid_core_side = 2 * sqrt(3) * pyramid_core_inradius;
body_face_slope = atan(pyramid_core_inradius / pyramid_core_height);

tower_height_mm = tower_height * inch;
footprint_radius = footprint_diameter * inch / 2;
pole_diameter_mm = pole_diameter * inch;
socket_diameter = (pole_diameter + socket_clearance) * inch;
pole_vertical_run = tower_height_mm - body_height;

// Socket openings are offset from the center of the finial. Subtracting that
// offset makes the pole centerlines meet the requested footprint at ground.
pole_horizontal_run = footprint_radius - socket_offset;
socket_angle = atan(pole_horizontal_run / pole_vertical_run);
exposed_pole_length = sqrt(
    pole_vertical_run * pole_vertical_run
    + pole_horizontal_run * pole_horizontal_run
);
required_pole_length = exposed_pole_length + socket_depth;

// Conservative material checks at the socket opening and blind end. Socket
// centers point toward the triangle vertices, so their distance toward either
// neighboring face is half their radial offset.
socket_radius = socket_diameter / 2;
blind_z = socket_depth * cos(socket_angle);
blind_center_radius = socket_offset - socket_depth * sin(socket_angle);
blind_profile_side = profile_side_at(blind_z);
blind_inradius = blind_profile_side * sqrt(3) / 6;
entry_wall = base_inradius - socket_offset / 2 - socket_radius;
blind_wall = blind_inradius - abs(blind_center_radius) / 2 - socket_radius;

assert(tower_height_mm > body_height,
    "tower_height must be greater than the 2-inch finial height");
assert(footprint_radius > socket_offset,
    "footprint_diameter must exceed twice the socket offset (0.8 inches)");
assert(pole_diameter > 0, "pole_diameter must be positive");
assert(socket_clearance >= 0, "socket_clearance cannot be negative");
assert(entry_wall > 0 && blind_wall > 0,
    "socket diameter or tower angle breaks through the fixed finial body");

echo(socket_angle_degrees = socket_angle);
echo(exposed_pole_length_inches = exposed_pole_length / inch);
echo(required_pole_length_inches = required_pole_length / inch);
echo(minimum_estimated_socket_wall_mm = min(entry_wall, blind_wall));

$fn = facet_count;

trellis_finial();

if (show_assembly_preview)
    %assembly_preview();


// Side length of the lofted triangular profile at a given height.
function profile_side_at(z) =
    z <= skirt_height
        ? body_side
        : max(
            0,
            2 * sqrt(3)
                * (base_inradius
                    - (z - skirt_height) * tan(body_face_slope))
        );


module trellis_finial() {
    difference() {
        union() {
            finial_body();

            for (face_angle = [-90, 30, 150])
                rotate([0, 0, face_angle - 90])
                    string_hook();
        }

        for (pole_angle = [90, 210, 330])
            pole_socket(pole_angle);
    }
}


module finial_body() {
    union() {
        linear_extrude(height = skirt_height + epsilon)
            polygon(points = equilateral_triangle_points(body_side));

        // A spherical offset produces the cylindrical edge fillets, domed
        // peak, and curved intersections with the triangular base seen in the
        // source STEP model.
        translate([0, 0, skirt_height])
            minkowski() {
                triangular_pyramid(
                    pyramid_core_side,
                    pyramid_core_height
                );
                sphere(r = body_edge_radius);
            }
    }
}


module triangular_pyramid(side, height) {
    points = concat(
        [for (point = equilateral_triangle_points(side))
            [point[0], point[1], 0]],
        [[0, 0, height]]
    );

    polyhedron(
        points = points,
        faces = [
            [0, 2, 1],
            [0, 1, 3],
            [1, 2, 3],
            [2, 0, 3]
        ],
        convexity = 4
    );
}


function equilateral_triangle_points(side) = [
    [0, side / sqrt(3)],
    [-side / 2, -side / (2 * sqrt(3))],
    [side / 2, -side / (2 * sqrt(3))]
];


module pole_socket(azimuth) {
    // A tilted cutter must begin far enough below the base for its complete
    // cross-section to pass through z=0. Starting at the opening itself leaves
    // the characteristic (and incorrect) semicircular notch.
    cutter_lead = socket_diameter;

    translate([
        socket_offset * cos(azimuth),
        socket_offset * sin(azimuth),
        0
    ])
        rotate([0, socket_angle, azimuth + 180])
            translate([0, 0, -cutter_lead])
            cylinder(
                h = socket_depth + cutter_lead,
                d = socket_diameter
            );
}


module string_hook() {
    hook_face_radius = face_inradius_at(hook_bottom);

    // Local +Y points away from the face. Rotating the whole L bracket makes
    // its shelf and upturned lip follow the pyramid's face slope.
    translate([0, hook_face_radius, hook_bottom])
        rotate([body_face_slope, 0, 0]) {
            translate([-hook_width / 2, -hook_thickness, 0])
                rounded_xy_prism(
                    [
                        hook_width,
                        hook_projection + 2 * hook_thickness
                    ],
                    hook_thickness,
                    hook_edge_radius
                );

            translate([
                -hook_width / 2,
                hook_projection,
                0
            ])
                rotate([90, 0, 0])
                    rounded_xy_prism(
                        [hook_width, hook_lip_height],
                        hook_thickness,
                        hook_edge_radius
                    );
        }
}


function face_inradius_at(z) = profile_side_at(z) * sqrt(3) / 6;


module rounded_xy_prism(size, height, radius) {
    linear_extrude(height = height)
        offset(r = radius)
            offset(delta = -radius)
                square(size);
}


module assembly_preview() {
    preview_pole_color = [0.1, 0.5, 0.1, 0.45];
    guide_color = [0.1, 0.35, 0.9, 0.35];

    color(preview_pole_color)
        for (azimuth = [90, 210, 330])
            translate([
                socket_offset * cos(azimuth),
                socket_offset * sin(azimuth),
                0
            ])
                rotate([0, 180 - socket_angle, azimuth])
                    cylinder(h = exposed_pole_length, d = pole_diameter_mm);

    color(guide_color)
        translate([0, 0, -pole_vertical_run])
            rotate_extrude()
                translate([footprint_radius, 0, 0])
                    circle(d = 0.04 * inch, $fn = 20);
}
