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

var BASE_URL = "http://marxoft.co.uk/api/cuteradio";

var next = "";
var request = null;

function getStations(url) {
    plugin.started();
    plugin.canFetchMore = false;
    request = new XMLHttpRequest();
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            try {
                var response = JSON.parse(request.responseText);
                var results = [];

                for (var i = 0; i < response.items.length; i++) {
                    var item = response.items[i];
                    results.push({title: item.title, iconSource: "image://icon/mediaplayer_internet_radio",
                    url: item.source});
                }

                if (response.next) {
                    next = BASE_URL + response.next;
                    plugin.canFetchMore = true;
                }

                plugin.finished(results);
            }
            catch(e) {
                plugin.error(e);
            }
        }
    }

    request.open("GET", url);
    request.send();
}

function fetchMoreStations() {
    getStations(next);
}

function searchStations(query) {
    getStations(BASE_URL + "/stations?search=" + query);
}

function cancel() {
    if (request) {
        request.abort();
        request = null;
    }

    plugin.canceled();
}
