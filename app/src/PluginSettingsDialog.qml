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
import "file:///opt/lib/qt4/imports/SimPlayer/Setting.js" as Setting

Dialog {
    id: root
    
    property QtObject pluginSettings

    title: qsTr("Settings")
    height: Math.min(360, column.height + platformStyle.paddingMedium)
    
    Flickable {
        id: flickable
        
        anchors {
            left: parent.left
            right: button.left
            rightMargin: platformStyle.paddingMedium
            top: parent.top
            bottom: parent.bottom
        }
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        contentHeight: column.height
        
        Column {
            id: column
            
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            spacing: platformStyle.paddingMedium
            
            Repeater {
                id: repeater
                
                Loader {
                    Component.onCompleted: {
                        switch (modelData.type) {
                        case Setting.Boolean:
                            sourceComponent = checkBox;
                            break;
                        case Setting.Group:
                            sourceComponent = group;
                            break;
                        case Setting.Integer:
                            sourceComponent = integerField;
                            break;
                        case Setting.List:
                            sourceComponent = valueSelector;
                            break;
                        case Setting.Text:
                            sourceComponent = textField;
                            break;
                        default:
                            break;
                        }
                    }
                    
                    Component {
                        id: checkBox
                        
                        CheckBox {
                            width: column.width
                            text: modelData.label
                            enabled: modelData.enabled
                            checked: modelData.value
                            onCheckedChanged: modelData.value = checked
                        }
                    }
        
                    Component {
                        id: group
                            
                        Label {
                            width: column.width
                            horizontalAlignment: Text.AlignHCenter
                            color: platformStyle.secondaryTextColor
                            text: modelData.label
                            enabled: modelData.enabled
                        }
                    }
        
                    Component {
                        id: integerField
                        
                        Column {
                            function forceActiveFocus() {
                                field.forceActiveFocus();
                            }

                            width: column.width
                            spacing: platformStyle.paddingMedium
                            enabled: modelData.enabled
                            
                            Label {
                                id: label

                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: modelData.label
                            }
                            
                            SpinBox {
                                id: field

                                width: parent.width
                                minimum: modelData.minimum
                                maximum: modelData.maximum
                                value: modelData.value
                                onValueChanged: modelData.value = value
                                onAccepted: if (pluginSettings.acceptableInput) root.accept();
                            }
                        }
                    }

                    Component {
                        id: textField
                        
                        Column {
                            function forceActiveFocus() {
                                field.forceActiveFocus();
                            }

                            width: column.width
                            spacing: platformStyle.paddingMedium
                            enabled: modelData.enabled
                            
                            Label {
                                id: label

                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: modelData.label
                            }
                            
                            TextField {
                                id: field

                                width: parent.width
                                text: modelData.value
                                onTextChanged: modelData.value = text
                                onAccepted: if (pluginSettings.acceptableInput) root.accept();
                            }
                        }
                    }

                    Component {
                        id: valueSelector
                        
                        ListSelectorButton {
                            width: column.width
                            model: ListModel {}
                            text: modelData.label
                            enabled: modelData.enabled
                            onSelected: modelData.value = value
                            Component.onCompleted: {
                                for (var i = 0; i < modelData.options.length; i++) {
                                    var option = modelData.options[i];
                                    model.append({name: option.label, value: option.value});
                                }

                                value = modelData.value;
                            }
                        }
                    }
                }
            }
        }
    }
    
    Button {
        id: button
        
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        style: DialogButtonStyle {}
        text: qsTr("Done")
        enabled: (pluginSettings != null) && (pluginSettings.acceptableInput)
        onClicked: root.accept()
    }

    contentItem.states: State {
        name: "Portrait"
        when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation

        AnchorChanges {
            target: flickable
            anchors.right: parent.right
            anchors.bottom: button.top
        }

        PropertyChanges {
            target: flickable
            anchors.rightMargin: 0
            anchors.bottomMargin: platformStyle.paddingMedium
            clip: true
        }

        PropertyChanges {
            target: button
            width: parent.width
        }

        PropertyChanges {
            target: root
            height: Math.min(680, column.height + button.height + platformStyle.paddingMedium * 2)
        }
    }

    onPluginSettingsChanged: {
        if (pluginSettings) {
            title = pluginSettings.title || qsTr("Settings");
            repeater.model = pluginSettings.settings;
        }
        else {
            title = qsTr("Settings");
            repeater.model = null;
        }
    }
    onStatusChanged: {
        if ((status == DialogStatus.Open) && (pluginSettings)) {
            for (var i = 0; i < pluginSettings.settings.length; i++) {
                switch (pluginSettings.settings[i].type) {
                    case Setting.Integer:
                    case Setting.Text:
                        column.children[i].item.forceActiveFocus();
                        return;
                    default:
                        break;
                }
            }
        }
    }
    onAccepted: if (pluginSettings) pluginSettings.accepted();
    onRejected: if (pluginSettings) pluginSettings.rejected();
}
