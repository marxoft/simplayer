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

ToolBar {
    id: root

    property alias text: textField.text

    signal rejected

    function forceActiveFocus() {
        textField.forceActiveFocus();
    }

    spacing: platformStyle.paddingMedium
    alignment: Qt.AlignHCenter | Qt.AlignTop

    TextField {
        id: textField

        width: root.width - button.width - platformStyle.paddingMedium * 3
        onTextChanged: if (!text) root.rejected();
    }

    ToolButton {
        id: button

        iconName: "general_close"
        activeFocusOnPress: false
        onClicked: textField.clear()
    }
}
