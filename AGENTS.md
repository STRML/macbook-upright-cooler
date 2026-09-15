# Agent Instructions

This repository contains a physical prototype for cooling a 14-inch MacBook Pro M5 Max in clamshell mode.

Before making changes, read:

1. `README.md`
2. `docs/HANDOFF.md`
3. `docs/BENCHMARK_PLAN.md`

## Rules

- Treat `cad/upright_v1/upright_macbook_140mm_pressure_dock_v1.scad` as the canonical V1 source.
- Do not overwrite V1 when making substantial design changes. Create `upright_v2` (or later) directories.
- `archive/early_cadquery/` is historical and does not match canonical V1 dimensions.
- Keep CAD parameterized and human-editable.
- Prefer designs printable without unusual supports and compatible with common FDM printers.
- Check exported STL meshes for watertightness and report bounding-box dimensions.
- Do not invent precise MacBook vent dimensions. If exact geometry is unavailable, expose it as a parameter and mark it as needing measurement.
- Protect the MacBook from hard printed contact where possible; prefer a replaceable foam/TPU gasket.
- Keep hot exhaust regions physically separate from the pressurized intake region.
- Make the fan interface modular; standard 140 mm spacing is 124.5 mm.
- Optimize for sustained work performed, not merely lower temperature.
- Do not assume internal thermal pads are required. External cooling should be exhausted experimentally first.

## Near-term task

The likely next task is **Upright V2**. Start from the V1 idea but improve packaging and serviceability:

- lower/sculpted wedge plenum
- slight rearward laptop lean (parameterized, likely around 8-12 degrees)
- removable fan cartridge
- replaceable gasket insert
- hard stop protecting the air outlet
- exhaust clearance
- cable routing
- optional split-body geometry for smaller print beds

Before finalizing V2's laptop interface, ask for or derive actual measurements of the MacBook's intake/exhaust geometry. Do not treat guesses as production dimensions.

## Validation

For OpenSCAD builds, `make stl` should reproduce a watertight STL. Keep renders and generated meshes out of source edits unless intentionally updating the checked-in prototype.
