"""Regression checks for the printable-mesh validator."""

import contextlib
import io
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

import trimesh

from tools.check_mesh import check


class MeshCheckTest(unittest.TestCase):
    def verify(self, mesh):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "fixture.stl"
            mesh.export(path)
            with contextlib.redirect_stdout(io.StringIO()):
                return check(path)

    def test_closed_solid_passes(self):
        self.assertTrue(self.verify(trimesh.creation.box()))

    def test_open_surface_fails(self):
        box = trimesh.creation.box()
        box.update_faces(range(len(box.faces) - 1))
        self.assertFalse(self.verify(box))

    def test_disconnected_solids_fail(self):
        left = trimesh.creation.box()
        right = trimesh.creation.box().apply_translation([3, 0, 0])
        self.assertFalse(self.verify(trimesh.util.concatenate([left, right])))

    def test_inward_winding_fails(self):
        box = trimesh.creation.box()
        box.invert()
        self.assertFalse(self.verify(box))

    def test_missing_file_returns_failure(self):
        root = Path(__file__).resolve().parents[1]
        with tempfile.TemporaryDirectory() as directory:
            result = subprocess.run(
                [sys.executable, str(root / "tools/check_mesh.py"),
                 str(Path(directory) / "missing.stl")],
                capture_output=True, text=True, check=False,
            )
        self.assertEqual(result.returncode, 1)
        self.assertIn("FAIL", result.stdout)


if __name__ == "__main__":
    unittest.main()
