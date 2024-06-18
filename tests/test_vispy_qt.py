"""Quickly check if vispy off screen plotting works."""

import os
from pathlib import Path
import numpy as np
from qtpy.QtWidgets import QApplication
from vispy import scene
from PIL import Image

qapp = QApplication([])
canvas = scene.SceneCanvas(size=(512, 512))
view = canvas.central_widget.add_view()
vol_data = np.random.rand(64, 64, 64).astype(np.float32)
image = scene.visuals.Volume(vol_data, cmap="viridis", parent=view.scene)
view.camera = scene.ArcballCamera()
canvas.show()

fname = f'{os.environ['MATRIX_OS']}-{os.environ['MATRIX_QT']}-vispy-volume.png'
out_path = Path(__file__).parent.parent / fname
Image.fromarray(canvas.render()).save(out_path)
