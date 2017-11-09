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
 * \class IntegerSetting
 *
 * Represents an integer setting.
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
 *     IntegerSetting {
 *         id: anInt
 *
 *         label: "Pick a number"
 *         minimum: 0
 *         maximum: 10
 *         value: 5
 *     }
 * }
 * \endcode
 *
 * \sa Settings
 */
Setting {
    /**
     * The minimum value of the setting.
     *
     * The default is \c 0.
     */
    property int minimum: 0

    /**
     * The maximum value of the setting.
     *
     * The default is \c 100.
     */
    property int maximum: 100

    /**
     * The current value of the setting.
     *
     * The default is 0.
     */
    property int value: 0

    type: Setting.Integer
}
