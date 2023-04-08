/*
 * mjisho - The minimalist Japanese-English dictionary
 * Copyright (C) 2021 Matthias Kruk
 *
 * Canny is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation; either version 3, or (at your
 * option) any later version.
 *
 * Canny is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with canny; see the file COPYING.  If not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

import Foundation

class SimpleRegex {
    static func matchstar(input: String, regex: String) -> Bool {
        var new_input = input
        var new_regex = regex

        while new_regex.count > 0 && new_regex.first == "*" {
            new_regex.removeFirst()
        }

        if new_regex.count == 0 {
            return true
        }

        while new_input.count > 0 {
            if self.match(input: new_input, regex: new_regex) {
                return true
            }

            new_input.removeFirst()
        }

        return false
    }

    static func match(input: String, regex: String) -> Bool {
        if input.isEmpty {
            if regex.isEmpty {
                return true
            }

            if regex.first == "*" {
                var new_regex = regex
                new_regex.removeFirst()

                return self.match(input: input, regex: new_regex)
            }

            return false
        }

        if input.first == regex.first || regex.first == "?" {
            var new_input = input
            var new_regex = regex

            new_input.removeFirst()
            new_regex.removeFirst()

            return self.match(input: new_input, regex: new_regex)
        }

        if regex.first == "*" {
            return self.matchstar(input: input, regex: regex)
        }

        return false
    }
}
