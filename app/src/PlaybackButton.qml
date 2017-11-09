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

AbstractButton {
    id: root

    Image {
        id: image

        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingSmall
            verticalCenter: parent.verticalCenter
        }
        width: 48
        height: 48
        sourceSize: "48x48"
        smooth: true
        source: coverImage.source
    }

    Label {
        id: titleLabel

        anchors {
            left: image.right
            leftMargin: platformStyle.paddingSmall
            right: row.left
            rightMargin: platformStyle.paddingSmall
            top: image.top
        }
        elide: Text.ElideRight
        font.pointSize: platformStyle.fontSizeSmall
        text: audioPlayer.metaData.title ? audioPlayer.metaData.title : qsTr("(unknown title)")
    }

    Label {
        id: positionLabel

        anchors {
            left: titleLabel.left
            right: titleLabel.right
            bottom: image.bottom
        }
        elide: Text.ElideRight
        font.pointSize: platformStyle.fontSizeSmall
        text: audioPlayer.metaData.artist ? audioPlayer.metaData.artist : qsTr("(unknown artist)")
    }

    ToolButtonStyle {
        id: transparentToolButtonStyle
        
        background: ""
        backgroundChecked: ""
        backgroundDisabled: ""
        backgroundPressed: ""
        buttonWidth: 48
        buttonHeight: 48
        iconWidth: 48
        iconHeight: 48
    }

    Row {
        id: row

        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingSmall
            verticalCenter: parent.verticalCenter
        }

        ToolButton {
            action: previousAction
            iconSource: "/etc/hildon/theme/mediaplayer/Back" + (pressed ? "Pressed" : "") + ".png"
            style: transparentToolButtonStyle
        }

        ToolButton {
            action: playAction
            style: transparentToolButtonStyle
        }

        ToolButton {
            action: nextAction
            iconSource: "/etc/hildon/theme/mediaplayer/Forward" + (pressed ? "Pressed" : "") + ".png"
            style: transparentToolButtonStyle
        }
    }
}
