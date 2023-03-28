"""Quickly check if VTK off screen plotting works."""
import numpy as np
import pyvista as pv
from pathlib import Path
import pyvista
from pyvista.plotting import system_supports_plotting

print(f'system_supports_plotting: {system_supports_plotting()}')
assert system_supports_plotting()
# pyvista.OFF_SCREEN = True  # should be set by Action in Env
out_path = Path(__file__).parent / '..'

sphere = pv.Sphere()
pv.plot(sphere, screenshot=out_path / 'sphere.png')

# Advanced test
name, name2 = 'foo', 'bar'
mesh = pv.Wavelet()
mesh.point_data[name] = np.arange(mesh.n_points)
mesh.cell_data[name2] = np.arange(mesh.n_cells)

pl = pv.Plotter()
pl.add_mesh(mesh, scalars=name)
pl.show(screenshot=out_path / 'advanced_1.png')

pl = pv.Plotter()
pl.add_mesh(mesh, scalars=name2)
pl.show(screenshot=out_path / 'advanced_2.png')
