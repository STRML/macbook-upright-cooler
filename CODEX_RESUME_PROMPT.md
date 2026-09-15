# Codex Resume Prompt

Resume this physical-design project from the repository state.

Read `AGENTS.md`, `README.md`, `docs/HANDOFF.md`, and `docs/BENCHMARK_PLAN.md` first. The current user goal is an elegant upright pressure-cooling dock for a 14-inch M5 Max MacBook Pro in clamshell mode, primarily for sustained AI work and code compiles.

Do not redesign or overwrite `upright_v1`; use it as a baseline. Upright V2 now
exists in `cad/upright_v2/`. Read its `README.md` and `docs/VENT_GEOMETRY.md`
before changing it. It has a replaceable 140 mm fan cartridge, a tapered plenum,
10-degree cradle, replaceable gasket insert, padded stops, and cable-tie paths.

The user supplied `macbook_pro_14-inch_m5.zip` and `macbook-pro-14-inch-m5.zip`
in Downloads. Their GLB/glTF contains useful visualization geometry for a base
M5, but is not a verified M5 Max mechanical model. The central vent-bank frame
is about 51 mm wide, so V2 replaces the V1-sized 142 mm outlet with an explicitly
provisional 44 x 8 mm center opening plus a blank fit-check insert. Preserve the
source qualification and uncertainty documented in `docs/VENT_GEOMETRY.md`.

Next: confirm the actual Max's closed-lid vent recess and padded contact points,
then print/fit-check, leak-test, and benchmark. Generated V2 meshes and previews
are under `build/upright_v2/`; use `make stl-v2`, `make preview-v2`, and
`make check-v2` to reproduce them. The verified snapshot is in
`cad/upright_v2/stl/`; do not let it silently drift from the source. The public
repository is `STRML/macbook-upright-cooler`. Check Git/GitHub state before edits.

Important: do not guess final MacBook vent dimensions. Parameterize uncertain geometry and clearly identify measurements that must be taken from the physical machine or a trustworthy mechanical reference before a final STL is produced.

When you generate CAD:

- keep editable source in the repo
- export STL for print testing
- generate a preview image
- report overall dimensions and mesh watertightness
- preserve V1 files unchanged
- explain any assumptions that affect airflow or laptop fit
