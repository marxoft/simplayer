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
import org.hildon.settings 1.0
import org.hildon.utils 1.0
import SimPlayer 1.0 as SimPlayer

SimPlayer.SearchPlugin {
    id: plugin

    name: qsTr("Folder search")
    description: qsTr("Recursively searches a local folder for music files.")
    iconSource: "image://icon/general_folder"
    searchSettings: SimPlayer.Settings {
        title: qsTr("Search settings")
        acceptableInput: (query.value) && (dir.fileExists(path.value))

        SimPlayer.TextSetting {
            id: query

            label: qsTr("Search query")
        }

        SimPlayer.TextSetting {
            id: path

            label: qsTr("Folder path")
            value: config.path
        }

        SimPlayer.BooleanSetting {
            id: searchFilePath

            label: qsTr("Search full filepath")
            value: config.searchFilePath
        }

        onAccepted: {
            config.path = path.value;
            config.searchFilePath = searchFilePath.value;
            dir.search(query.value);
        }
        onRejected: plugin.error(qsTr("No search settings specified"))
    }
    onSearch: searchSettingsRequest()

    Directory {
        id: dir

        function search(query) {
            plugin.started();
            var results = [];
            var re = new RegExp(query, "i");
            var files = recursiveEntryInfoList();

            if (config.searchFilePath) {
                for (var i = 0; i < files.length; i++) {
                    var file = files[i];

                    if ((re.test(file.absoluteFilePath)) && (config.suffixes.indexOf(file.suffix) != -1)) {
                        results.push({title: file.fileName, iconSource: "image://icon/gnome-mime-audio-mp3",
                            url: file.absoluteFilePath});
                    }
                }
            }
            else {
                for (var i = 0; i < files.length; i++) {
                    var file = files[i];

                    if ((re.test(file.fileName)) && (config.suffixes.indexOf(file.suffix) != -1)) {
                        results.push({title: file.fileName, iconSource: "image://icon/gnome-mime-audio-mp3",
                            url: file.absoluteFilePath});
                    }
                }
            }

            plugin.finished(results);
        }

        path: config.path
        sorting: Directory.Name | Directory.IgnoreCase
        filter: Directory.Files | Directory.Readable | Directory.NoSymLinks
    }

    Settings {
        id: config

        property string path: "/home/user/MyDocs"
        property bool searchFilePath: false
        property string suffixes: "mp3 ogg flac wav m4a wma ape aiff"

        fileName: "/home/user/.config/SimPlayer/plugins/foldersearch.conf"
    }
}
