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
 * \class GroupSetting
 *
 * Represents a group header label.
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
 *     GroupSetting {
 *         id: group
 *
 *         label: "General settings"
 *     }
 * }
 * \endcode
 *
 * \sa Settings
 */
Setting {
    type: Setting.Group
}
