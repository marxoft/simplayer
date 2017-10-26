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

Dialog {
    id: root
    
    title: qsTr("Settings")
    height: column.height + platformStyle.paddingMedium
    
    Column {
        id: column
        
        anchors {
            left: parent.left
            right: acceptButton.left
            rightMargin: platformStyle.paddingMedium
            top: parent.top
        }
        spacing: platformStyle.paddingMedium
        
        ListSelectorButton {
            id: playlistButton
            
            width: parent.width
            text: qsTr("Startup playlist")
            model: ListModel {
                ListElement {
                    name: "Current folder"
                    value: "folder"
                }
                
                ListElement {
                    name: "MAFW playlist"
                    value: "mafw"
                }
                
                ListElement {
                    name: "None"
                    value: ""
                }
            }

            value: settings.startupPlaylist
            onSelected: settings.startupPlaylist = value
        }

        ListSelectorButton {
            id: orientationButton

            width: parent.width
            text: qsTr("Screen orientation")
            model: ListModel {
                ListElement {
                    name: "Landscape"
                    value: 129 // Qt.WA_Maemo5LandscapeOrientation
                }

                ListElement {
                    name: "Portrait"
                    value: 128 // Qt.WA_Maemo5PortraitOrientation
                }

                ListElement {
                    name: "Automatic"
                    value: 130 // Qt.WA_Maemo5AutoOrientation
                }
            }

            value: settings.screenOrientation
            onSelected: settings.screenOrientation = value
        }
    }
        
    Button {
        id: acceptButton

        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        text: qsTr("Done")
        style: DialogButtonStyle {}
        onClicked: root.accept()
    }

    contentItem.states: State {
        name: "Portrait"
        when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation

        AnchorChanges {
            target: column
            anchors.right: parent.right
        }

        PropertyChanges {
            target: column
            anchors.rightMargin: 0
        }

        PropertyChanges {
            target: acceptButton
            width: parent.width
        }

        PropertyChanges {
            target: root
            height: column.height + acceptButton.height + platformStyle.paddingMedium
        }
    }
}
