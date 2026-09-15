# Project Handoff

## Resume state: September 15, 2026

Upright V2 now has editable CAD, individual prototype STL exports, and assembly
previews. Start with [the V2 guide](../cad/upright_v2/README.md) and
[the reference-model findings](VENT_GEOMETRY.md). V1 is unchanged.

The supplied Downloads GLB/glTF represents a base M5 and contains useful hinge
detail, but is not a certified M5 Max mechanical reference. Its center-bank
frame is about 51 mm wide; V1's 142 mm outlet would cross into the neighboring
banks in that asset. V2 therefore has a blank insert plus a provisional 44 × 8 mm
center-window insert, with raised hardware confined to a 96 mm-wide cradle.

Next physical step: validate the hinge recess, vent boundaries, and padded stop
locations on the actual Max, using the blank insert first. Then leak-test the
assembled parts and run the benchmark plan. The public repository is
[`STRML/macbook-upright-cooler`](https://github.com/STRML/macbook-upright-cooler).
The user requested direct publication to `main`, without a PR. Check Git and
GitHub before edits. Physical validation is tracked in
[issue #2](https://github.com/STRML/macbook-upright-cooler/issues/2), followed by
[performance testing in #3](https://github.com/STRML/macbook-upright-cooler/issues/3).

## Goal

Create an elegant, compact external cooling dock for a **14-inch MacBook Pro M5 Max** used primarily in **clamshell mode** for:

- sustained local AI / ML inference and prompt processing
- repeated or large code compiles

The design should recover as much sustained SoC performance as practical without opening the MacBook or adding internal thermal pads unless external airflow proves insufficient.

## Why this exists

The 14-inch Max chassis has substantially less sustained thermal capacity than the 16-inch chassis under heavy combined workloads. The working hypothesis is that a sealed high-static-pressure air supply can improve the Mac's native intake airflow enough to materially delay or reduce throttling.

The Samuel Gregory experiment is the main inspiration: a gaming-laptop pressure cooler plus a custom adapter/seal produced a large sustained local-AI improvement on a 14-inch M5 Max. This repo first reproduces that basic pressure-cooling concept, then aims to package it as a vertical dock.

## Current prototypes

### A. V12 split adapter

Files:

- `cad/v12_adapter/panel_left.stl`
- `cad/v12_adapter/panel_right.stl`

These are a small reconfiguration of the adapter concept used in the Gregory video, sized/split for printing. Each half is approximately 208.5 x 269 x 2 mm and watertight. The assembled panel is roughly 381 x 269 mm. The current interlocking-joint target gap is about 0.2 mm.

Purpose: validate the performance effect on the actual Mac before spending time optimizing aesthetics.

### B. Upright 140 mm pressure dock V1

Files:

- `cad/upright_v1/upright_macbook_140mm_pressure_dock_v1.scad`
- `cad/upright_v1/upright_macbook_140mm_pressure_dock_v1.stl`

Concept:

- standard 140 mm fan mounted underneath
- large low-velocity pressure chamber
- narrow gasketed outlet at the top
- 19 mm channel to guide a closed MacBook vertically
- short rails so the dock does not wrap unnecessarily far around the chassis
- exhaust should remain outside the pressurized volume

Canonical V1 dimensions are parameterized at the top of the OpenSCAD file.

## Important design decisions already made

1. **Do not start with thermal pads.** External pressure cooling gets first priority because it is reversible and there is encouraging evidence it can materially improve sustained AI performance.
2. **Static pressure matters.** A 140 mm form factor is convenient, but the project should not assume a quiet case fan is sufficient. The design should make fan substitution easy.
3. **Avoid a narrow remote hose unless packaging requires it.** Direct fan -> plenum -> gasket is preferred because it minimizes pressure losses.
4. **Preserve intake/exhaust separation.** Hot hinge exhaust must not be encouraged back into the pressure inlet.
5. **Benchmark performance, not just temperature.** A cooler chip at the same sustained package power is less valuable than a hot chip sustaining more useful work.
6. **Keep the current V1 as a baseline.** Make substantial changes as V2 rather than silently mutating V1.

## Unknowns that must be resolved

- Exact location and dimensions of the 14-inch M5 Max intake and exhaust openings in clamshell orientation.
- How much of the rear/hinge intake can practically be sealed to the plenum without restricting exhaust.
- Whether the side intakes need their own pressurized branches or whether feeding the central/rear intake is sufficient.
- Required fan pressure/flow. This should be learned from V12 RPM sweeps before selecting the final standalone fan.
- Best laptop lean angle. A slight rearward lean may provide passive sealing force and improve stability.
- Gasket material/thickness and how much compression is appropriate without scratching or loading the enclosure.
- Whether the V1 19 mm channel is ideal once actual gasket material is selected.

### C. Upright V2 construction and fit-check prototype

- Source: `cad/upright_v2/upright_macbook_140mm_pressure_dock_v2.scad`
- Build: `make stl-v2`, `make preview-v2`, and `make check-v2`
- Individual outputs: `build/upright_v2/`
- Published prototype snapshot: `cad/upright_v2/stl/`
- Printed assembly envelope: 190 × 180 × 129.24 mm at 10° lean
- All nine default STL variants are watertight single solids. The cradle also
  passes at 8° and 12°. These checks do not establish physical print strength,
  airtightness, or final laptop fit.

The shell prints open at both ends and receives a separate lid. Its cartridge
retainers are independent of the fan bolts and feet. Replaceable foam seals join
the pressure parts; the laptop gasket and padded stops share a tilted contact
plane. Cable ties attach through the feet, outside the pressure chamber.

## Original V2 design brief

V1 was inspected before V2 was built. The design brief called for:

- removable 140 mm fan cartridge using standard 124.5 mm mounting pattern
- optional adapters for thicker/high-pressure 140 mm fans
- lower, more sculpted wedge/plenum rather than a rectangular tower
- 8-12 degree rearward laptop lean as a parameter
- replaceable TPU/foam gasket insert rather than relying on hard printed surfaces for the seal
- positive mechanical stop so the Mac cannot drop into the air outlet
- cable routing that works with both left and right USB-C/Thunderbolt connections
- no obstruction of the hinge exhaust zones
- easy disassembly for fan testing
- geometry that can be printed on a typical ~250 mm bed, splitting the body if necessary

The default V2 parts fit inside 190 × 180 mm, so a split-body variant was not
needed. Fan selection and final laptop fit remain experimental.

## Canonical vs archived CAD

The OpenSCAD V1 is canonical. `archive/early_cadquery/` contains an earlier CadQuery/STEP exploration with different base/plenum dimensions. It is retained only as design history and should not be treated as the source for V1.

## Source references

- Gregory experiment: https://www.samuelgregory.co.uk/videos/i-sped-up-my-local-ai-64-with-this-100-gadget
- Reference llano V12: https://www.amazon.com/dp/B0CYC7T38X
