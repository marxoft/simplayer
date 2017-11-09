/**
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

Dialog {
    id: root

    property alias currentIndex: view.currentIndex

    title: qsTr("Search plugins")
    height: 360

    ListView {
        id: view

        anchors.fill: parent
        cacheBuffer: 350
        focus: true
        model: pluginManager.searchPlugins
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
                sourceSize: "48x48"
                smooth: true
                source: modelData.iconSource || "image://icon/general_search"
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
                text: modelData.name
            }

            onClicked: root.accept()
        }
    }

    contentItem.states: State {
        name: "Portrait"
        when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation

        PropertyChanges {
            target: root
            height: 680
        }
    }
}
