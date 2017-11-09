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

.pragma library

// Defines

var AUDIO_FILENAME_FILTERS = ["*.mp3", "*.ogg", "*.flac", "*.wav", "*.m4a", "*.wma", "*.ape", "*.aiff"];
var COVER_FILENAMES = ["cover.jpg", "folder.jpg", "front.jpg"];
var CONFIG_PATH = "/home/user/.config/SimPlayer";
var CONFIG_FILENAME = CONFIG_PATH + "/simplayer.conf";
var SEARCH_PLUGIN_PATHS = ["/opt/simplayer/plugins/search", "/home/user/simplayer/plugins/search"];
var VERSION_NUMBER = "0.3.0";
