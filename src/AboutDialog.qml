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
import "SimPlayer.js" as SimPlayer

Dialog {
    id: root
    
    title: qsTr("About")
    height: column.height + platformStyle.paddingMedium
    
    Flickable {
        id: flickable

        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            spacing: platformStyle.paddingMedium
            
            Row {
                width: parent.width
                spacing: platformStyle.paddingMedium
                
                Image {
                    width: 64
                    height: 64
                    source: "image://icon/mediaplayer_default_album"
                    smooth: true
                }

                Label {
                    height: 64
                    font.bold: true
                    font.pointSize: platformStyle.fontSizeLarge
                    verticalAlignment: Text.AlignVCenter
                    text: "SimPlayer " + SimPlayer.VERSION_NUMBER
                }
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("A simple folder-based music player written using")
                + " Qt Components Hildon.<br><br>"
                + qsTr("Keyboard shortcuts")
                + ":<br><br>"
                + qsTr("Playback")
                + ":<ul><li>"
                + qsTr("Space: Toggle playback.")
                + "</li><li>"
                + qsTr("Left: Previous song.")
                + "</li><li>"
                + qsTr("Right: Next song.")
                + "</li><li>"
                + qsTr("E: Toggle shuffle.")
                + "</li><li>"
                + qsTr("R: Toggle repeat.")
                + "</li><li>"
                + qsTr("Ctrl+X: Clear now playing queue.")
                + "</li></ul>"
                + qsTr("Music browser")
                + ":<ul><li>"
                + qsTr("Ctrl+O: Open music browser.")
                + "</li><li>"
                + qsTr("Backspace: Go up.")
                + "</li><li>"
                + qsTr("Ctrl+E: Enqueue folder.")
                + "</li><li>"
                + qsTr("Ctrl+P: Play folder.")
                + "</li></ul>"
                + qsTr("Other")
                + ":<ul><li>"
                + qsTr("Ctrl+L: Toggle playlist view.")
                + "</li><li>"
                + qsTr("Ctrl+S: Show settings dialog.")
                + "</li><li>"
                + qsTr("Ctrl+H: Show about dialog.")
                + "</li></ul><br>&copy; Stuart Howarth 2015-2017"
            }
        }
    }
}
