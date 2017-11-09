/**
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
    height: Math.min(360, column.height + platformStyle.paddingMedium)
    
    Column {
        id: column
        
        anchors {
            left: parent.left
            right: acceptButton.left
            rightMargin: platformStyle.paddingMedium
            top: parent.top
        }
        spacing: platformStyle.paddingMedium

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: platformStyle.secondaryTextColor
            text: qsTr("General")
        }

        CheckBox {
            width: parent.width
            text: qsTr("Restore now playing on startup")
            checked: settings.restorePlaylist
            onCheckedChanged: settings.restorePlaylist = checked
        }

        ListSelectorButton {
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

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: platformStyle.secondaryTextColor
            text: qsTr("Plugins")
        }

        Button {
            width: parent.width
            text: qsTr("Search plugins")
            enabled: pluginManager.searchPlugins.length > 0
            onClicked: {
                var dialog = popupManager.open(Qt.resolvedUrl("SearchPluginsDialog.qml"), root);
                dialog.accepted.connect(function() {
                    var plugin = pluginManager.searchPlugins[dialog.currentIndex];

                    if (plugin.settings) {
                        popupManager.open(Qt.resolvedUrl("PluginSettingsDialog.qml"), root,
                        {pluginSettings: plugin.settings});
                    }
                    else {
                        informationBox.information(qsTr("No settings for this plugin"));
                    }
                });
            }
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
            height: Math.min(680, column.height + acceptButton.height + platformStyle.paddingMedium * 2)
        }
    }
}
