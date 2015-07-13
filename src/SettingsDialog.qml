/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
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
    
    Row {
        id: row
        
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        spacing: platformStyle.paddingMedium
        
        ValueButton {
            id: playlistButton
            
            width: parent.width - acceptButton.width - parent.spacing
            text: qsTr("Startup playlist")
            pickSelector: playlistSelector
        }
        
        Button {
            id: acceptButton
            
            text: qsTr("Done")
            style: DialogButtonStyle {}
            onClicked: root.accept()
        }
    }
    
    ListPickSelector {
        id: playlistSelector
        
        textRole: "name"
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
        
        onSelected: settings.startupPlaylist = model.get(currentIndex).value
    }    
}
