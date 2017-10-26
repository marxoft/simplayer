TEMPLATE = subdirs

qml.files = \
    src/AboutDialog.qml \
    src/ListSelectorButton.qml \
    src/MainWindow.qml \
    src/SettingsDialog.qml \
    src/Utils.js
    
qml.path = /opt/simplayer/qml

desktop.files = desktop/simplayer.desktop
desktop.path = /usr/share/applications/hildon

launcher.files = src/simplayer
launcher.path = /usr/bin

INSTALLS += qml desktop launcher
