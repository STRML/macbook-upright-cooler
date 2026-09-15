// Upright V2 / llano V12 provisional validation geometry. Units: mm.
//
// This file is a gauge and hardware-layout study, not a certified or powered
// fit. The V12 cooler panels have not been fit-checked on the user's llano V12
// cooler, and the
// laptop's actual intake/exhaust geometry remains a measurement prerequisite.
// V12_W_TBD, V12_D_TBD, and V12_R_TBD intentionally retain the TBD suffix.
use <../upright_macbook_140mm_pressure_dock_v2.scad>

$fn = 64;

PART = "assembly";
EXPLODE = 0;
SHOW_REFERENCE = true;

// Legacy V12 outer panel profile. Confirmed from the existing STL envelope;
// re-measure the physical cooler before treating these as production values.
V12_W_TBD = 381;
V12_D_TBD = 269;
V12_R_TBD = 30;

// Unpowered coverage gauge. The rectangle is deliberately not a vent proxy.
V12_GAUGE_T = 1.2;
V12_GAUGE_OPEN_W_TBD = 291;
V12_GAUGE_OPEN_D_TBD = 170;
V12_GAUGE_OPEN_Y_TBD = 14.5;
V12_GAUGE_SEAM_GAP = 0.3; // total gap across each split seam

// Structural mating contract.
V12_DECK_T = 6;
V12_COLLAR_W = 190;
V12_COLLAR_D = 180;
V12_COLLAR_T = 6;
V12_COLLAR_R = 10;
V12_AIR_BORE_D = 136;
V12_SEAL_RECESS_D = 1.2;
V12_DECK_SEAM_GAP = 0.3; // total split gap; tabs detour around their cardinal axes

V12_M3_AXIS = 74;
V12_M3_D = 3.4;
V12_M3_CB_D = 8.2;
V12_M3_CB_DEPTH = 3.5;
V12_M3_WASHER_T = 0.5;

V12_M4_D = 4.6;
V12_M4_HEAD_D = 8.4;
V12_M4_CS_DEPTH = 2.2;
V12_M4_NUT_AF = 7.3;
V12_M4_NUT_H = 3.4;
// Starting fit allowance for the modeled-baseline M4 hex nut. This is an across-flats
// allowance, not a claim about any particular printer or hardware batch.
// Measure the purchased nuts and dry-fit a printed pocket before assembly.
V12_M4_NUT_CLEARANCE = 0.25;
// A small vertical allowance keeps the pocket roof from becoming the first
// interference when layer height, first-layer spread, or nut thickness varies.
V12_M4_NUT_Z_CLEARANCE = 0.20;

// `use` imports functions and modules, but not ordinary variables. Keep these
// accessors public so interface tests can exercise command-line overrides of
// the pocket contract without duplicating its modeled-baseline dimensions.
function v12_m4_nut_af() = V12_M4_NUT_AF;
function v12_m4_nut_h() = V12_M4_NUT_H;
function v12_m4_nut_clearance() = V12_M4_NUT_CLEARANCE;
function v12_m4_nut_z_clearance() = V12_M4_NUT_Z_CLEARANCE;

V12_TAB_R = 6.5;
V12_TAB_CLEAR_R = 6.8;

V12_BRIDGE_W = 44;
V12_BRIDGE_D = 24;
V12_BRIDGE_R = 3;
V12_BRIDGE_CENTERS = [
    [0, V12_D_TBD / 2 - 22.5],
    [0, -(V12_D_TBD / 2 - 22.5)],
    [V12_W_TBD / 2 - 26.5, 0],
    [-(V12_W_TBD / 2 - 26.5), 0]
];

// Original V2 upper stack placement. These values are intentionally explicit
// so this validation model does not depend on private imported globals.
V2_BASE_Z = 2 * V12_DECK_T;
V2_SHELL_Z = V2_BASE_Z + 5;
V2_LID_Z = V2_SHELL_Z + 40;
V2_CRADLE_Z = V2_LID_Z + 5;
V2_INSERT_T = 3;
V2_GASKET_FREE_H = 4;
V2_GASKET_COMPRESSED_H = 3;

V12_PARTS = [
    "gauge_ne", "gauge_nw", "gauge_sw", "gauge_se",
    "deck_ne", "deck_nw", "deck_sw", "deck_se", "deck",
    "collar", "bridge", "assembly", "gauge_assembly",
    "coupon_ne", "coupon_se", "coupon_collar"
];
V12_AXES = [
    [V12_M3_AXIS, 0], [0, V12_M3_AXIS],
    [-V12_M3_AXIS, 0], [0, -V12_M3_AXIS]
];
V12_COLLAR_M4 = [
    [82, 46], [82, -46], [-82, 46], [-82, -46],
    [44, 76], [44, -76], [-44, 76], [-44, -76]
];
V12_BRIDGE_HOLES = [
    [12, V12_BRIDGE_CENTERS[0][1]], [-12, V12_BRIDGE_CENTERS[0][1]],
    [12, V12_BRIDGE_CENTERS[1][1]], [-12, V12_BRIDGE_CENTERS[1][1]],
    [V12_BRIDGE_CENTERS[2][0], 12], [V12_BRIDGE_CENTERS[2][0], -12],
    [V12_BRIDGE_CENTERS[3][0], 12], [V12_BRIDGE_CENTERS[3][0], -12]
];

EPS = 0.02;

function v12_is_gauge_part(part) =
    part == "gauge_ne" || part == "gauge_nw" ||
    part == "gauge_sw" || part == "gauge_se" ||
    part == "gauge_assembly";

function v12_owner_axis(sx, sy) =
    sx > 0 && sy > 0 ? [V12_M3_AXIS, 0] :
    sx < 0 && sy > 0 ? [0, V12_M3_AXIS] :
    sx < 0 && sy < 0 ? [-V12_M3_AXIS, 0] :
    [0, -V12_M3_AXIS];

function v12_same_point(a, b) = a[0] == b[0] && a[1] == b[1];

assert(len([for (part = V12_PARTS) if (part == PART) part]) == 1,
       "Unknown PART selector");
assert(V12_W_TBD > V12_GAUGE_OPEN_W_TBD + 2 * V12_GAUGE_SEAM_GAP,
       "V12 outer width must exceed gauge opening");
assert(V12_D_TBD > V12_GAUGE_OPEN_D_TBD +
       2 * abs(V12_GAUGE_OPEN_Y_TBD) + 2 * V12_GAUGE_SEAM_GAP,
       "V12 outer depth must contain the offset gauge opening");
assert(V12_R_TBD > 0 && V12_R_TBD < min(V12_W_TBD, V12_D_TBD) / 2,
       "Invalid V12 outer corner radius");
assert(V12_GAUGE_T > 0 && V12_GAUGE_SEAM_GAP >= 0,
       "Invalid gauge thickness or seam gap");
assert(V12_GAUGE_OPEN_W_TBD > 0 && V12_GAUGE_OPEN_D_TBD > 0,
       "Invalid gauge opening");

// Gauge selectors remain useful for a later panel measurement even if a
// proposed structural footprint is temporarily too small for the collar.
if (!v12_is_gauge_part(PART)) {
    assert(V12_W_TBD >= V12_COLLAR_W && V12_D_TBD >= V12_COLLAR_D,
           "V12 footprint must contain the collar");
    assert(V12_COLLAR_W <= V12_W_TBD && V12_COLLAR_D <= V12_D_TBD,
           "Collar exceeds V12 footprint");
    assert(V12_AIR_BORE_D == 136,
           "V12 air bore must remain the fixed 136 mm mating contract");
    assert(V12_AIR_BORE_D < min(V12_COLLAR_W, V12_COLLAR_D),
           "Air bore must fit inside collar");
    assert(V12_COLLAR_T == V12_DECK_T,
           "Collar and deck thicknesses must match the two-layer stack");
    assert(2 * V12_SEAL_RECESS_D < V12_COLLAR_T,
           "Upper and lower collar seal recesses consume the collar");
    assert(V12_SEAL_RECESS_D > 0 && V12_SEAL_RECESS_D < V12_COLLAR_T / 2,
           "Invalid collar seal recess depth");
    assert(V12_M3_AXIS - V12_M3_CB_D / 2 - V12_AIR_BORE_D / 2 > 1.8,
           "M3 counterbore must clear the 136 mm bore by more than 1.8 mm");
    assert(V12_M3_CB_DEPTH > V12_M3_WASHER_T &&
           V12_M3_CB_DEPTH < V12_DECK_T,
           "M3 counterbore / washer stack is invalid");
    assert(V12_DECK_T > V12_M4_NUT_H,
           "Deck must be thick enough for underside M4 nuts");
    assert(V12_M4_CS_DEPTH > 0 && V12_M4_CS_DEPTH < V12_DECK_T,
           "Invalid M4 countersink depth");
    assert(V12_M4_NUT_CLEARANCE >= 0 && V12_M4_NUT_Z_CLEARANCE >= 0,
           "M4 nut clearances must be nonnegative");
    assert(V12_M4_NUT_AF > 0 && V12_M4_NUT_H > 0 &&
           V12_M4_NUT_H + V12_M4_NUT_Z_CLEARANCE < V12_DECK_T,
           "M4 nut pocket must leave a deck roof");
    assert(V12_TAB_CLEAR_R > V12_TAB_R && V12_TAB_R > V12_M3_CB_D / 2,
           "Tab and clearance radii are invalid");
    assert(V12_TAB_R + V12_M3_AXIS < V12_W_TBD / 2 &&
           V12_TAB_R + V12_M3_AXIS < V12_D_TBD / 2,
           "M3 tab must remain inside the V12 footprint");
    assert(V12_W_TBD / 2 + V12_TAB_R < 200 &&
           V12_D_TBD / 2 + V12_TAB_R < 200,
           "Structural tile maximum dimension including tabs must remain below 200 mm");
    assert(V12_BRIDGE_W > V12_M4_HEAD_D &&
           V12_BRIDGE_D > V12_M4_HEAD_D,
           "Bridge must contain its countersunk M4 heads");
    assert(V12_BRIDGE_D / 2 < V12_D_TBD / 2 &&
           V12_BRIDGE_W / 2 < V12_W_TBD / 2,
           "Bridge footprint exceeds V12 envelope");
    assert(V12_D_TBD / 2 - 22.5 > V12_BRIDGE_D / 2 &&
           V12_W_TBD / 2 - 26.5 > V12_BRIDGE_D / 2,
           "Bridge centers do not clear the V12 edge");
    assert(V12_D_TBD / 2 - 22.5 - V12_BRIDGE_D / 2 > V12_COLLAR_D / 2 &&
           V12_W_TBD / 2 - 26.5 - V12_BRIDGE_D / 2 > V12_COLLAR_W / 2,
           "Bridge pieces must clear the collar footprint");
}

module v12_rr(w, d, r) {
    offset(r = r) square([w - 2 * r, d - 2 * r], center = true);
}

module v12_slab(w, d, h, r) {
    linear_extrude(height = h) v12_rr(w, d, r);
}

module v12_bore(h, d) {
    translate([0, 0, -EPS]) cylinder(d = d, h = h + 2 * EPS);
}

module v12_hex_nut(af, h) {
    cylinder(d = af / cos(30), h = h, $fn = 6);
}

module v12_top_countersink(h, bore_d, head_d, depth) {
    translate([0, 0, h - depth])
        cylinder(d1 = bore_d, d2 = head_d, h = depth + EPS);
}

module v12_annulus(outer_d, inner_d, h) {
    difference() {
        cylinder(d = outer_d, h = h);
        translate([0, 0, -EPS]) cylinder(d = inner_d, h = h + 2 * EPS);
    }
}

module v12_quadrant_clip(sx, sy, seam_gap) {
    clip_w = V12_W_TBD / 2 - seam_gap / 2;
    clip_d = V12_D_TBD / 2 - seam_gap / 2;
    clip_x = sx * (V12_W_TBD / 4 + seam_gap / 4);
    clip_y = sy * (V12_D_TBD / 4 + seam_gap / 4);
    translate([clip_x, clip_y, V12_DECK_T / 2])
        cube([clip_w, clip_d, V12_DECK_T + 2 * EPS], center = true);
}

module v12_outer_quadrant_2d(sx, sy, seam_gap) {
    intersection() {
        v12_rr(V12_W_TBD, V12_D_TBD, V12_R_TBD);
        translate([
            sx * (V12_W_TBD / 4 + seam_gap / 4),
            sy * (V12_D_TBD / 4 + seam_gap / 4)
        ])
            square([
                V12_W_TBD / 2 - seam_gap / 2,
                V12_D_TBD / 2 - seam_gap / 2
            ], center = true);
    }
}

module v12_gauge_tile(sx, sy) {
    // The rectangular opening is only a foam-coverage gauge, not a vent model.
    difference() {
        linear_extrude(height = V12_GAUGE_T)
            v12_outer_quadrant_2d(sx, sy, V12_GAUGE_SEAM_GAP);
        translate([0, V12_GAUGE_OPEN_Y_TBD, V12_GAUGE_T / 2])
            cube([
                V12_GAUGE_OPEN_W_TBD,
                V12_GAUGE_OPEN_D_TBD,
                V12_GAUGE_T + 2 * EPS
            ], center = true);
    }
}

module v12_deck_m4_cuts() {
    for (p = concat(V12_COLLAR_M4, V12_BRIDGE_HOLES))
        translate([p[0], p[1], 0]) {
            v12_bore(V12_DECK_T, V12_M4_D);
            // Flat underside pocket for a standard M4 nut, not a through slot.
            translate([0, 0, -EPS])
                v12_hex_nut(V12_M4_NUT_AF + V12_M4_NUT_CLEARANCE,
                            V12_M4_NUT_H + V12_M4_NUT_Z_CLEARANCE + EPS);
        }
}

module v12_deck_tile(sx, sy) {
    owner = v12_owner_axis(sx, sy);
    difference() {
        // The owned tab is unioned before the common outer-profile clip.
        intersection() {
            union() {
                intersection() {
                    linear_extrude(height = V12_DECK_T)
                        v12_rr(V12_W_TBD, V12_D_TBD, V12_R_TBD);
                    v12_quadrant_clip(sx, sy, V12_DECK_SEAM_GAP);
                }
                translate([owner[0], owner[1], 0])
                    cylinder(r = V12_TAB_R, h = V12_DECK_T);
            }
            linear_extrude(height = V12_DECK_T)
                v12_rr(V12_W_TBD, V12_D_TBD, V12_R_TBD);
        }

        // Clearance circles are cut only for tabs owned by the other tiles.
        for (axis = V12_AXES)
            if (!v12_same_point(axis, owner))
                translate([axis[0], axis[1], -EPS])
                    cylinder(r = V12_TAB_CLEAR_R,
                             h = V12_DECK_T + 2 * EPS);

        // Common mating bore, then the single tile-owned M3 seat.
        v12_bore(V12_DECK_T, V12_AIR_BORE_D);
        translate([owner[0], owner[1], 0]) {
            v12_bore(V12_DECK_T, V12_M3_D);
            translate([0, 0, -EPS])
                cylinder(d = V12_M3_CB_D, h = V12_M3_CB_DEPTH + EPS);
        }
        v12_deck_m4_cuts();
    }
}

module v12_deck() {
    union() {
        v12_deck_tile(1, 1);
        v12_deck_tile(-1, 1);
        v12_deck_tile(-1, -1);
        v12_deck_tile(1, -1);
    }
}

module v12_collar_hardware_cuts() {
    for (p = V12_AXES)
        translate([p[0], p[1], 0]) v12_bore(V12_COLLAR_T, V12_M3_D);
    for (p = V12_COLLAR_M4)
        translate([p[0], p[1], 0]) {
            v12_bore(V12_COLLAR_T, V12_M4_D);
            v12_top_countersink(V12_COLLAR_T,
                                V12_M4_D, V12_M4_HEAD_D, V12_M4_CS_DEPTH);
        }
}

module v12_collar() {
    difference() {
        v12_slab(V12_COLLAR_W, V12_COLLAR_D,
                 V12_COLLAR_T, V12_COLLAR_R);
        v12_bore(V12_COLLAR_T, V12_AIR_BORE_D);
        // Continuous annular foam recess on both faces: 136..142 diameter.
        translate([0, 0, V12_COLLAR_T - V12_SEAL_RECESS_D])
            v12_annulus(142, V12_AIR_BORE_D, V12_SEAL_RECESS_D + EPS);
        translate([0, 0, -EPS])
            v12_annulus(142, V12_AIR_BORE_D, V12_SEAL_RECESS_D + EPS);
        v12_collar_hardware_cuts();
    }
}

module v12_joint_coupon(tile_kind) {
    // A 25 x 30 mm slice around the +74 mm cardinal joint. It is intentionally
    // global XY so the NE/SE/collar coupons can be compared without nesting.
    intersection() {
        if (tile_kind == "ne") v12_deck_tile(1, 1);
        else if (tile_kind == "se") v12_deck_tile(1, -1);
        else v12_collar();
        translate([76.5, 0, (V12_DECK_T - EPS) / 2])
            cube([25, 30, V12_DECK_T + EPS], center = true);
    }
}

module v12_bridge() {
    difference() {
        v12_slab(V12_BRIDGE_W, V12_BRIDGE_D,
                 V12_DECK_T, V12_BRIDGE_R);
        for (x = [-12, 12])
            translate([x, 0, 0]) {
                v12_bore(V12_DECK_T, V12_M4_D);
                v12_top_countersink(V12_DECK_T,
                                    V12_M4_D, V12_M4_HEAD_D,
                                    V12_M4_CS_DEPTH);
            }
    }
}

module v12_bridges() {
    for (i = [0:3]) {
        center = V12_BRIDGE_CENTERS[i];
        rotate_z = i < 2 ? 0 : 90;
        translate([center[0], center[1], V12_DECK_T])
            rotate([0, 0, rotate_z]) v12_bridge();
    }
}

module v12_upper() {
    // Imported V2 geometry only; no fan, feet, V12 body, or invented foam proxy.
    translate([0, 0, V2_BASE_Z]) base();
    translate([0, 0, V2_SHELL_Z]) shell();
    translate([0, 0, V2_LID_Z]) lid();
    translate([0, 0, V2_CRADLE_Z]) cradle();
    translate([0, 0, V2_CRADLE_Z]) seat() insert(false);
    translate([0, 0, V2_CRADLE_Z])
        seat() translate([0, 0, V2_INSERT_T])
            scale([1, 1, V2_GASKET_COMPRESSED_H / V2_GASKET_FREE_H])
                gasket();
}

module v12_reference_laptop() {
    // Preview-only copy of the original V2 external envelope proxy. It is not
    // V12 geometry and has no intake/exhaust openings or fit claim.
    color([0.65, 0.68, 0.72, 0.32])
        translate([0, 0, V2_CRADLE_Z]) seat()
            translate([0, 0, V2_INSERT_T + V2_GASKET_COMPRESSED_H])
                v12_slab(312.6, 15.5, 221.2, 3);
}

module v12_assembly() {
    explode_z = $preview ? EXPLODE : 0;
    color([0.18, 0.25, 0.29]) v12_deck();
    color([0.68, 0.70, 0.72])
        translate([0, 0, V12_DECK_T + explode_z]) v12_collar();
    color([0.82, 0.47, 0.18])
        translate([0, 0, explode_z]) v12_bridges();
    color([0.37, 0.43, 0.46])
        translate([0, 0, 2 * explode_z]) v12_upper();
    if ($preview && SHOW_REFERENCE && explode_z == 0)
        v12_reference_laptop();
}

module v12_gauge_assembly() {
    color([0.88, 0.60, 0.22, 0.55]) {
        v12_gauge_tile(1, 1);
        v12_gauge_tile(-1, 1);
        v12_gauge_tile(-1, -1);
        v12_gauge_tile(1, -1);
    }
}

if (PART == "gauge_ne") v12_gauge_tile(1, 1);
else if (PART == "gauge_nw") v12_gauge_tile(-1, 1);
else if (PART == "gauge_sw") v12_gauge_tile(-1, -1);
else if (PART == "gauge_se") v12_gauge_tile(1, -1);
else if (PART == "deck_ne") v12_deck_tile(1, 1);
else if (PART == "deck_nw") v12_deck_tile(-1, 1);
else if (PART == "deck_sw") v12_deck_tile(-1, -1);
else if (PART == "deck_se") v12_deck_tile(1, -1);
else if (PART == "deck") v12_deck();
else if (PART == "collar") v12_collar();
else if (PART == "bridge") v12_bridge();
else if (PART == "assembly") v12_assembly();
else if (PART == "gauge_assembly") v12_gauge_assembly();
else if (PART == "coupon_ne") v12_joint_coupon("ne");
else if (PART == "coupon_se") v12_joint_coupon("se");
else if (PART == "coupon_collar") v12_joint_coupon("collar");
