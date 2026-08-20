"""Check that Qt works, and that it landed on the display this action set up.

Providing the display is the whole job here, and every QT_QPA_PLATFORM the
action exports is a *request*, not a guarantee: a missing plugin, a missing
socket, or a "wayland;xcb" style fallback list all end with Qt happily running
somewhere else. A job in that state passes while testing nothing, so assert the
platform Qt actually chose rather than the one it was asked for.
"""

import os
import platform

import matplotlib

matplotlib.use('QtAgg')
import matplotlib.pyplot as plt

plt.figure()
backend = matplotlib.get_backend()
assert backend == 'QtAgg', backend

import qtpy
from matplotlib.backends.qt_compat import QT_API
from qtpy import QtDBus
from qtpy.QtGui import QGuiApplication
from qtpy.QtGui import QOpenGLContext

_ = QtDBus.QDBusConnection('Name')

# matplotlib does its own binding detection, so a disagreement here means the
# two halves of this job are exercising different Qt builds.
print(f'qtpy.API_NAME={qtpy.API_NAME!r}, matplotlib QT_API={QT_API!r}')
assert QT_API.lower() == qtpy.API_NAME.lower(), (QT_API, qtpy.API_NAME)

for var in ('QT_QPA_PLATFORM', 'DISPLAY', 'WAYLAND_DISPLAY', 'XDG_RUNTIME_DIR'):
    print(f'{var}={os.environ.get(var, "<unset>")}')

system = platform.system()
if system == 'Linux':
    display = os.environ.get('DISPLAY')
    wayland_display = os.environ.get('WAYLAND_DISPLAY')
    # The action starts exactly one of Xvfb and Weston and leaves the other
    # one's variable unset, so which session is up is not a guess -- and that
    # it stayed that way is worth asserting on its own.
    assert bool(display) != bool(wayland_display), (
        f'expected exactly one of DISPLAY={display!r} WAYLAND_DISPLAY={wayland_display!r}'
    )
    expected = 'wayland' if wayland_display else 'xcb'
elif system == 'Darwin':
    expected = 'cocoa'
elif system == 'Windows':
    expected = 'windows'
else:
    raise AssertionError(f'unhandled system {system!r}')

app = QGuiApplication.instance()
assert app is not None, 'matplotlib created no QGuiApplication'
name = app.platformName()
print(f'QGuiApplication.platformName() = {name!r} (expected {expected!r})')
# startswith, because Qt has also spelled these "wayland-egl" and "xcb-egl"
assert name.startswith(expected), (name, expected)

screens = app.screens()
for screen in screens:
    size = screen.size()
    print(f'screen {screen.name()!r}: {size.width()}x{size.height()}')
assert screens, 'display exposed no screen'

# A Wayland compositor on the pixman renderer advertises neither wl_drm nor
# linux-dmabuf, so Mesa hands the client no EGL context and anything drawing
# through QOpenGLWidget has nothing to render into -- which otherwise surfaces
# far from its cause. Getting GL onto the display is this action's job on
# Linux; elsewhere the OS provides it and test_pyvista.py covers it end to end.
context = QOpenGLContext()
created = context.create()
fmt = context.format()
print(f'GL context: created={created}, version {fmt.majorVersion()}.{fmt.minorVersion()}')
if system == 'Linux':
    assert created, 'no GL context on this display'
    assert fmt.majorVersion() >= 2, fmt.majorVersion()
