import cadquery as cq
from cadquery import exporters

# Upright pressure-cooling dock for a 14-inch MacBook Pro.
# Concept prototype: standard 140 mm fan underneath, central pressure plenum,
# short laptop guide rails, and a recessed foam-gasket land around the outlet.
# Units are millimeters.

# ---------- Parameters ----------
BASE_W = 180.0
BASE_D = 180.0
PLENUM_BOTTOM_Z = 45.0
PLENUM_H = 78.0
PLENUM_TOP_Z = PLENUM_BOTTOM_Z + PLENUM_H
OUTER_R = 14.0
WALL = 5.0
TOP_SKIN = 4.0
BOTTOM_SKIN = 5.0

# Standard 140 mm fan mounting
FAN_OPEN_D = 136.0
FAN_HOLE_SPACING = 124.5
FAN_HOLE_D = 4.6

# Feet leave ~20 mm clear below a 25 mm thick fan
FOOT_W = 25.0
FOOT_D = 25.0
FOOT_H = PLENUM_BOTTOM_Z + 3.0  # overlaps plenum for a robust union
FOOT_INSET = 13.0

# Air outlet / gasket
OUTLET_W = 146.0
OUTLET_D = 10.0
DECK_W = 166.0
DECK_D = 52.0
DECK_T = 7.0
DECK_Z0 = PLENUM_TOP_Z - 2.0    # 2 mm overlap into plenum top
GASKET_OUTER_W = 158.0
GASKET_OUTER_D = 28.0
GASKET_INNER_W = 146.0
GASKET_INNER_D = 10.0
GASKET_RECESS = 1.6

# Laptop guide rails. 14-inch MBP is ~15.5 mm thick; 19 mm leaves room for foam.
CHANNEL_W = 19.0
RAIL_T = 5.0
RAIL_H = 28.0
RAIL_L = 158.0
RAIL_OVERLAP = 1.0


def box(w, d, h, z0=0.0):
    return (cq.Workplane("XY")
            .box(w, d, h, centered=(True, True, False))
            .translate((0, 0, z0)))


def rounded_outer(w, d, h, z0=0.0, radius=0.0):
    s = box(w, d, h, z0)
    if radius > 0:
        try:
            s = s.edges("|Z").fillet(radius)
        except Exception:
            pass
    return s


# ---------- Plenum shell ----------
outer = rounded_outer(BASE_W, BASE_D, PLENUM_H, PLENUM_BOTTOM_Z, OUTER_R)

# Large internal cavity. A simple pressure box is intentional: it is cheap to print
# and lets the fan work against the MacBook/gasket restriction instead of a narrow duct.
inner = box(
    BASE_W - 2 * WALL,
    BASE_D - 2 * WALL,
    PLENUM_H - BOTTOM_SKIN - TOP_SKIN,
    PLENUM_BOTTOM_Z + BOTTOM_SKIN,
)
plenum = outer.cut(inner)

# Fan free-air opening through the bottom skin.
fan_open = (cq.Workplane("XY", origin=(0, 0, PLENUM_BOTTOM_Z - 1.0))
            .circle(FAN_OPEN_D / 2)
            .extrude(BOTTOM_SKIN + 2.0))
plenum = plenum.cut(fan_open)

# Standard 140 mm fan bolt holes.
for x in (-FAN_HOLE_SPACING / 2, FAN_HOLE_SPACING / 2):
    for y in (-FAN_HOLE_SPACING / 2, FAN_HOLE_SPACING / 2):
        hole = (cq.Workplane("XY", origin=(x, y, PLENUM_BOTTOM_Z - 1.0))
                .circle(FAN_HOLE_D / 2)
                .extrude(BOTTOM_SKIN + 3.0))
        plenum = plenum.cut(hole)

# Top air outlet through plenum top skin.
top_outlet = (cq.Workplane("XY", origin=(0, 0, PLENUM_TOP_Z - TOP_SKIN - 1.0))
              .rect(OUTLET_W, OUTLET_D)
              .extrude(TOP_SKIN + 4.0))
plenum = plenum.cut(top_outlet)

# ---------- Feet ----------
model = plenum
for sx in (-1, 1):
    for sy in (-1, 1):
        x = sx * (BASE_W / 2 - FOOT_INSET - FOOT_W / 2)
        y = sy * (BASE_D / 2 - FOOT_INSET - FOOT_D / 2)
        foot = rounded_outer(FOOT_W, FOOT_D, FOOT_H, 0.0, 3.0).translate((x, y, 0))
        model = model.union(foot)

# Cable relief in rear-right foot.
relief_x = BASE_W / 2 - FOOT_INSET - FOOT_W / 2
relief_y = BASE_D / 2 - FOOT_INSET - FOOT_D / 2
cable_relief = (cq.Workplane("XZ", origin=(relief_x, relief_y, 13.0))
                .rect(10.0, 10.0)
                .extrude(FOOT_D + 4.0, both=True))
model = model.cut(cable_relief)

# ---------- Top deck ----------
deck = rounded_outer(DECK_W, DECK_D, DECK_T, DECK_Z0, 5.0)
deck_outlet = (cq.Workplane("XY", origin=(0, 0, DECK_Z0 - 1.0))
               .rect(OUTLET_W, OUTLET_D)
               .extrude(DECK_T + 3.0))
deck = deck.cut(deck_outlet)
model = model.union(deck)

# Shallow ring recess for adhesive foam gasket.
recess_outer = (cq.Workplane("XY", origin=(0, 0, DECK_Z0 + DECK_T - GASKET_RECESS))
                .rect(GASKET_OUTER_W, GASKET_OUTER_D)
                .extrude(GASKET_RECESS + 0.3))
recess_inner = (cq.Workplane("XY", origin=(0, 0, DECK_Z0 + DECK_T - GASKET_RECESS - 0.1))
                .rect(GASKET_INNER_W, GASKET_INNER_D)
                .extrude(GASKET_RECESS + 0.5))
model = model.cut(recess_outer.cut(recess_inner))

# ---------- Laptop guide rails ----------
rail_y = CHANNEL_W / 2 + RAIL_T / 2
rail_z0 = DECK_Z0 + DECK_T - RAIL_OVERLAP
for sy in (-1, 1):
    rail = box(RAIL_L, RAIL_T, RAIL_H + RAIL_OVERLAP, rail_z0).translate((0, sy * rail_y, 0))
    try:
        rail = rail.edges("|Z").fillet(1.25)
    except Exception:
        pass
    # chamfer the upper edges to make insertion easier
    try:
        rail = rail.faces(">Z").edges().chamfer(2.0)
    except Exception:
        pass
    model = model.union(rail)

# ---------- Export ----------
out_stl = "/mnt/data/upright_macbook_140mm_pressure_dock_v1.stl"
out_step = "/mnt/data/upright_macbook_140mm_pressure_dock_v1.step"
exporters.export(model, out_stl, tolerance=0.12, angularTolerance=0.15)
exporters.export(model, out_step)

bb = model.val().BoundingBox()
print(f"STL:  {out_stl}")
print(f"STEP: {out_step}")
print(f"Bounding box: {bb.xlen:.1f} x {bb.ylen:.1f} x {bb.zlen:.1f} mm")
print(f"CAD volume: {model.val().Volume()/1000:.1f} cm^3")
