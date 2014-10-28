/*
 * Copyright (C) 2014 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU Lesser General Public License,
 * version 3, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
 */

import org.hildon.components 1.0
import org.hildon.multimedia 1.0
import org.hildon.settings 1.0
import org.hildon.utils 1.0
import "Utils.js" as Utils

Window {
    id: window
    
    windowTitle: (!Qt.application.active) && (audioPlayer.metaData.title) ? audioPlayer.metaData.title
                                                                          : "SimPlayer"
    tools: [
        Action {
            text: qsTr("Open location")
            onTriggered: {
                dialogLoader.sourceComponent = locationDialog;
                dialogLoader.item.open();
            }
        },
        
        Action {
            text: qsTr("Clear now playing")
            visible: playlist.count > 0
            onTriggered: playlist.clearItems()
        },
        
        Action {
            text: qsTr("Settings")
            onTriggered: {
                dialogLoader.sourceComponent = settingsDialog;
                dialogLoader.item.open();
            }
        },
        
        Action {
            text: qsTr("About")
            onTriggered: {
                dialogLoader.sourceComponent = aboutDialog;
                dialogLoader.item.open();
            }
        }
    ]
    
    Audio {
        id: audioPlayer
        
        tickInterval: (screen.covered) || (infoLoader.sourceComponent == playlistView) ? 0 
                                                                                       : Qt.application.active ? 1000 
                                                                                                               : 10000
        onError: infobox.showError(errorString);
    }
    
    NowPlayingModel {
        id: playlist
        
        function loadSongs(folder) {
            var p = directory.path;
            directory.path = folder;
            var songs = directory.entryList();
            
            if (songs.length > 0) {
                settings.currentFolder = folder;
                clearItems();
                
                for (var i = 0; i < songs.length; i++) {
                    appendSource(directory.absoluteFilePath(songs[i]));
                }
            }
            else {
                directory.path = p;
                infobox.showMessage(qsTr("No songs found"));
            }
        }
        
        onReady: {
            if (settings.startupPlaylist) {
                if (settings.startupPlaylist == "mafw") {
                    loadItems();
                }
                else if (settings.currentFolder) {
                    loadSongs(settings.currentFolder);
                }
            }
        }
    }
    
    Directory {
        id: directory
        
        path: "/home/user/MyDocs"
        nameFilters: [ "*.mp3", "*.ogg", "*.flac", "*.m4a", "*.wma", "*.ape" ]
    }
    
    Settings {
        id: settings
        
        property string currentFolder
        property string startupPlaylist
        
        fileName: "/home/user/.config/SimPlayer/simplayer.conf"
    }
    
    Image {
        id: image
        
        property variant covers: [ "cover.jpg", "folder.jpg", "front.jpg" ]
        
        function backupCoverArt() {
            if (playlist.count > 0) {
                for (var i = 0; i < covers.length; i++) { 
                    if (directory.fileExists(covers[i])) {
                        return directory.path + "/" + covers[i];
                    }
                }
            }

            return "/usr/share/icons/hicolor/295x295/hildon/mediaplayer_default_album.png";
        }
        
        width: 295
        height: 295
        anchors {
            top: parent.top
            left: parent.left
            margins: platformStyle.paddingLarge * 2
        }
        sourceSize: "295x295"
        smooth: true
        source: audioPlayer.metaData.coverArtUrl ? audioPlayer.metaData.coverArtUrl
                                                 : backupCoverArt()
        
        MouseArea {
            anchors.fill: parent
            enabled: playlist.count > 0
            onClicked: infoLoader.sourceComponent = (infoLoader.sourceComponent == infoColumn ? playlistView : infoColumn)
        }
    }
    
    Loader {
        id: infoLoader
        
        sourceComponent: infoColumn
    }
    
    Component {
        id: infoColumn
        
        Column {
            anchors {
                top: parent.top
                bottom: toolsLoader.item.top
                left: image.right
                right: parent.right
                margins: platformStyle.paddingLarge * 2
            }
            spacing: platformStyle.paddingLarge
            
            Label {
                height: 50
                alignment: Qt.AlignTop
                font.pixelSize: platformStyle.fontSizeSmall
                color: platformStyle.secondaryTextColor
                text: playlist.count ? (playlist.position + 1) + "/" + playlist.count + " " + qsTr("songs") : qsTr("(no songs)")
            }
            
            Label {
                text: audioPlayer.metaData.title ? audioPlayer.metaData.title : qsTr("(unknown song)")
            }
            
            Row {
                
                Label {
                    height: positionSlider.height
                    alignment: Qt.AlignLeft | Qt.AlignVCenter
                    font.pixelSize: platformStyle.fontSizeSmall
                    text: Utils.formatSeconds(positionSlider.value)
                }
                
                Slider {
                    id: positionSlider
                    
                    height: 70
                    maximum: audioPlayer.duration
                    enabled: (audioPlayer.seekable) && ((audioPlayer.playing) || (audioPlayer.paused))
                    onSliderReleased: audioPlayer.position = value
                    
                    Connections {
                        target: audioPlayer
                        onPositionChanged: if (!positionSlider.sliderPressed) positionSlider.value = audioPlayer.position;
                    }
                    
                    Component.onCompleted: value = audioPlayer.position
                }
                
                Label {
                    property bool showRemaining
                    
                    height: positionSlider.height
                    alignment: Qt.AlignRight | Qt.AlignVCenter
                    font.pixelSize: platformStyle.fontSizeSmall
                    text: showRemaining ? "- " + Utils.formatSeconds(audioPlayer.duration - positionSlider.value)
                                        : Utils.formatSeconds(audioPlayer.duration)
                                        
                    MouseArea {
                        anchors.fill: parent
                        onClicked: parent.showRemaining = !parent.showRemaining
                    }
                }
            }
            
            Label {
                text: audioPlayer.metaData.artist ? audioPlayer.metaData.artist : qsTr("(unknown artist)")
            }
            
            Label {
                color: platformStyle.secondaryTextColor
                text: audioPlayer.metaData.albumTitle ? audioPlayer.metaData.albumTitle : qsTr("(unknown album)")
            }
        }
    }
    
    Component {
        id: playlistView
        
        ListView {
            id: view
            
            anchors {
                top: parent.top
                bottom: toolsLoader.item.top
                left: image.right
                leftMargin: platformStyle.paddingLarge * 2
                right: parent.right
            }
            focusPolicy: Qt.NoFocus
            contextMenuPolicy: playlist.count > 0 ? Qt.ActionsContextMenu : Qt.NoContextMenu
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            horizontalScrollMode: ListView.ScrollPerItem
            model: playlist
            delegate: ListItem {
                width: view.width - (playlist.count > 5 ? platformStyle.paddingMedium : 0)
                
                ListItemImage {
                    anchors.fill: parent
                    source: "image://theme/TouchListBackground" + (isCurrentItem ? "Pressed" : "Normal")
                    smooth: true
                }
                
                ListItemLabel {
                    id: titleLabel
                    
                    height: 32
                    anchors {
                        left: parent.left
                        right: durationLabel.left
                        top: parent.top
                        margins: platformStyle.paddingMedium
                    }
                    alignment: Qt.AlignLeft | Qt.AlignTop
                    text: modelData.title ? modelData.title : qsTr("(unknown title)")
                }
                
                ListItemLabel {
                    id: artistLabel
                    
                    height: 32
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        margins: platformStyle.paddingMedium
                    }
                    alignment: Qt.AlignLeft | Qt.AlignBottom
                    font.pixelSize: platformStyle.fontSizeSmall
                    color: platformStyle.secondaryTextColor
                    text: (modelData.artist ? modelData.artist : qsTr("(unknown artist)"))
                           + " / "
                           + (modelData.albumTitle ? modelData.albumTitle : qsTr("(unknown album)"))
                }
                
                ListItemLabel {
                    id: durationLabel
                    
                    width: 80
                    height: 32
                    anchors {
                        right: parent.right
                        top: parent.top
                        margins: platformStyle.paddingMedium
                    }
                    alignment: Qt.AlignRight | Qt.AlignTop
                    text: Utils.formatSeconds(modelData.duration)
                }
            }
            
            actions: [
                Action {
                    text: qsTr("Delete from now playing")
                    onTriggered: playlist.removeItem(view.currentIndex)
                },
                
                Action {
                    text: qsTr("Clear now playing")
                    onTriggered: playlist.clearItems()
                }
            ]
                        
            onClicked: playlist.position = QModelIndex.row(currentIndex)
            
            Connections {
                target: playlist
                onPositionChanged: {
                    currentIndex = playlist.modelIndex(playlist.position);
                    positionViewAtIndex(currentIndex, ListView.PositionAtCenter, false);
                }
            }
            
            Component.onCompleted: {
                currentIndex = playlist.modelIndex(playlist.position);
                positionViewAtIndex(currentIndex, ListView.PositionAtCenter, false);
            }
        }
    }
    
    ToolButton {
        id: volumeButton
        
        width: 70
        height: 70
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingLarge
            bottom: parent.bottom
        }
        styleSheet: "background: transparent"
        checkable: true
        iconSize: "64x64"
        icon: "/usr/share/icons/hicolor/64x64/hildon/mediaplayer_volume.png"
    }
    
    Loader {
        id: toolsLoader
        
        sourceComponent: volumeButton.checked ? volumeSlider : playbackControls
    }
    
    Component {
        id: playbackControls
        
        Row {
            anchors {
                left: image.left
                right: volumeButton.left
                bottom: parent.bottom
            }
            height: 70
            spacing: 35
            
            ToolButton {
                styleSheet: "background: transparent"
                iconSize: "64x64"
                icon: "/etc/hildon/theme/mediaplayer/Back" + (pressed ? "Pressed" : "") + ".png"
                shortcut: "Left"
                onClicked: playlist.previous()
            }
            
            ToolButton {
                styleSheet: "background: transparent"
                iconSize: "64x64"
                icon: "/etc/hildon/theme/mediaplayer/" + (audioPlayer.playing ? "Pause" : "Play") + ".png"
                shortcut: "Space"
                onClicked: if (audioPlayer.source) audioPlayer.playing = !audioPlayer.playing;
            }
            
            ToolButton {
                styleSheet: "background: transparent"
                iconSize: "64x64"
                icon: "/etc/hildon/theme/mediaplayer/Forward" + (pressed ? "Pressed" : "") + ".png"
                shortcut: "Right"
                onClicked: playlist.next()
            }
            
            ToolButton {
                width: 130
                styleSheet: "background: transparent"
                checkable: true
                iconSize: "64x64"
                icon: "/etc/hildon/theme/mediaplayer/Shuffle" + ((checked) || (pressed) ? "Pressed" : "") + ".png"
                shortcut: "e"
                checked: playlist.shuffle
                onClicked: playlist.shuffle = !playlist.shuffle
            }
            
            ToolButton {
                width: 130
                styleSheet: "background: transparent"
                checkable: true
                iconSize: "64x64"
                icon: "/etc/hildon/theme/mediaplayer/Repeat" + ((checked) || (pressed) ? "Pressed" : "") + ".png"
                shortcut: "r"
                checked: playlist.repeat
                onClicked: playlist.repeat = !playlist.repeat
            }
        }
    }
    
    Component {
        id: volumeSlider
        
        Slider {
            id: vSlider
            
            height: 70
            anchors {
                left: image.left
                right: volumeButton.left
                bottom: parent.bottom
            }
            maximum: 100
            onSliderReleased: audioPlayer.volume = value
            
            Connections {
                target: audioPlayer
                onVolumeChanged: if (!vSlider.sliderPressed) vSlider.value = audioPlayer.volume;
            }
            
            Timer {
                interval: 3000
                running: !vSlider.sliderPressed
                onTriggered: volumeButton.checked = false
            }
            
            Component.onCompleted: value = audioPlayer.volume
        }
    }

    Loader {
        id: dialogLoader
    }
    
    Component {
        id: locationDialog
        
        FolderDialog {
            windowTitle: qsTr("Open location")
            readOnly: true
            onVisibleChanged: if ((visible) && (directory.path)) cd(directory.path);
            onSelected: playlist.loadSongs(folder)
        }
    }
    
    Component {
        id: settingsDialog
        
        SettingsDialog {}
    }
    
    Component {
        id: aboutDialog
        
        AboutDialog {}
    }
    
    InformationBox {
        id: infobox
        
        function showMessage(message) {
            minimumHeight = 70;
            timeout = InformationBox.DefaultTimeout;
            infoLabel.text = message;
            open();
        }
        
        function showError(message) {
            minimumHeight = 120;
            timeout = InformationBox.NoTimeout;
            infoLabel.text = message;
            open();
        }
        
        content: Label {
            id: infoLabel
            
            anchors.fill: parent
            alignment: Qt.AlignCenter
            color: platformStyle.reversedTextColor
            wordWrap: true
        }
    }
}
