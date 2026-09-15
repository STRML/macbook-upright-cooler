"""Check default V12 adapter intersections and real fastener envelopes."""

import argparse
import os
from pathlib import Path
import shlex
import subprocess
import tempfile

import numpy as np
import trimesh

CASES = ["positive_control", "empty_control", "tile_overlap", "deck_collar",
         "base_collar", "bridges_clear", "m3_hardware", "m4_hardware", "air_path",
         "gauge_window", "deck_material", "positive_collision"]
TOLERANCE_MM3 = 1e-6


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--openscad", default=os.environ.get("OPENSCAD", "openscad"))
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    failures = []
    with tempfile.TemporaryDirectory(prefix="v12-check-") as directory:
        for case in CASES:
            output = Path(directory) / f"{case}.stl"
            command = shlex.split(args.openscad) + [
                "--hardwarnings", "-D", f'TEST="{case}"', "-o", str(output),
                str(root / "tests/v12_interfaces.scad"),
            ]
            try:
                result = subprocess.run(command, capture_output=True, text=True,
                                        timeout=180, check=False)
                log = result.stdout + result.stderr
                if "ERROR:" in log or "WARNING:" in log:
                    raise ValueError(log.strip())
                volume = 0.0
                if result.returncode == 1 and "top level object is empty" in log.lower():
                    pass  # OpenSCAD uses exit 1 for a valid empty intersection.
                elif result.returncode == 0 and output.is_file():
                    mesh = trimesh.load_mesh(output)
                    if not isinstance(mesh, trimesh.Trimesh) or mesh.is_empty:
                        raise ValueError("Expected a nonempty mesh or an explicit empty result")
                    if not np.isfinite(mesh.vertices).all() or not np.isfinite(mesh.volume):
                        raise ValueError("Nonfinite intersection geometry")
                    volume = abs(float(mesh.volume))
                else:
                    raise ValueError(f"OpenSCAD exited {result.returncode}: {log.strip()}")
                if case == "positive_control":
                    valid = abs(volume - 8) < TOLERANCE_MM3
                elif case == "positive_collision":
                    valid = volume > 1
                else:
                    valid = volume < TOLERANCE_MM3
                if not valid:
                    raise ValueError(f"Unexpected intersection volume {volume:.9g} mm³")
                print(f"PASS {case}: {volume:.9g} mm³", flush=True)
            except (OSError, ValueError, subprocess.TimeoutExpired) as error:
                failures.append(case)
                print(f"FAIL {case}: {error}", flush=True)
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
