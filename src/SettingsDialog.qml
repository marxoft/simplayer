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

Dialog {
    id: root
    
    windowTitle: qsTr("Settings")
    height: 120
    content: Column {
        anchors.fill: parent

        Label {
            text: qsTr("Startup playlist")
            alignment: Qt.AlignHCenter
        }
        
        ButtonRow {
            id: buttonRow
            
            property string value: "folder"
            
            exclusive: true
            
            Button {
                text: qsTr("Current folder")
                checkable: true
                onVisibleChanged: if (visible) checked = (settings.startupPlaylist == "folder");
                onClicked: buttonRow.value = "folder"
            }
            
            Button {
                text: qsTr("MAFW playlist")
                checkable: true
                onVisibleChanged: if (visible) checked = (settings.startupPlaylist == "mafw");
                onClicked: buttonRow.value = "mafw"
            }
            
            Button {
                text: qsTr("None")
                checkable: true
                onVisibleChanged: if (visible) checked = (settings.startupPlaylist == "");
                onClicked: buttonRow.value = ""
            }
        }
    }
    
    buttons: Button {
        text: qsTr("Done")
        onClicked: root.accept()
    }
    
    onAccepted: settings.startupPlaylist = buttonRow.value
}
