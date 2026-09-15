"""Inspect the supplied Sketchfab M5 glTF without changing or redistributing it.

Coordinates are scaled from glTF meters to millimeters, not calibrated to a Mac.
The expected node names belong to the supplied October 2025 asset.
"""

import argparse
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.collections import PolyCollection
import numpy as np
import trimesh


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("gltf", type=Path)
    parser.add_argument("--output", type=Path, default=Path("build/upright_v2/reference.png"))
    args = parser.parse_args()
    scene = trimesh.load_scene(args.gltf)
    print("Scene bounds (mm):", (scene.bounds * 1000).round(3).tolist())
    print("Geometry count:", len(scene.geometry))
    print("Triangle count:", sum(len(m.faces) for m in scene.geometry.values()))
    meshes = []
    for name in scene.graph.nodes_geometry:
        transform, geometry = scene.graph[name]
        mesh = scene.geometry[geometry].copy().apply_transform(transform)
        mesh.apply_scale(1000)
        if mesh.bounds[1, 1] < 20:
            meshes.append((name, mesh))
    for name, mesh in meshes:
        if name not in {"Object_40", "Object_44", "Object_59"}:
            continue
        mesh.process()
        parts = mesh.split(only_watertight=False, repair=False)
        print(name, "largest connected surface patches (not aperture dimensions):")
        for part in sorted(parts, key=lambda p: len(p.faces), reverse=True)[:6]:
            print(" ", len(part.faces), part.bounds.round(3).tolist())

    fig, axes = plt.subplots(3, 1, figsize=(15, 11), constrained_layout=True)
    views = [([0, 2], 1, -1, "Underside"), ([0, 1], 2, -1, "Hinge edge"),
             ([2, 1], 0, 1, "Right edge")]
    for ax, (dims, depth, sign, title) in zip(axes, views):
        triangles, colors, depths = [], [], []
        for index, (_, mesh) in enumerate(meshes):
            light = .3 + .6 * np.abs(mesh.face_normals[:, depth])
            color = np.array(plt.cm.tab20(index % 20 / 20)[:3])
            triangles.extend(mesh.triangles[:, :, dims])
            colors.extend(light[:, None] * color)
            depths.extend(sign * mesh.triangles[:, :, depth].mean(axis=1))
        order = np.argsort(depths)
        ax.add_collection(PolyCollection(np.array(triangles)[order],
                                        facecolors=np.array(colors)[order],
                                        edgecolors="none", rasterized=True))
        ax.autoscale_view()
        ax.set_aspect("equal")
        ax.set_title(f"{title}. Raw asset coordinates in mm; lid omitted")
        ax.grid(alpha=.2)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(args.output, dpi=150)
    plt.close(fig)


if __name__ == "__main__":
    main()
