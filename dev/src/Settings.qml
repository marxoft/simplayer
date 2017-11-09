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

import org.hildon.components 1.0

/**
 * \class Settings
 *
 * Represents the settings to be displayed in the user interface.
 *
 * Example:
 *
 * \code
 * Settings {
 *     id: settings
 *
 *     title: "Settings"
 *
 *     GroupSetting {
 *         id: group
 *
 *         label: "General settings"
 *     }
 *
 *     BooleanSetting {
 *         id: abool
 *
 *         label: "Boolean setting"
 *         value: true
 *     }
 *
 *     ListSetting {
 *         id: list
 *
 *         label: "List setting"
 *         value: 1
 *
 *         ListSettingOption {
 *             label: "One"
 *             value: 1
 *         }
 *
 *         ListSettingOption {
 *             label: "Two"
 *             value: 2
 *         }
 *     }
 *
 *     TextSetting {
 *         id: text
 *
 *         label: "Text setting"
 *         value: "Some text"
 *     }
 *
 *     onAccepted: console.log("Settings accepted")
 *     onRejected: console.log("Settings rejected")
 * }
 * \endcode
 *
 * \sa BooleanSetting, GroupSetting, IntegerSetting, ListSetting, TextSetting
 */
Object {
    id: root

    /**
     * The title of the settings.
     */
    property string title: qsTr("Settings")

    /**
     * Whether the current values of the settings are acceptable.
     *
     * The user will only be able to confirm the settings when this property
     * is set to \c true.
     *
     * The default is \c true.
     */
    property bool acceptableInput: true

    property alias settings: root._data

    /**
     * This signal will be emitted when the settings have been accepted.
     */
    signal accepted

    /**
     * This signal will be emitted when the settings have been rejected.
     */
    signal rejected
}
