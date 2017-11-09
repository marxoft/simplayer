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
import "Setting.js" as Setting

/**
 * \class TextSetting
 *
 * Represents a text setting.
 *
 * Example:
 *
 * \code
 * import QtQuick 1.0
 * import SimPlayer 1.0
 *
 * Settings {
 *     id: settings
 *
 *     TextSetting {
 *         id: someText
 *
 *         label: "Enter text"
 *         value: "some text"
 *     }
 * }
 * \endcode
 *
 * \sa Settings
 */
Setting {
    /**
     * The current value of the setting.
     *
     * The default is an empty string.
     */
    property string value

    type: Setting.Text
}
