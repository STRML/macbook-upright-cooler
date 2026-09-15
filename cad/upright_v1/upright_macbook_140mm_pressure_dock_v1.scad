// Upright 14-inch MacBook Pro pressure-cooling dock, v1
// Standard 140 mm fan mounts underneath and blows upward into a plenum.
// Short center rails guide a closed MacBook while leaving hinge-end exhaust areas open.
// Units: mm

$fn = 64;

BASE_W = 172;
BASE_D = 172;
BODY_Z0 = 45;          // bottom of plenum above desk
BODY_H = 55;
BODY_Z1 = BODY_Z0 + BODY_H;
OUTER_R = 12;
WALL = 3.6;
BOTTOM_SKIN = 4.5;
TOP_SKIN = 3.6;

// Standard 140 mm fan geometry
FAN_OPEN_D = 136;
FAN_HOLE_SPACING = 124.5;
FAN_HOLE_D = 4.6;

// Integrated feet. A 25 mm-thick fan hangs below the plenum, leaving ~20 mm intake clearance.
FOOT_W = 16;
FOOT_D = 16;
FOOT_H = BODY_Z0 + 2; // overlaps body by 2 mm
FOOT_INSET = 4;

// Outlet / gasket deck
OUTLET_W = 142;
OUTLET_D = 10;
DECK_W = 160;
DECK_D = 48;
DECK_T = 6;
DECK_Z0 = BODY_Z1 - 1.5; // overlap body

GASKET_OUTER_W = 154;
GASKET_OUTER_D = 26;
GASKET_INNER_W = OUTLET_W;
GASKET_INNER_D = OUTLET_D;
GASKET_RECESS = 1.5;

// Laptop guide channel (~15.5 mm Mac thickness + room for thin foam)
CHANNEL_W = 19;
RAIL_T = 5;
RAIL_H = 26;
RAIL_L = 154;
RAIL_OVERLAP = 1;

module rounded_box(w,d,h,r) {
    hull() {
        for (x=[-w/2+r, w/2-r])
            for (y=[-d/2+r, d/2-r])
                translate([x,y,0]) cylinder(r=r,h=h);
    }
}

module rounded_foot(w,d,h,r=2.5) {
    rounded_box(w,d,h,r);
}

module plenum_shell() {
    difference() {
        // Outer shell
        translate([0,0,BODY_Z0]) rounded_box(BASE_W, BASE_D, BODY_H, OUTER_R);

        // Large internal pressure chamber
        translate([0,0,BODY_Z0 + BOTTOM_SKIN])
            rounded_box(BASE_W - 2*WALL, BASE_D - 2*WALL,
                        BODY_H - BOTTOM_SKIN - TOP_SKIN, max(OUTER_R-WALL, 1));

        // Fan free-air opening through bottom skin
        translate([0,0,BODY_Z0 - 1]) cylinder(d=FAN_OPEN_D, h=BOTTOM_SKIN + 2);

        // Fan mount holes
        for (x=[-FAN_HOLE_SPACING/2, FAN_HOLE_SPACING/2])
            for (y=[-FAN_HOLE_SPACING/2, FAN_HOLE_SPACING/2])
                translate([x,y,BODY_Z0 - 1]) cylinder(d=FAN_HOLE_D, h=BOTTOM_SKIN + 3);

        // Top outlet through top skin
        translate([-OUTLET_W/2,-OUTLET_D/2,BODY_Z1-TOP_SKIN-1])
            cube([OUTLET_W, OUTLET_D, TOP_SKIN+3]);
    }
}

module feet() {
    for (x=[-(BASE_W/2 - FOOT_INSET - FOOT_W/2), (BASE_W/2 - FOOT_INSET - FOOT_W/2)])
        for (y=[-(BASE_D/2 - FOOT_INSET - FOOT_D/2), (BASE_D/2 - FOOT_INSET - FOOT_D/2)])
            translate([x-FOOT_W/2, y-FOOT_D/2, 0])
                rounded_foot(FOOT_W,FOOT_D,FOOT_H,2.5);
}

module gasket_deck() {
    difference() {
        translate([0,0,DECK_Z0]) rounded_box(DECK_W, DECK_D, DECK_T, 4);

        // Air outlet
        translate([-OUTLET_W/2,-OUTLET_D/2,DECK_Z0-1])
            cube([OUTLET_W,OUTLET_D,DECK_T+3]);

        // Shallow gasket-ring recess
        translate([-GASKET_OUTER_W/2,-GASKET_OUTER_D/2,
                   DECK_Z0 + DECK_T - GASKET_RECESS])
            difference() {
                cube([GASKET_OUTER_W,GASKET_OUTER_D,GASKET_RECESS+0.2]);
                translate([(GASKET_OUTER_W-GASKET_INNER_W)/2,
                           (GASKET_OUTER_D-GASKET_INNER_D)/2,-0.1])
                    cube([GASKET_INNER_W,GASKET_INNER_D,GASKET_RECESS+0.4]);
            }
    }
}

module rail(ycenter) {
    // Simple robust rail with a little lead-in chamfer made by hulling two profiles.
    z0 = DECK_Z0 + DECK_T - RAIL_OVERLAP;
    hull() {
        translate([-RAIL_L/2, ycenter-RAIL_T/2, z0])
            cube([RAIL_L, RAIL_T, RAIL_H-3]);
        translate([-RAIL_L/2+1.5, ycenter-RAIL_T/2+1, z0+RAIL_H-3])
            cube([RAIL_L-3, RAIL_T-2, 3]);
    }
}

module dock() {
    difference() {
        union() {
            plenum_shell();
            feet();
            gasket_deck();
            rail(CHANNEL_W/2 + RAIL_T/2);
            rail(-(CHANNEL_W/2 + RAIL_T/2));
        }

        // Cable notch through the rear-right foot area
        translate([BASE_W/2-18, BASE_D/2-12, 10])
            cube([20,16,11], center=true);
    }
}

dock();
