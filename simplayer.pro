TEMPLATE = subdirs

qml.files = \
    src/AboutDialog.qml \
    src/MainWindow.qml \
    src/SettingsDialog.qml \
    src/Utils.js
    
qml.path = /opt/simplayer/qml

desktop.files = desktop/simplayer.desktop
desktop.path = /usr/share/applications/hildon

INSTALLS += qml desktop

