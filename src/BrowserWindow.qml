/*
 * Copyright (C) 2017 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 1.0
import org.hildon.components 1.0
import org.hildon.utils 1.0
import "SimPlayer.js" as SimPlayer

Window {
    id: root

    title: qsTr("Browse music")
    menuBar: MenuBar {
        MenuItem {
            action: queueAction
        }

        MenuItem {
            action: playAction
        }
    }

    Action {
        id: queueAction

        text: qsTr("Enqueue folder")
        shortcut: qsTr("Ctrl+E")
        autoRepeat: false
        onTriggered: playlist.loadSongs(directory.path)
    }

    Action {
        id: playAction

        text: qsTr("Play folder")
        shortcut: qsTr("Ctrl+P")
        autoRepeat: false
        onTriggered: playlist.playSongs(directory.path)
    }

    Row {
        id: row

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: platformStyle.paddingMedium
        }
        spacing: platformStyle.paddingMedium

        Button {
            id: upButton

            width: 80
            iconName: "filemanager_folder_up"
            activeFocusOnPress: false
            shortcut: qsTr("Backspace")
            autoRepeat: false
            enabled: directory.path != "/"
            onClicked: directory.cdUp()
        }

        Label {
            id: pathLabel

            width: parent.width - upButton.width - platformStyle.paddingMedium
            height: 70
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideLeft
            text: directory.path
        }
    }

    ListView {
        id: view

        anchors {
            left: parent.left
            right: parent.right
            top: row.bottom
            topMargin: platformStyle.paddingMedium
            bottom: parent.bottom
        }
        cacheBuffer: 350
        clip: true
        focus: true
        model: SortFilterProxyModel {
            id: filterModel

            sourceModel: ListModel {
                id: fileModel
            }
            filterRole: "name"
            filterCaseSensitivity: Qt.CaseInsensitive
            dynamicSortFilter: true
        }
        delegate: ListItem {
            Image {
                id: icon

                anchors {
                    left: parent.left
                    leftMargin: platformStyle.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
                width: 48
                height: 48
                smooth: true
                source: "image://icon/" + (isDir ? "general_folder" : "gnome-mime-audio-mp3")
            }

            Label {
                id: label

                anchors {
                    left: icon.right
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    margins: platformStyle.paddingMedium
                }
                elide: Text.ElideRight
                text: name
            }

            onClicked: isDir ? directory.path = path : playlist.playSong(path)
            onPressAndHold: popupManager.open(contextMenu, root)
        }

        Keys.onPressed: {
            if (event.text) {
                filterLoader.sourceComponent = filterBar;
                filterLoader.item.text = event.text;
                event.accepted = true;
            }
        }
    }

    Label {
        anchors.centerIn: parent
        font.pointSize: platformStyle.fontSizeLarge
        color: platformStyle.disabledTextColor
        text: qsTr("No music")
        visible: (filterModel.count == 0) && (directory.ready)
    }

    Loader {
        id: filterLoader

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    Component {
        id: filterBar

        FilterBar {
            onTextChanged: filterModel.filterFixedString = text
            onRejected: filterLoader.sourceComponent = undefined
            Component.onCompleted: forceActiveFocus()
            Component.onDestruction: view.forceActiveFocus()
        }
    }

    Component {
        id: contextMenu

        Menu {
            MenuItem {
                text: qsTr("Enqueue")
                onTriggered: {
                    var file = fileModel.get(view.currentIndex);
                    
                    if (file.isDir) {
                        playlist.loadSongs(file.path);
                    }
                    else {
                        playlist.loadSong(file.path);
                    }
                }
            }

            MenuItem {
                text: qsTr("Play")
                onTriggered: {
                    var file = fileModel.get(view.currentIndex);
                    
                    if (file.isDir) {
                        playlist.playSongs(file.path);
                    }
                    else {
                        playlist.playSong(file.path);
                    }
                }
            }
        }
    }

    Directory {
        id: directory

        property bool ready: false
        
        filter: Directory.AllDirs | Directory.Files | Directory.NoDotAndDotDot | Directory.Readable
        | Directory.NoSymLinks
        sorting: Directory.DirsFirst | Directory.IgnoreCase
        nameFilters: SimPlayer.AUDIO_FILENAME_FILTERS
        onPathChanged: {
            ready = false;
            var files = entryInfoList();
            fileModel.clear();

            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                fileModel.append({name: file.completeBaseName, path: file.absoluteFilePath, isDir: file.isDir});
            }

            ready = true;
        }
    }

    VolumeKeys.enabled: settings.volumeKeysPolicy == SimPlayer.VolumeKeysNavigate

    contentItem.states: State {
        name: "Filter"
        when: filterLoader.item != null

        AnchorChanges {
            target: view
            anchors.bottom: filterLoader.top
        }
    }

    Component.onCompleted: directory.cd("/home/user/MyDocs")
}
