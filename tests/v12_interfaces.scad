// Independent checks of the default V2/V12 mating contract. Units: mm.
use <../cad/upright_v2/v12_validation/upright_v2_v12_validation.scad>
use <../cad/upright_v2/upright_macbook_140mm_pressure_dock_v2.scad>
$fn = 64;
TEST = "air_path";
CONTACT_PROBE_MM = 0.001;
QUADS = [[1,1],[-1,1],[-1,-1],[1,-1]];
M3_POINTS = [[74,0],[0,74],[-74,0],[0,-74]];
M4_COLLAR = concat([for(x=[-82,82]) for(y=[-46,46]) [x,y]],
                   [for(x=[-44,44]) for(y=[-76,76]) [x,y]]);
M4_BRIDGES = concat([for(x=[-12,12]) for(y=[-112,112]) [x,y]],
                    [for(x=[-164,164]) for(y=[-12,12]) [x,y]]);

module stack_lower() {
    v12_deck();
    translate([0,0,6]) v12_collar();
    translate([0,0,12]) base();
}
module collar_probe(overlap_mm=0) {
    // Lift the nominal Z=6 contact plane by the allowance. A positive overlap
    // argument deliberately moves the real collar into the real deck.
    translate([0,0,6 + CONTACT_PROBE_MM - overlap_mm]) v12_collar();
}
module base_probe() {
    translate([0,0,12 + CONTACT_PROBE_MM]) base();
}
module m3_hardware() {
    // 2.5 mm pan head, 0.5 mm washer, 16 mm under-head length.
    for(p=M3_POINTS) translate([p[0],p[1],0]) {
        translate([0,0,0.5]) cylinder(d=5.6,h=2.5);
        translate([0,0,3]) cylinder(d=7,h=0.5);
        translate([0,0,3]) cylinder(d=3,h=16);
    }
}
module m4_hardware() {
    // Conservative 8 mm head and 4 mm shank, flush at Z=12.
    for(p=concat(M4_COLLAR,M4_BRIDGES)) translate([p[0],p[1],0]) {
        cylinder(d=4,h=10);
        translate([0,0,10]) cylinder(d1=4,d2=8,h=2);
    }
}
module m4_hardware_probe() {
    // Keep the hardware dimensions unchanged; trim only its probe's top face
    // below the nominal Z=12 bridge plane to avoid coplanar CGAL contact.
    intersection() {
        m4_hardware();
        translate([0,0,(12 - CONTACT_PROBE_MM) / 2])
            cube([400,400,12 - CONTACT_PROBE_MM],center=true);
    }
}

if(TEST=="positive_control") cube([2,2,2]);
else if(TEST=="empty_control") intersection() {
    cube([1,1,1]); translate([2,0,0]) cube([1,1,1]);
}
else if(TEST=="positive_collision") intersection() {
    v12_deck(); collar_probe(0.1);
}
else if(TEST=="tile_overlap")
    for(i=[0:2]) for(j=[i+1:3]) intersection() {
        v12_deck_tile(QUADS[i][0],QUADS[i][1]);
        v12_deck_tile(QUADS[j][0],QUADS[j][1]);
    }
else if(TEST=="deck_collar") intersection() {
    v12_deck(); collar_probe();
}
else if(TEST=="base_collar") intersection() {
    base_probe(); translate([0,0,6]) v12_collar();
}
else if(TEST=="bridges_clear") intersection() {
    v12_bridges();
    union() { translate([0,0,6]) v12_collar(); v12_upper(); }
}
else if(TEST=="m3_hardware") intersection() { stack_lower(); m3_hardware(); }
else if(TEST=="m4_hardware") intersection() {
    union() { stack_lower(); v12_bridges(); }
    m4_hardware_probe();
}
else if(TEST=="air_path") intersection() {
    stack_lower();
    // Nearly the full 136 mm inlet, through adapter and unchanged V2 base.
    translate([0,0,-1]) cylinder(d=135.8,h=19);
}
else if(TEST=="gauge_window") intersection() {
    union() for(q=QUADS) v12_gauge_tile(q[0],q[1]);
    // A membrane over the window can still be a watertight STL.
    translate([0,14.5,0.6]) cube([290,169,1.3],center=true);
}
else if(TEST=="deck_material") difference() {
    // Check actual tile thickness away from tabs; a tall tab alone can hide
    // an accidentally half-height tile in an overall bounding-box check.
    for(x=[-110,110]) for(y=[-60,60])
        translate([x,y,3]) cube([2,2,5.8],center=true);
    v12_deck();
}
else assert(false,"Unknown interface test");
