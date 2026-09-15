"""Check printable solids and report their envelopes in millimeters."""

import argparse
import sys
from pathlib import Path

import numpy as np
import trimesh


def check(path: Path) -> bool:
    mesh = trimesh.load_mesh(path, process=True)
    if not isinstance(mesh, trimesh.Trimesh) or mesh.is_empty:
        print(f"FAIL {path}: expected a nonempty triangle mesh")
        return False
    parts = mesh.split(only_watertight=False, repair=False)
    valid = (
        np.isfinite(mesh.vertices).all()
        and len(parts) == 1
        and mesh.is_watertight
        and mesh.is_winding_consistent
        and mesh.volume > 0
    )
    size = " x ".join(f"{value:.2f}" for value in mesh.extents)
    print(
        f"{'PASS' if valid else 'FAIL'} {path.name}: {size} mm; "
        f"watertight={mesh.is_watertight}; winding={mesh.is_winding_consistent}; "
        f"solids={len(parts)}; volume={mesh.volume / 1000:.2f} cm³"
    )
    return bool(valid)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("meshes", nargs="+", type=Path)
    args = parser.parse_args()
    results = []
    for path in args.meshes:
        try:
            results.append(check(path))
        except (OSError, ValueError) as error:
            print(f"FAIL {path}: {error}")
            results.append(False)
    return 0 if all(results) else 1


if __name__ == "__main__":
    sys.exit(main())
