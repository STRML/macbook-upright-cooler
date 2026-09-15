# Laptop reference geometry

The supplied 3D model supports a narrower center interface for V2. It does **not**
establish a production fit for the M5 Max. Measurements below describe surfaces in
a visualization mesh, including frames and covers, rather than certified vent
apertures. Inspected on September 15, 2026.

## What is confirmed

Apple specifies a **312.6 × 221.2 × 15.5 mm** outer envelope for the 2026 14-inch
M5 Pro/Max. Its service illustrations show two fans, their ducts, and a separate
rear vent/antenna module. Neither the specification nor the inspected service
pages provides dimensions for individual openings.

Sources: [Apple specifications](https://support.apple.com/en-gb/126318),
[Apple exploded view](https://support.apple.com/en-us/125815), and
[Apple vent module procedure](https://support.apple.com/en-us/125803).

SVALT, a cooling-hardware manufacturer, describes the 14-inch Pro/Max family as
having side intakes and a central hinge intake, with hot exhaust at both hinge
ends. Its separate base-M5 description identifies a single fan. This supports
the airflow concept but does not prove that the two models have identical vent
dimensions. [SVALT model guide](https://svalt.com/blogs/svalt/laptops).

## Supplied files and provenance

The two Downloads archives contain an open-lid model:

- `macbook_pro_14-inch_m5.zip`: `scene.gltf`, `scene.bin`, textures, and a license.
- `macbook-pro-14-inch-m5.zip`: `source/macbook_pro_14_inch_M5.glb` and textures.

The glTF metadata credits “Apple User” and links to
[MacBook Pro 14-inch M5 on Sketchfab](https://sketchfab.com/3d-models/macbook-pro-14-inch-m5-652a992f4f244122ae251f9cbb81da1e).
The archive entries date to October 15, 2025. This predates the 2026 M5 Pro/Max.
The metadata does not establish that this is an Apple engineering model.

Both formats contain 44 geometries and 163,918 triangles, with matching scene
bounds. At the glTF meter-to-millimeter scale, width is **311.730 mm**. Scaling
that width to Apple's envelope requires a factor of **1.00279135**. The values
below retain the original scale; scaling the whole mesh would not resolve its
model identity or modeling tolerances.

The originals remain in Downloads. They are not redistributed with the dock.
Archive SHA-256 values identify the inspected inputs:

```text
macbook_pro_14-inch_m5.zip
8e0a6a0f3d5dbc4d95af7a3dc4d497db02db5f969b665d1a111a3dfa906ae67f
macbook-pro-14-inch-m5.zip
23eaa3a1fac218d26dcd32061c8e82add21565c6362a2ae14dc4012e4c40db4a
```

## Geometry recovered from the mesh

Coordinates use X across the laptop, Y upward through its thickness, and Z from
the hinge toward the front. X = 0 is approximately the centerline. Apply each
scene-node transform before measuring vertices.

The connected surfaces of glTF node `Object_44` provide these bounds, in mm:

| Surface | X minimum | X maximum | Width |
|---|---:|---:|---:|
| Rear center-bank frame | −25.285 | 25.286 | 50.571 |
| Rear left-bank frame | −118.884 | −54.466 | 64.418 |
| Rear right-bank frame | 54.467 | 118.884 | 64.417 |
| Inner center-bank surface | −26.559 | 26.560 | 53.119 |

The rear frames extend from Y = −6.737 to 2.353 mm and Z = −104.820 to
−102.342 mm. Their height includes structure hidden by the hinge. **Do not use
9.09 mm as the clear clamshell opening height.** The hinge recess and closed-lid
occlusion still need measurement on the machine.

Node `Object_40` also has long side surfaces spanning Z = −20.200 to 86.475 mm.
These are visual backing surfaces, so their bounds do not establish side-intake
aperture dimensions.

To reproduce the measurements and orthographic reference image after extracting
the glTF archive, run:

```bash
python3 -m venv .venv
.venv/bin/pip install -r tools/requirements.txt
.venv/bin/python tools/inspect_reference.py /path/to/extracted/scene.gltf
```

The image is written to `build/upright_v2/reference.png`.

## V2 decisions and remaining fit checks

V1's 142 mm-wide outlet reaches X = ±71 mm. It would overlap both outer banks in
this asset. V1 remains preserved as a historical baseline; V2 uses an explicitly
experimental 44 × 8 mm center window and a blank insert for initial fit and leak
checks. This is a design choice inside the estimated center bank, not a measured
Mac aperture. A small port may also limit airflow; benchmark it before selecting
the final size or fan.

V2 keeps its raised central cradle inside a provisional X = ±52 mm exhaust
keepout and locates padded supports in the gaps beside the center bank. The seal
and supports are replaceable so that physical measurements can correct them.

Before cooling the laptop through the insert:

1. Confirm the center intake and both exhaust boundaries on the actual M5 Max.
2. Measure the closed-lid opening height and recess from the lowest hinge edge.
3. Check that padded stops land on solid chassis and keep rigid parts clear.
4. Verify gasket contact and airflow direction, then follow the
   [benchmark plan](BENCHMARK_PLAN.md).
