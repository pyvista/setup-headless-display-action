import matplotlib
matplotlib.use('QtAgg')
import matplotlib.pyplot as plt
plt.figure()
backend = matplotlib.get_backend()
assert backend == 'QtAgg', backend

from qtpy import QtDBus
_ = QtDBus.QDBusConnection('Name')
