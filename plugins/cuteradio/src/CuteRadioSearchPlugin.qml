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
import SimPlayer 1.0 as SimPlayer
import "CuteRadioSearchPlugin.js" as CuteRadio

SimPlayer.SearchPlugin {
    id: plugin

    name: "cuteRadio"
    description: qsTr("Provides access to internet radio stations via the cuteRadio data API.")
    iconSource: "image://icon/mediaplayer_internet_radio"
    searchSettings: SimPlayer.Settings {
        title: qsTr("Search settings")
        acceptableInput: query.value != ""

        SimPlayer.TextSetting {
            id: query

            label: qsTr("Search query")
        }

        onAccepted: CuteRadio.searchStations(query.value)
        onRejected: plugin.error(qsTr("No search query specified"))
    }
    onSearch: searchSettingsRequest()
    onFetchMore: if (canFetchMore) CuteRadio.fetchMoreStations();
    onCancel: CuteRadio.cancel()
}
