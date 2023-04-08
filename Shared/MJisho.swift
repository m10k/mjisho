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

class MJishoSense: Identifiable {
    var english: [String]
    var id: Int

    init() {
        self.id = -1
        self.english = []
    }

    init(english: [String]) {
        self.id = -1
        self.english = english
    }

    init(id: Int, english: [String]) {
        self.id = id
        self.english = english
    }

    func addEnglish(english: String) {
        self.english.append(english)
    }

    func setId(id: Int) {
        self.id = id
    }
}

class MJishoEntry: Identifiable {
    var id: Int
    var readings: [String]
    var writings: [String]
    var meanings: [MJishoSense]

    init() {
        self.id = -1
        self.readings = []
        self.writings = []
        self.meanings = []
    }

    init(id: Int, readings: [String], writings: [String], meanings: [MJishoSense]) {
        var mid: Int = 0

        self.id = id
        self.readings = readings
        self.writings = writings
        self.meanings = meanings

        for meaning in self.meanings {
            meaning.setId(id: mid)
            mid += 1
        }
    }

    func setId(id: Int) {
        self.id = id
    }

    func setId(id: String) {
        self.id = Int(id)!
    }

    func addReading(reading: String) {
        self.readings.append(reading)
    }

    func addWriting(writing: String) {
        self.writings.append(writing)
    }

    func addMeaning(meaning: MJishoSense) {
        self.meanings.append(meaning)
        meaning.setId(id: self.meanings.count)
    }
}

func isEnglish(query: String) -> Bool {
    for char in query {
        if !char.isASCII {
            return false
        }
    }

    return true
}

let hiragana: String = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽぁぃぅぇぉゃゅょっ"
let katakana: String = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポァィゥェォャュョッー"
let regex: String = "*?"


func isReading(query: String) -> Bool {
    /*
     * A query is a reading if it consists only of hiragana,
     * katakana, and regex characters.
     */
    for char in query {
        if !hiragana.contains(char) && !katakana.contains(char) && !regex.contains(char) {
            return false
        }
    }

    return true
}

class MJisho {
    static let instance = MJisho()
    static var entries: [MJishoEntry] = []

    private init() {

    }

    static func clear() {
        entries.removeAll()
    }

    static func addEntry(entry: MJishoEntry) {
        entries.append(entry)
    }

    static func lookup(query: String) -> [MJishoEntry] {
        if isEnglish(query: query) {
            return self.lookupEnglish(query: query)
        }

        return self.lookupJapanese(query: query)
    }

    static func lookupJapanese(query: String) -> [MJishoEntry] {
        if(isReading(query: query)) {
            return self.lookupReading(query: query)
        }

        return self.lookupWriting(query: query)
    }

    static func lookupReading(query: String) -> [MJishoEntry] {
        var result: [MJishoEntry] = []

        for entry in entries {
            for reading in entry.readings {
                if SimpleRegex.match(input: reading, regex: query) {
                    result.append(entry)
                    break
                }
            }
        }

        return result
    }

    static func lookupWriting(query: String) -> [MJishoEntry] {
        var result: [MJishoEntry] = []

        for entry in entries {
            for writing in entry.writings {
                if SimpleRegex.match(input: writing, regex: query) {
                    result.append(entry)
                    break
                }
            }
        }

        return result
    }

    static func lookupEnglish(query: String) -> [MJishoEntry] {
        var result: [MJishoEntry] = []

        for entry in entries {
            var entry_added: Bool = false

            for meaning in entry.meanings {
                for english in meaning.english {
                    if SimpleRegex.match(input: english, regex: query) {
                        result.append(entry)
                        entry_added = true
                        break
                    }
                }

                if entry_added {
                    break
                }
            }
        }

        return result
    }
}
