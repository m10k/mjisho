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

class MJishoParser: NSObject {
    var currentEntry: MJishoEntry
    var currentSense: MJishoSense
    var currentElement: String
    var startTime: Date = Date.distantPast
    var onComplete: () -> Void

    private let parser: XMLParser

    init(url: URL, onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        currentEntry = MJishoEntry()
        currentSense = MJishoSense()
        currentElement = ""

        parser = XMLParser(contentsOf: url)!
        super.init()
        parser.delegate = self
    }

    func parse() {
        self.startTime = Date.init()
        parser.parse()
    }
}

extension MJishoParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {

        self.currentElement = elementName

        if elementName == "ERROR" {
            parser.abortParsing()
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            MJisho.addEntry(entry: self.currentEntry)
            self.currentEntry = MJishoEntry()
        } else if elementName == "sense" {
            self.currentEntry.addMeaning(meaning: self.currentSense)
            self.currentSense = MJishoSense()
        }

        self.currentElement = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.currentElement == "ent_seq" {
            self.currentEntry.setId(id: string)
        } else if self.currentElement == "keb" {
            self.currentEntry.addWriting(writing: string)
        } else if self.currentElement == "reb" {
            self.currentEntry.addReading(reading: string)
        } else if self.currentElement == "gloss" {
            self.currentSense.addEnglish(english: string)
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parse error: \(parseError.localizedDescription)")
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        let interval = Date().timeIntervalSince(self.startTime)

        print("Parsed \(MJisho.entries.count) entries in \(interval) seconds")

        self.onComplete()
    }
}
