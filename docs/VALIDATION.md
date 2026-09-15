# V2 validation record

Checked September 15, 2026 with OpenSCAD 2026.01.02 (Manifold, macOS x86_64),
Python 3.12, and trimesh 5.1.0. These are digital geometry checks, not physical
test results.

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
