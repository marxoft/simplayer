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
import org.hildon.utils 1.0
import "SimPlayer.js" as SimPlayer

Object {
    id: root

    property variant searchPlugins: ([])

    function load() {
        return loadSearchPlugins();
    }

    function loadSearchPlugins() {
        var p = [];

        for (var i = 0; i < SimPlayer.SEARCH_PLUGIN_PATHS.length; i++) {
            dir.path = SimPlayer.SEARCH_PLUGIN_PATHS[i];
            var files = dir.entryInfoList();

            for (var j = 0; j < files.length; j++) {
                var file = files[j];
                console.log("PluginManager.loadSearchPlugins(). Plugin found: " + file.fileName);

                try {
                    var component = Qt.createComponent(Qt.resolvedUrl(file.absoluteFilePath));

                    if (component.status == Component.Ready) {
                        var plugin = component.createObject(root);
                        plugin.pluginId = file.completeBaseName;
                        p.push(plugin);
                        console.log("PluginManager.loadSearchPlugins(). Plugin loaded: " + file.fileName);
                    }
                    else {
                        console.log("PluginManager.loadSearchPlugins(). Error loading plugin: " + file.fileName
                        + ". Error: " + component.errorString());
                    }
                }
                catch(e) {
                    console.log("PluginManager.loadSearchPlugins(). Error loading plugin: " +  file.fileName
                    + ". Error: " + e);
                }
            }
        }

        p.sort(function(a, b) { return a.name.toLowerCase() > b.name.toLowerCase() ? 1 : -1; });
        searchPlugins = p;
        return p.length;
    }

    function getSearchPlugin(pluginId) {
        for (var i = 0; i < searchPlugins.length; i++) {
            if (searchPlugins[i].pluginId == pluginId) {
                return searchPlugins[i];
            }
        }

        return null;
    }

    Directory {
        id: dir

        nameFilters: ["*.qml"]
        sorting: Directory.Name
    }
}
