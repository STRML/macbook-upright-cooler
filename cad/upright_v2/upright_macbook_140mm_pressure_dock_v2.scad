// Upright V2 modular fit-check prototype. Units: mm.
// X across hinge, +Y rearward lean, Z above desk.
// See README.md here and ../../docs/VENT_GEOMETRY.md.
// The base-M5 visualization is not certified M5 Max vent geometry.
$fn = 64;
PART = "assembly";
EXPLODE = 0;
SHOW_REFERENCE = true;
INTERFACE_OPEN = false; // blank for initial fit / leakage checks

BASE_W = 190;
BASE_D = 180;
BASE_T = 5;
WALL = 4;
SHELL_H = 40;
TOP_W = 176;
TOP_D = 104;
LID_W = 180;
LID_D = 108;
LID_T = 5;

FAN_SIZE = 140;
FAN_T = 25;
FAN_HOLE_SPACING = 124.5;
FAN_HOLE_D = 4.6;
FAN_OPEN_D = 136;
CARTRIDGE_W = 158;
CARTRIDGE_T = 5;
DESK_INTAKE_CLEARANCE = 20;
FOOT_W = 14;
FOOT_X = 87;
FOOT_Y = 82;

LEAN_DEG = 10; // supported range 8..12
CHANNEL_W = 19; // prototype clearance; pad both guide faces
GUIDE_PAD_T = 1;
GUIDE_W = 12;
GUIDE_T = 5;
GUIDE_X = 42;
GUIDE_FRONT_H = 18;
GUIDE_REAR_H = 22;
CRADLE_W = 96;
CRADLE_D = 64;
CRADLE_BASE_T = 4;
SEAT_Z = 9;
PORT_W = 54;
PORT_D = 24;
SEAT_PORT_W = 48;
SEAT_PORT_D = 18;

// Measurement-dependent interface. Defaults below are prototype choices.
INTAKE_CENTER_X_TBD = 0;
INTAKE_W_TBD = 44;
INTAKE_D_TBD = 8;
EXHAUST_START_ABS_X_TBD = 52; // raised cradle stays inside this boundary
INSERT_W = 64;
INSERT_D = 42;
INSERT_T = 3;
GASKET_W = 60;
GASKET_D = 22;
GASKET_FREE_H = 4;
GASKET_COMPRESSED_H = 3;
STOP_PAD_T = 1;
CONTACT_Z = INSERT_T + GASKET_COMPRESSED_H;
STOP_H = CONTACT_Z - STOP_PAD_T;

M3_D = 3.4;
M3_NUT_AF = 5.8; // 5.5 mm nominal plus print allowance
M3_NUT_H = 2.8;
M4_NUT_AF = 7.3;
M4_NUT_H = 3.4;
SEAL_RECESS = 1.2; // foam must compress into recess so rigid faces seat
EPS = 0.02;

FOOT_H = DESK_INTAKE_CLEARANCE + FAN_T + CARTRIDGE_T;
BASE_Z = FOOT_H;
SHELL_Z = BASE_Z + BASE_T;
LID_Z = SHELL_Z + SHELL_H;
CRADLE_Z = LID_Z + LID_T;
CARTRIDGE_Z = BASE_Z - CARTRIDGE_T;
SHELL_FIX = [[-85,-65],[-85,65],[85,-65],[85,65]];
LID_FIX = [[-76,-42],[-76,42],[76,-42],[76,42]];
CART_FIX = [[-74,0],[74,0],[0,-74],[0,74]];
CRADLE_FIX = [[-41,-28],[-41,28],[41,-28],[41,28]];
INSERT_FIX = [[-25,-16],[-25,16],[25,-16],[25,16]];
PARTS = ["assembly","shell","base","cartridge","lid","cradle",
         "insert_blank","insert_open","gasket","foot"];

assert(len([for (p=PARTS) if (p==PART) p]) == 1, "Unknown PART");
assert(LEAN_DEG>=8 && LEAN_DEG<=12, "LEAN_DEG must be 8..12");
assert(WALL>=3 && WALL<=5, "WALL must be 3..5 for the fixing bosses");
assert(FAN_T>0 && DESK_INTAKE_CLEARANCE>=15, "Invalid fan / desk clearance");
assert(FOOT_X-FOOT_W/2>CARTRIDGE_W/2, "Cartridge must clear feet");
assert(FAN_SIZE/2<74-M3_D/2, "Fan frame obstructs cartridge screws");
assert(FAN_HOLE_SPACING+FAN_HOLE_D<CARTRIDGE_W, "Fan holes exceed carrier");
assert(CHANNEL_W-2*GUIDE_PAD_T>15.5, "Channel needs padded insertion clearance");
assert(CRADLE_W/2<EXHAUST_START_ABS_X_TBD, "Cradle enters exhaust keepout");
assert(INTAKE_W_TBD>=4 && abs(INTAKE_CENTER_X_TBD)+INTAKE_W_TBD/2+3<=GASKET_W/2,
       "Keep at least 3 mm of gasket beside the inlet");
assert(INTAKE_D_TBD>=4 && INTAKE_D_TBD+6<=GASKET_D, "Invalid inlet depth");
assert(abs(INTAKE_CENTER_X_TBD)+INTAKE_W_TBD/2<=SEAT_PORT_W/2 &&
       INTAKE_D_TBD<=SEAT_PORT_D, "Inlet exceeds the cradle air path");
assert(GASKET_FREE_H>GASKET_COMPRESSED_H && GASKET_COMPRESSED_H>0 && STOP_H>0,
       "Invalid stop/seal stack");

module rr(w,d,r=3) { offset(r=r) square([w-2*r,d-2*r],center=true); }
module slab(w,d,h,r=3) { linear_extrude(height=h) rr(w,d,r); }
module at_points(points) { for (p=points) translate([p[0],p[1],0]) children(); }
module bore(h,d=M3_D) { translate([0,0,-EPS]) cylinder(d=d,h=h+2*EPS); }
module nut(af=M3_NUT_AF,h=M3_NUT_H) { cylinder(d=af/cos(30),h=h,$fn=6); }
module countersink(top) {
    translate([0,0,top-1.6]) cylinder(d1=M3_D,d2=6.6,h=1.6+EPS);
}
module rectangular_seal(ow,od,iw,id,h=SEAL_RECESS,r=7,ir=5) {
    difference() {
        slab(ow,od,h,r);
        translate([0,0,-EPS]) slab(iw,id,h+2*EPS,ir);
    }
}
module seat() { translate([0,0,SEAT_Z]) rotate([-LEAN_DEG,0,0]) children(); }

module base() {
    difference() {
        slab(BASE_W,BASE_D,BASE_T,10);
        bore(BASE_T,FAN_OPEN_D);
        at_points(SHELL_FIX) { bore(BASE_T); nut(h=M3_NUT_H+EPS); }
        at_points(CART_FIX) {
            bore(BASE_T);
            translate([0,0,BASE_T-M3_NUT_H]) nut(h=M3_NUT_H+EPS);
        }
        // Separate countersunk foot screws; install before the shell.
        for (x=[-FOOT_X,FOOT_X]) for (y=[-FOOT_Y,FOOT_Y])
            translate([x,y,0]) {
                bore(BASE_T); countersink(BASE_T);
                translate([0,0,-EPS]) slab(10.5,10.5,2.2+EPS,2.25);
            }
        translate([0,0,BASE_T-SEAL_RECESS])
            rectangular_seal(188,178,184,174,SEAL_RECESS+EPS,9,7);
    }
}

module tapered(w0,d0,w1,d1,h,r0=10,r1=8,extra=0) {
    hull() {
        translate([0,0,-extra]) slab(w0,d0,EPS,r0);
        translate([0,0,h-EPS+extra]) slab(w1,d1,EPS,r1);
    }
}
module shell() {
    difference() {
        union() {
            difference() {
                tapered(BASE_W,BASE_D,TOP_W,TOP_D,SHELL_H);
                tapered(BASE_W-2*WALL,BASE_D-2*WALL,
                        TOP_W-2*WALL,TOP_D-2*WALL,SHELL_H,
                        10-WALL,8-WALL,EPS);
            }
            // Short lower bosses grow from the build plate into the wall.
            at_points(SHELL_FIX) cylinder(r=8,h=8);
            // Sloping upper bosses grow from the side wall, without floating pads.
            for (p=LID_FIX) hull() {
                translate([sign(p[0])*90,p[1],SHELL_H-24]) cylinder(r=2,h=EPS);
                translate([p[0],p[1],SHELL_H-EPS]) cylinder(r=6,h=EPS);
            }
        }
        at_points(SHELL_FIX) bore(8);
        at_points(LID_FIX) {
            translate([0,0,SHELL_H-12]) bore(12);
            translate([0,0,SHELL_H-M3_NUT_H]) nut(h=M3_NUT_H+EPS);
        }
    }
}

module cartridge() {
    difference() {
        slab(CARTRIDGE_W,CARTRIDGE_W,CARTRIDGE_T,5);
        bore(CARTRIDGE_T,FAN_OPEN_D);
        at_points(CART_FIX) bore(CARTRIDGE_T);
        for (x=[-FAN_HOLE_SPACING/2,FAN_HOLE_SPACING/2])
            for (y=[-FAN_HOLE_SPACING/2,FAN_HOLE_SPACING/2])
                translate([x,y,0]) {
                    bore(CARTRIDGE_T,FAN_HOLE_D);
                    translate([0,0,CARTRIDGE_T-M4_NUT_H])
                        nut(M4_NUT_AF,M4_NUT_H+EPS);
                }
        translate([0,0,CARTRIDGE_T-SEAL_RECESS]) difference() {
            cylinder(d=144,h=SEAL_RECESS+EPS);
            translate([0,0,-EPS]) cylinder(d=136,h=SEAL_RECESS+3*EPS);
        }
    }
}

module lid() {
    difference() {
        slab(LID_W,LID_D,LID_T,8);
        translate([0,0,-EPS]) slab(PORT_W,PORT_D,LID_T+2*EPS,3);
        at_points(LID_FIX) bore(LID_T);
        at_points(CRADLE_FIX) { bore(LID_T); nut(h=M3_NUT_H+EPS); }
        translate([0,0,-EPS])
            rectangular_seal(174,102,170,98,SEAL_RECESS+EPS,7,5);
        translate([0,0,LID_T-SEAL_RECESS])
            rectangular_seal(68,38,58,28,SEAL_RECESS+EPS,7,2);
    }
}

module cradle() {
    difference() {
        union() {
            slab(CRADLE_W,CRADLE_D,CRADLE_BASE_T,4);
            hull() {
                slab(CRADLE_W,50,EPS,4);
                seat() translate([0,0,-EPS]) slab(CRADLE_W,50,EPS,4);
            }
            seat() for (x=[-GUIDE_X,GUIDE_X]) {
                translate([x,0,-EPS]) slab(GUIDE_W,18,STOP_H+EPS,2);
                for (s=[-1,1])
                    translate([x,s*(CHANNEL_W+GUIDE_T)/2,-EPS])
                        slab(GUIDE_W,GUIDE_T,
                             (s>0 ? GUIDE_REAR_H : GUIDE_FRONT_H)+EPS,1.5);
            }
        }
        // Continuous path from flat lid port to the tilted insert.
        hull() {
            translate([0,0,-1]) slab(PORT_W,PORT_D,EPS,3);
            seat() slab(SEAT_PORT_W,SEAT_PORT_D,1,2);
        }
        at_points(CRADLE_FIX) { bore(CRADLE_BASE_T); countersink(CRADLE_BASE_T); }
        seat() at_points(INSERT_FIX) {
            translate([0,0,-5]) bore(5);
            translate([0,0,-M3_NUT_H]) nut(h=M3_NUT_H+EPS);
        }
        seat() translate([0,0,-SEAL_RECESS])
            rectangular_seal(58,24,50,20,SEAL_RECESS+EPS,3,1);
    }
}

module inlet(h) {
    translate([INTAKE_CENTER_X_TBD,0,-EPS])
        slab(INTAKE_W_TBD,INTAKE_D_TBD,h+2*EPS,2);
}
module insert(open_mode=false) {
    difference() {
        slab(INSERT_W,INSERT_D,INSERT_T,3);
        if (open_mode) inlet(INSERT_T);
        at_points(INSERT_FIX) { bore(INSERT_T); countersink(INSERT_T); }
        // A notch distinguishes the experimental insert by touch.
        if (open_mode) translate([0,-INSERT_D/2,0]) bore(INSERT_T,3);
    }
}
module gasket() {
    difference() { slab(GASKET_W,GASKET_D,GASKET_FREE_H,3); inlet(GASKET_FREE_H); }
}
module foot() {
    difference() {
        union() {
            slab(FOOT_W,FOOT_W,FOOT_H,2.5);
            // Square tongue prevents rotation while the cartridge is serviced.
            translate([0,0,FOOT_H-EPS]) slab(10,10,2+EPS,2);
        }
        translate([0,0,FOOT_H-16]) bore(18);
        translate([0,0,FOOT_H-M3_NUT_H]) nut(h=M3_NUT_H+2+EPS);
        // Cable-tie passage through each foot, outside the pressure chamber.
        translate([0,0,8]) rotate([90,0,0])
            cylinder(d=4,h=FOOT_W+2,center=true);
    }
}

module references() {
    // Official external envelope only; this proxy contains no vent openings.
    color([0.65,0.68,0.72,0.32])
        translate([0,0,CRADLE_Z]) seat() translate([0,0,CONTACT_Z])
            slab(312.6,15.5,221.2,3);
    color([0.12,0.13,0.14]) translate([0,0,DESK_INTAKE_CLEARANCE]) difference() {
        slab(FAN_SIZE,FAN_SIZE,FAN_T,4);
        translate([0,0,-EPS]) cylinder(d=130,h=FAN_T+2*EPS);
    }
    color([0.24,0.26,0.28]) translate([0,0,DESK_INTAKE_CLEARANCE+FAN_T/2]) {
        cylinder(d=38,h=3);
        for (a=[0:45:315]) rotate([0,0,a])
            translate([36,0,0]) rotate([0,0,25]) slab(45,15,2,4);
    }
    color([0.78,0.43,0.21]) translate([0,0,CRADLE_Z]) seat()
        for (x=[-GUIDE_X,GUIDE_X])
            translate([x,0,STOP_H]) slab(GUIDE_W,18,STOP_PAD_T,2);
}

module assembly() {
    e = $preview ? EXPLODE : 0;
    color([0.25,0.29,0.32]) translate([0,0,BASE_Z]) base();
    color([0.39,0.46,0.49]) translate([0,0,SHELL_Z+e]) shell();
    color([0.25,0.29,0.32]) translate([0,0,LID_Z+2*e]) lid();
    color([0.20,0.24,0.27]) translate([0,0,CARTRIDGE_Z-e]) cartridge();
    color([0.20,0.24,0.27]) for (x=[-FOOT_X,FOOT_X]) for (y=[-FOOT_Y,FOOT_Y])
        translate([x,y,0]) foot();
    color([0.29,0.34,0.37]) translate([0,0,CRADLE_Z+3*e]) cradle();
    color([0.56,0.62,0.64]) translate([0,0,CRADLE_Z+4*e]) seat() insert(INTERFACE_OPEN);
    color([0.78,0.43,0.21]) translate([0,0,CRADLE_Z+5*e]) seat()
        translate([0,0,INSERT_T]) scale([1,1,GASKET_COMPRESSED_H/GASKET_FREE_H]) gasket();
    if ($preview && SHOW_REFERENCE && e==0) references();
}

if (PART=="assembly") assembly();
else if (PART=="shell") shell();
else if (PART=="base") base();
else if (PART=="cartridge") cartridge();
else if (PART=="lid") lid();
else if (PART=="cradle") cradle();
else if (PART=="insert_blank") insert(false);
else if (PART=="insert_open") insert(true);
else if (PART=="gasket") gasket();
else if (PART=="foot") foot();
