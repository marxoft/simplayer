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

/**
 * \class SearchPlugin
 *
 * The base class for SimPlayer search plugins.
 *
 * The SearchPlugin class is used for implementing search plugins in SimPlayer.
 * To implement a search plugin, place a QML file defining an instance of SearchPlugin in
 * one of the following directories:
 *
 * \ul
 * \li /opt/simplayer/plugins/search
 * \li /home/user/simplayer/plugins/search
 *
 * The plugin should provide a display \a name, a \a description, and (optionally) an \a icon.
 * Additionally, the plugin may provide settings using the \a settings and \a searchSettings properties.
 *
 * The plugin should provide search functions by implementing the \a onSearch and \a onFetchMore handlers,
 * emitting the \a started(), \a finished(), \a canceled() and \a error() signals as appropriate.
 *
 *
 * Example search plugin:
 *
 * \code
 * import QtQuick 1.0
 * import org.hildon.utils 1.0
 * import SimPlayer 1.0
 *
 * SearchPlugin {
 *     id: plugin
 *
 *     name: "Local music search"
 *     description: "A plugin that searches for local music files"
 *     iconSource: "image://icon/general_folder"
 *     settings: Settings {
 *         title: "Settings"
 *
 *         TextSetting {
 *             id: pathSetting
 *
 *             label: "Folder path"
 *             value: "/home/user/MyDocs"
 *         }
 *
 *         ListSetting {
 *             id: sortSetting
 *
 *             label: "Order results by"
 *             value: Directory.Name
 *
 *             ListSettingOption {
 *                 label: "Name ascending"
 *                 value: Directory.Name
 *             }
 *
 *             ListSettingOption {
 *                 label: "Name descending"
 *                 value: Directory.Name | Directory.Reversed
 *             }
 *
 *             ListSettingOption {
 *                 label: "Date ascending"
 *                 value: Directory.Name
 *             }
 *
 *             ListSettingOption {
 *                 label: "Date descending"
 *                 value: Directory.Time | Directory.Reversed
 *             }
 *         }
 *     }
 *     searchSettings: Settings {
 *         title: "Search settings"
 *         acceptableInput: querySetting.value != ""
 *
 *         TextSetting {
 *             id: querySetting
 *
 *             label: "Search query"
 *             value: ""
 *         }
 *
 *        onAccepted: dir.search(querySetting.value)
 *        onRejected: error("No search query specified")
 *     }
 *
 *     Directory {
 *         id: dir
 *
 *         function search(query) {
 *             plugin.started();
 *             var results = [];
 *             var files = entryList();
 *             var re = new RegExp(query, "i");
 *
 *             for (var i = 0; i < files.length; i++) {
 *                 var file = files[i];
 *
 *                 if (re.test(file)) {
 *                     results.push({title: file, iconSource: "image://icon/gnome-mime-audio-mp3",
 *                         url: absoluteFilePath(file)});
 *                 }
 *             }
 *
 *             plugin.finished(results);
 *         }
 *
 *         path: pathSetting.value
 *         nameFilters: ["*.mp3"]
 *         sorting: sortSetting.value
 *     }
 *
 *     onSearch: searchSettingsRequest()
 *     onCancel: canceled()
 * }
 * \endcode
 *
 * \sa Settings
 */
Object {
    id: root

    /* Properties */

    /**
     * \internal
     *
     * The unique identifier of the plugin.
     *
     * The default is an empty string.
     */
    property string pluginId

    /**
     * The display name of the plugin.
     *
     * The default is an empty string.
     */
    property string name

    /**
     * The description of the plugin.
     *
     * The default is an empty string.
     */
    property string description

    /**
     * The source of the plugin's icon.
     *
     * The default is an empty string.
     */
    property string iconSource

    /**
     * Whether the plugin can fetch more results.
     *
     * The default is \c false.
     */
    property bool canFetchMore: false

    /**
     * type:Settings
     *
     * The persistent settings for the plugin.
     *
     * The default is \c null
     *
     * These settings will be accessed via the application settings dialog.
     */
    property QtObject settings

    /**
     * type:Settings
     *
     * The search settings for the plugin.
     *
     * The default is \c null.
     *
     * These settings will be accessed when the plugin emits the settingsRequest() signal.
     */
    property QtObject searchSettings

    /* Handlers */

    /**
     * This signal will be emitted when the user requests a search.
     *
     * This signal should be handled by implementing the 'onSearch' handler.
     *
     * Example:
     *
     * \code
     * ...
     *
     * function doSearch() {
     *     started();
     *     var results = [];
     *     // perform search
     *     finished(results);
     * }
     *
     * onSearch: doSearch()
     * \endcode
     */
    signal search

    /**
     * This signal will be emitted when the user requests more results from a search.
     *
     * If applicable, this signal should be handled by implementing the 'onFetchMore' handler.
     *
     * Example:
     *
     * \code
     * ...
     *
     * property int offset: 0
     * canFetchMore: true
     *
     * function doSearch() {
     *     started();
     *     var results = [];
     *     // perform search
     *     offset += results.length;
     *     canFetchMore = results.length > 0;
     *     finished(results);
     * }
     * 
     * onSearch: {
     *     offset = 0;
     *     doSearch();
     * }
     * onFetchMore: doSearch()
     * \endcode
     */
    signal fetchMore

    /**
     * This signal will be emitted when the user requests a search to be canceled.
     *
     * This signal should be handled by implementing the 'onCancel' handler.
     *
     * Example:
     *
     * \code
     * ...
     *
     * function cancelSearch() {
     *     \\ cancel search
     *     canceled();
     * }
     *
     * onCancel: cancelSearch()
     * \endcode
     *
     * \sa canceled()
     */
    signal cancel

    /* Signals */

    /**
     * This signal should be emitted when a search has started.
     *
     * Example:
     *
     * \code
     * ...
     *
     * function doSearch() {
     *     started();
     *     // perform search
     * }
     * \endcode
     *
     * \sa finished()
     */
    signal started

    /**
     * This signal should be emitted when settings are required in order to perform a search.
     *
     * Example:
     *
     * \code
     * ...
     *
     * searchSettings: Settings {
     *     title: "Settings"
     *
     *     TextSetting {
     *         id: query
     *
     *         label: "Search query"
     *         value: "foo"
     *     }
     * }
     * onSearch: searchSettingsRequest()
     * \endcode
     */
    signal searchSettingsRequest

    /**
     * This signal should be emitted when a search has been canceled.
     *
     * Example:
     *
     * \code
     * ...
     *
     * function cancelSearch() {
     *     // cancel search
     *     canceled();
     * }
     *
     * onCancel: cancelSearch()
     * \endcode
     *
     * \sa cancel()
     */
    signal canceled

    /**
     * This signal should be emitted when the search is completed.
     *
     * The \a results parameter should be an array of JS objects with the following properties:
     *
     * \ul
     * \li title - The title of the song/item.
     * \li iconSource - The URI of the icon (optional).
     * \li url - The source URL of the song/item.
     *
     * Example:
     *
     * \code
     * ...
     *
     * function doSearch() {
     *     started();
     *     var results = [];
     *     // perform search
     *     finished(results);
     * }
     * \endcode
     *
     * \sa started()
     */
    signal finished(variant results)

    /**
     * This signal should be emitted when an error occurs.
     *
     * The \a errorString parameter should provide a description of the error.
     *
     * Example:
     *
     * \code
     * ...
     *
     * function doSearch(query) {
     *     if (!query) {
     *         error("No search query");
     *         return;
     *     }
     *
     *     // perform search
     * }
     * \endcode
     */
    signal error(string errorString)
}
