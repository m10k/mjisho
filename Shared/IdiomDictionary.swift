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

class IdiomSense: Identifiable {
    var id: Int
    var meaning: String
    var example: String

    init() {
        self.id = -1
        self.meaning = ""
        self.example = ""
    }

    init(id: Int, meaning: String, example: String) {
        self.id = id
        self.meaning = meaning
        self.example = example
    }
}

class IdiomPhrase: Identifiable {
    enum Mode {
        case transitive
        case intransitive
        case undefined
    }

    var id: Int
    var reading: String
    var writing: String
    var mode: Mode

    init() {
        self.id = -1
        self.reading = ""
        self.writing = ""
        self.mode = Mode.undefined
    }

    init(id: Int, reading: String, writing: String, mode: Mode) {
        self.id = id
        self.reading = reading
        self.writing = writing
        self.mode = mode
    }
}

class IdiomEntry: Identifiable {
    var id: Int
    var phrases: [IdiomPhrase]
    var synonyms: [String]
    var seealso: [String]
    var meanings: [IdiomSense]

    init() {
        self.id = -1
        self.phrases = []
        self.synonyms = []
        self.meanings = []
        self.seealso = []
    }

    init(id: Int, phrases: [IdiomPhrase], meanings: [IdiomSense], synonyms: [String], seealso: [String]) {
        self.id = id
        self.phrases = phrases
        self.meanings = meanings
        self.synonyms = synonyms
        self.seealso = seealso
    }

    func setId(id: Int) {
        self.id = id
    }

    func setId(id: String) {
        self.id = Int(id)!
    }

    func addPhrase(phrase: IdiomPhrase) {
        self.phrases.append(phrase)
    }

    func addMeaning(meaning: IdiomSense) {
        self.meanings.append(meaning)
    }

    func addSynonym(synonym: String) {
        self.synonyms.append(synonym)
    }

    func addSeeAlso(seealso: String) {
        self.seealso.append(seealso)
    }
}

class IdiomDictionary {
    static let instance = IdiomDictionary()
    static var entries: [IdiomEntry] = []

    private init() {

    }

    static func clear() {
        entries.removeAll()
    }

    static func addEntry(entry: IdiomEntry) {
        entries.append(entry)
    }

    static func lookup(query: String) -> [IdiomEntry] {
        if(isReading(query: query)) {
            return self.lookupReading(query: query)
        }

        return self.lookupWriting(query: query)
    }

    static func lookupReading(query: String) -> [IdiomEntry] {
        var result: [IdiomEntry] = []

        for entry in entries {
            for phrase in entry.phrases {
                if SimpleRegex.match(input: phrase.reading, regex: query) {
                    result.append(entry)
                    break
                }
            }
        }

        return result
    }

    static func lookupWriting(query: String) -> [IdiomEntry] {
        var result: [IdiomEntry] = []

        for entry in entries {
            for phrase in entry.phrases {
                if SimpleRegex.match(input: phrase.writing, regex: query) {
                    result.append(entry)
                    break
                }
            }
        }

        return result
    }
}
