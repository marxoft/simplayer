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

Window {
    id: root

    property QtObject plugin

    function search(p) {
        if (plugin) {
            plugin.cancel();
        }

        showProgressIndicator = true;
        loader.sourceComponent = resultsView;
        plugin = p;
        plugin.search();
    }

    title: qsTr("Search music")
    menuBar: MenuBar {
        MenuItem {
            PlaybackButton {
                onClicked: windowStack.pop(window)
            }
        }

        MenuItem {
            action: searchAction
        }
    }

    Action {
        id: searchAction

        text: qsTr("Search")
        shortcut: qsTr("Ctrl+F")
        autoRepeat: false
        onTriggered: {
            if (root.plugin) {
                root.plugin.cancel();
            }

            loader.sourceComponent = pluginsView;
        }
    }

    Loader {
        id: loader

        anchors.fill: parent
        sourceComponent: pluginsView
    }

    Component {
        id: pluginsView

        Item {
            anchors.fill: parent

            ListView {
                id: view

                anchors.fill: parent
                cacheBuffer: 350
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

                    onClicked: root.search(modelData)
                }
            }

            Label {
                id: label

                anchors.centerIn: parent
                font.pointSize: platformStyle.fontSizeLarge
                color: platformStyle.disabledTextColor
                text: qsTr("No plugins")
                visible: pluginManager.searchPlugins.length == 0
            }

            Component.onCompleted: view.forceActiveFocus()
        }
    }

    Component {
        id: resultsView

        Item {
            anchors.fill: parent

            ListView {
                id: view

                anchors.fill: parent
                cacheBuffer: 350
                model: SortFilterProxyModel {
                    id: filterModel

                    sourceModel: ListModel {
                        id: searchModel

                        property bool loading: false
                    }
                    filterRole: "title"
                    filterCaseSensitivity: Qt.CaseInsensitive
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
                        source: iconSource || "image://icon/gnome-mime-audio-mp3"
                        sourceSize: "48x48"
                        smooth: true
                    }

                    Label {
                        id: label

                        anchors {
                            left: icon.right
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: platformStyle.paddingMedium
                        }
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        text: title
                    }

                    onClicked: playlist.playUri(url)
                    onPressAndHold: popupManager.open(contextMenu, root)
                }
                onAtYEndChanged: {
                    if ((atYEnd) && (!root.showProgressIndicator) && (!filterLoader.item) && (plugin)
                        && (plugin.canFetchMore)) {
                        plugin.fetchMore();
                    }
                }

                Keys.onPressed: {
                    if (event.text) {
                        filterLoader.sourceComponent = filterBar;
                        filterLoader.item.text += event.text;
                        event.accepted = true;
                    }
                }
            }

            Label {
                id: label

                anchors.centerIn: parent
                font.pointSize: platformStyle.fontSizeLarge
                color: platformStyle.disabledTextColor
                text: qsTr("No music")
                visible: (filterModel.count == 0) && (!root.showProgressIndicator)
            }

            Component {
                id: contextMenu

                Menu {
                    MenuItem {
                        text: qsTr("Enqueue")
                        onTriggered: playlist.addUri(searchModel.get(view.currentIndex).url)
                    }

                    MenuItem {
                        text: qsTr("Play")
                        onTriggered: playlist.playUri(searchModel.get(view.currentIndex).url)
                    }
                }
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

            Connections {
                target: plugin
                onFinished: {
                    for (var i = 0; i < results.length; i++) {
                        searchModel.append(results[i]);
                    }
                }
            }

            Component.onCompleted: view.forceActiveFocus()
        }
    }

    Connections {
        target: plugin
        onCanceled: root.showProgressIndicator = false
        onError: {
            root.showProgressIndicator = false;
            informationBox.information(errorString);
        }
        onFinished: root.showProgressIndicator = false
        onSearchSettingsRequest: popupManager.open(Qt.resolvedUrl("PluginSettingsDialog.qml"), root,
        {pluginSettings: plugin.searchSettings})
        onStarted: root.showProgressIndicator = true
    }

    onClosing: {
        if (plugin) {
            plugin.cancel();
        }

        close.accepted = true;
    }
}
