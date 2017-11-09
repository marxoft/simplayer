/**
 * Copyright (C) 2016 Stuart Howarth <showarth@marxoft.co.uk>
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

function formatSeconds(seconds) {
    if (seconds <= 0) {
        return "00:00";
    }
    
    var m = Math.floor(seconds / 60);
    var s = seconds % 60;
    
    if (m < 10) {
        m = "0" + m;
    }
    
    if (s < 10) {
        s = "0" + s;
    }
    
    return m + ":" + s;
}
