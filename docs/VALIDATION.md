# V2 and V12 adapter validation record

Checked September 15, 2026 with OpenSCAD 2026.01.02 (Manifold, macOS x86_64),
Python 3.12, and trimesh 5.1.0. These are digital geometry checks, not physical
test results.

The Python checks were repeated in a clean virtual environment with only
`tools/requirements.txt` installed. All five validator regression tests and
the nine rebuilt and published V2 meshes pass. NetworkX is declared explicitly
because trimesh's connected-solid checks need a graph backend.

## Export checks

`make stl-v2` and `make check-v2` pass for all nine default parts. Each export is
a single connected solid with finite coordinates, consistent winding, positive
volume, and a watertight surface. The [assembly guide](../cad/upright_v2/README.md)
lists each measured envelope and print quantity. The assembled printed envelope
is 190 × 180 × 129.24 mm at 10° lean.

The cradle was also exported at 8° and 12° lean and passed the same checks:

| Lean | Cradle envelope, mm |
|---|---|
| 8° | 96 × 64 × 29.46 |
| 10° | 96 × 64 × 29.24 |
| 12° | 96 × 64 × 29.62 |

Boolean intersection checks found no volumetric interference in the default
assembly between the cradle/insert, cradle/laptop envelope, base/cartridge,
shell/lid, cartridge/feet, cradle/lid, shell/base, compressed gasket/laptop
envelope, or keyed feet/base. A 1 mm centerline probe passes through the open
insert and rigid air path. The four lower shell fixings clear a 7 mm diameter,
3 mm tall screw-head envelope. Cradle/insert, cradle/laptop, and centerline checks
also pass at 8° and 12°. Coplanar contact produced numerical fragments below
0.000001 mm³ in two checks; those are not physical interference.

Assembly and exploded PNGs were rendered from the final CAD and visually checked.
The laptop is only an external-envelope proxy, with no modeled vent openings.

## V12 adapter checks

`make stl-v12` and `make check-v12` pass for all 13 default adapter parts: four
gauges, three joint coupons, four deck tiles, a collar, and a bridge. Each is a
watertight single solid with consistent winding, positive volume, and finite
coordinates. The [adapter guide](../cad/upright_v2/v12_validation/README.md) lists
measured print envelopes and quantities. The assembled printed envelope is
381 × 269 × 91.24 mm, excluding the laptop and V12 cooler.

The 16 cases in `tools/check_v12.py` include an 8 mm³ positive control, an empty
negative control, and intentionally overlapping real deck/collar and oversized
nut-pocket controls. The remaining cases check tile overlap, deck/collar and
base/collar contact, bridge clearance, separate M3 and M4 screw envelopes, the
full lower inlet, an unobstructed gauge window, actual deck material thickness
away from the tabs, and nut fit in all 16 M4 pockets. The nut-fit case models a
modeled-baseline hex nut plus a documented AF/height test allowance and intersects that
solid with the actual deck, so both pocket walls and the roof are checked. Two
additional runs set the source lateral or vertical allowance to zero and must
fail with a collision, proving the check is sensitive to undersized or
too-shallow pockets. This models a conservative starting envelope, not all FDM
layer, first-layer, printer, or hardware variation; purchased nuts still need
a physical dry-fit. The nearly flush M4 × 12 stack also requires a printed
hardware check.

The first Linux run rebuilt all 13 parts successfully, but CGAL exported the
intentional contact planes in three interface tests as zero-thickness surfaces.
Those probes now exclude 0.001 mm at the intended contact plane; print geometry
is unchanged. Moving the collar probe down 0.1 mm creates 0.099 mm of real
deck/collar overlap, which must still produce positive volume. Warning failures
remain enabled, so unrelated export problems cannot pass as empty intersections.
These probes check interference beyond that stated
allowance, not mathematical separation at an exact shared face.

Assembly, exploded, and gauge previews were rendered from the final source and
visually checked. The gauge preview contains only its four unloaded pieces; it
does not imply that the gauge supports the laptop. Original V2 CAD and STL
snapshots are unchanged. Desk clearance and lid-rib changes are deferred.

The adapter is still an unpowered fit/construction prototype. The legacy cooler
outline has not been fit-checked; deck support, seal compression, housing
restraint, printed joint strength, and stability remain physical prerequisites.
The 1.9 mm M3 recess-to-inlet ligament needs a coupon test before a full print.
Digital noninterference does not establish these properties.

## V1 preservation

`make stl` still rebuilds V1 as a watertight solid measuring
176 × 176 × 129.5 mm. Its source and checked-in STL are unchanged:

```text
e432872113be753e4f137b082bf2ea03bc9675405cee6762a64ffd6b11a1ef1b  V1 SCAD
7eab28b8b06bcefbfc5c955d842ac215d595b83e85731d4f61e71c814b38869b  V1 STL
```

## What remains untested

- Actual M5 Max vent boundaries, closed-hinge recess, and padded contact points.
- Printed tolerances, layer strength, lid deflection, stability, and cable loads.
- Gasket compression, seam and fastener leaks, exhaust recirculation.
- Fan pressure/flow, acoustics, and sustained workload performance.

Use the blank insert for the first fit and leakage checks. Install all soft pads,
load-test with a dummy, and fit a fan guard before powered bench testing. A
watertight mesh does not prove that an FDM print or its joints are airtight.
Follow the [assembly guide](../cad/upright_v2/README.md) and
[benchmark plan](BENCHMARK_PLAN.md).
