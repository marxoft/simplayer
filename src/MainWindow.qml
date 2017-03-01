/*
 * Copyright (C) 2016 Stuart Howarth <showarth@marxoft.co.uk>
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
import org.hildon.multimedia 1.0
import org.hildon.settings 1.0
import org.hildon.utils 1.0
import "Utils.js" as Utils

Window {
    id: window
        
    visible: true
    title: (!Qt.application.active) && (audioPlayer.metaData.title) ? audioPlayer.metaData.title
                                                                    : "SimPlayer"
    
    menuBar: MenuBar {
        MenuItem {
            action: openAction
        }
        
        MenuItem {
            action: clearAction
        }
        
        MenuItem {
            text: qsTr("Settings")
            onTriggered: popupManager.open(Qt.resolvedUrl("SettingsDialog.qml"), window)
        }
        
        MenuItem {
            text: qsTr("About")
            onTriggered: popupManager.open(Qt.resolvedUrl("AboutDialog.qml"), window)
        }
    }
    
    Action {
        id: openAction
        
        text: qsTr("Open directory")
        shortcut: qsTr("Ctrl+O")
        autoRepeat: false
        onTriggered: popupManager.open(fileDialog, window)
    }
    
    Action {
        id: clearAction
        
        text: qsTr("Clear now playing")
        shortcut: qsTr("Ctrl+X")
        autoRepeat: false
        enabled: playlist.count > 0
        onTriggered: playlist.clearItems()
    }
    
    Action {
        id: viewAction
        
        text: qsTr("Toggle view")
        shortcut: qsTr("Ctrl+L")
        autoRepeat: false
        enabled: playlist.count > 0
        onTriggered: infoLoader.sourceComponent = (infoLoader.sourceComponent == infoColumn ? playlistView : infoColumn)
    }
    
    Audio {
        id: audioPlayer
        
        tickInterval: (screen.covered) || (infoLoader.sourceComponent == playlistView) ? 0 
        : Qt.application.active ? 1000 : 10000
        onError: informationBox.information(errorString);
    }
    
    NowPlayingModel {
        id: playlist
        
        function loadSongs(folder) {
            var p = directory.path;
            directory.path = folder;
            var songs = directory.recursiveEntryList();
            
            if (songs.length > 0) {
                settings.currentFolder = folder;
                clearItems();
                
                for (var i = 0; i < songs.length; i++) {
                    appendSource(songs[i]);
                }
            }
            else {
                directory.path = p;
                informationBox.information(qsTr("No songs found"));
            }
        }
        
        onCountChanged: if (count == 0) infoLoader.sourceComponent = infoColumn;
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
        filter: Directory.AllDirs | Directory.Files | Directory.NoDotAndDotDot | Directory.Readable
        | Directory.NoSymLinks
        sorting: Directory.DirsLast | Directory.IgnoreCase
        nameFilters: [ "*.mp3", "*.ogg", "*.flac", "*.wav", "*.m4a", "*.wma", "*.ape", "*.aiff" ]
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
            onClicked: viewAction.trigger()
        }
    }
    
    Loader {
        id: infoLoader
        
        anchors {
            left: image.right
            right: parent.right
            top: parent.top
            bottom: toolsLoader.top
        }
        sourceComponent: infoColumn
    }
    
    Component {
        id: infoColumn
        
        Column {
            anchors {
                fill: parent
                leftMargin: platformStyle.paddingLarge * 2
                rightMargin: platformStyle.paddingLarge * 2
                topMargin: platformStyle.paddingLarge
                bottomMargin: platformStyle.paddingLarge
            }
            spacing: platformStyle.paddingLarge
            
            Label {
                width: parent.width
                height: 60
                font.pointSize: platformStyle.fontSizeSmall
                color: platformStyle.secondaryTextColor
                elide: Text.ElideRight
                text: playlist.count ? (playlist.position + 1) + "/" + playlist.count + " " + qsTr("songs")
                : qsTr("(no songs)")
            }
            
            Label {
                width: parent.width
                elide: Text.ElideRight
                text: audioPlayer.metaData.title ? audioPlayer.metaData.title : qsTr("(unknown song)")
            }
            
            Row {
                width: parent.width
                spacing: platformStyle.paddingLarge
                
                Label {
                    width: 50
                    height: positionSlider.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: platformStyle.fontSizeSmall
                    text: Utils.formatSeconds(positionSlider.value)
                }
                
                Slider {
                    id: positionSlider
                    
                    width: parent.width - 100 - parent.spacing * 2
                    maximum: audioPlayer.duration
                    enabled: (audioPlayer.seekable) && ((audioPlayer.playing) || (audioPlayer.paused))
                    onPressedChanged: if (!pressed) audioPlayer.position = value;
                    
                    Connections {
                        target: audioPlayer
                        onPositionChanged: if (!positionSlider.pressed) positionSlider.value = audioPlayer.position;
                    }
                    
                    Component.onCompleted: value = audioPlayer.position
                }
                
                Label {
                    property bool showRemaining
                    
                    width: 50
                    height: positionSlider.height
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: platformStyle.fontSizeSmall
                    text: showRemaining ? "- " + Utils.formatSeconds(audioPlayer.duration - positionSlider.value)
                                        : Utils.formatSeconds(audioPlayer.duration)
                                        
                    MouseArea {
                        anchors.fill: parent
                        onClicked: parent.showRemaining = !parent.showRemaining
                    }
                }
            }
            
            Label {
                width: parent.width
                elide: Text.ElideRight
                text: audioPlayer.metaData.artist ? audioPlayer.metaData.artist : qsTr("(unknown artist)")
            }
            
            Label {
                width: parent.width
                color: platformStyle.secondaryTextColor
                elide: Text.ElideRight
                text: audioPlayer.metaData.albumTitle ? audioPlayer.metaData.albumTitle : qsTr("(unknown album)")
            }
        }
    }
    
    Component {
        id: playlistView
        
        ListView {
            id: view
            
            anchors {
                fill: parent
                leftMargin: platformStyle.paddingLarge * 2
            }
            clip: true
            focus: true
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            model: playlist
            delegate: ListItem {
                style: ListItemStyle {
                    background: "image://theme/TouchListBackground"
                                + (view.currentIndex == index ? "Pressed" : "Normal")
                }
                
                Label {
                    id: titleLabel
                    
                    anchors {
                        left: parent.left
                        right: durationLabel.left
                        top: parent.top
                        margins: platformStyle.paddingMedium
                    }
                    elide: Text.ElideRight
                    text: title ? title : qsTr("(unknown title)")
                }
                
                Label {
                    id: artistLabel
                    
                    anchors {
                        left: parent.left
                        right: durationLabel.left
                        bottom: parent.bottom
                        margins: platformStyle.paddingMedium
                    }
                    verticalAlignment: Text.AlignBottom
                    font.pointSize: platformStyle.fontSizeSmall
                    color: platformStyle.secondaryTextColor
                    elide: Text.ElideRight
                    text: (artist ? artist : qsTr("(unknown artist)")) + " / "
                           + (albumTitle ? albumTitle : qsTr("(unknown album)"))
                }
                
                Label {
                    id: durationLabel
                    
                    anchors {
                        right: parent.right
                        top: parent.top
                        margins: platformStyle.paddingMedium
                    }
                    horizontalAlignment: Text.AlignRight
                    text: Utils.formatSeconds(duration)
                }
                
                onClicked: playlist.position = index
                onPressAndHold: popupManager.open(contextMenu, view)
            }
            
            Component {
                id: contextMenu
                
                Menu {                    
                    MenuItem {
                        text: qsTr("Delete from now playing")
                        onTriggered: playlist.removeItem(view.currentIndex)
                    }
                    
                    MenuItem {
                        action: clearAction
                    }
                }
            }
                                    
            Connections {
                target: playlist
                onPositionChanged: currentIndex = playlist.position
            }
            
            Component.onCompleted: {
                currentIndex = playlist.position;
                positionViewAtIndex(currentIndex, ListView.Center);
                forceActiveFocus();
            }
        }
    }
    
    ToolButtonStyle {
        id: transparentToolButtonStyle
        
        background: ""
        backgroundChecked: ""
        backgroundDisabled: ""
        backgroundPressed: ""
        iconWidth: 64
        iconHeight: 64
    }
        
    ToolButton {
        id: volumeButton
        
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingLarge
            bottom: parent.bottom
        }
        checkable: true
        iconName: "mediaplayer_volume"
        style: transparentToolButtonStyle
    }
    
    Loader {
        id: toolsLoader
        
        height: 70
        anchors {
            left: image.left
            right: volumeButton.left
            bottom: parent.bottom
        }
        sourceComponent: volumeButton.checked ? volumeSlider : playbackControls
    }
    
    Component {
        id: playbackControls
        
        Row {
            spacing: 42
            
            ToolButton {
                iconSource: "/etc/hildon/theme/mediaplayer/Back" + (pressed ? "Pressed" : "") + ".png"
                autoRepeat: false
                shortcut: qsTr("Left")
                style: transparentToolButtonStyle
                onClicked: playlist.previous()
            }
            
            ToolButton {
                iconSource: "/etc/hildon/theme/mediaplayer/" + (audioPlayer.playing ? "Pause" : "Play") + ".png"
                autoRepeat: false
                shortcut: qsTr("Space")
                style: transparentToolButtonStyle
                onClicked: if (audioPlayer.source) audioPlayer.playing = !audioPlayer.playing;
            }
            
            ToolButton {
                iconSource: "/etc/hildon/theme/mediaplayer/Forward" + (pressed ? "Pressed" : "") + ".png"
                autoRepeat: false
                shortcut: qsTr("Right")
                style: transparentToolButtonStyle
                onClicked: playlist.next()
            }
            
            ToolButton {
                width: 130
                iconSource: "/etc/hildon/theme/mediaplayer/Shuffle" + ((checked) || (pressed) ? "Pressed" : "") + ".png"
                checkable: true
                checked: playlist.shuffle
                autoRepeat: false
                shortcut: qsTr("e")
                style: transparentToolButtonStyle
                onClicked: playlist.shuffle = !playlist.shuffle
            }
            
            ToolButton {
                width: 130
                iconSource: "/etc/hildon/theme/mediaplayer/Repeat" + ((checked) || (pressed) ? "Pressed" : "") + ".png"
                checkable: true
                checked: playlist.repeat
                autoRepeat: false
                shortcut: qsTr("r")
                style: transparentToolButtonStyle
                onClicked: playlist.repeat = !playlist.repeat
            }
        }
    }
    
    Component {
        id: volumeSlider
        
        Item {
            Slider {
                id: vSlider
                
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                onPressedChanged: if (!pressed) audioPlayer.volume = value;
            
                Connections {
                    target: audioPlayer
                    onVolumeChanged: if (!vSlider.pressed) vSlider.value = audioPlayer.volume;
                }
            
                Timer {
                    interval: 3000
                    running: !vSlider.pressed
                    onTriggered: volumeButton.checked = false
                }
            
                Component.onCompleted: value = audioPlayer.volume
            }
        }
    }
    
    Component {
        id: fileDialog
        
        FileDialog {
            selectFolder: true
            folder: directory.path
            onAccepted: playlist.loadSongs(folder)
        }
    }
    
    InformationBox {
        id: informationBox
        
        height: infoLabel.height + platformStyle.paddingLarge
        
        function information(message) {
            infoLabel.text = message;
            open();
        }
        
        Label {
            id: infoLabel
            
            anchors {
                fill: parent
                leftMargin: platformStyle.paddingLarge
                rightMargin: platformStyle.paddingLarge
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: platformStyle.reversedTextColor
            wrapMode: Text.WordWrap
        }
    }
}
