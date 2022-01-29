"""Quickly check if VTK off screen plotting works."""
import pyvista
from pyvista.plotting import system_supports_plotting

print(f'system_supports_plotting: {system_supports_plotting()}')
assert system_supports_plotting()
# pyvista.OFF_SCREEN = True  # should be set by Action in Env
sphere = pyvista.Sphere()
pyvista.plot(sphere, screenshot='sphere.png')
