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

class IdiomParser: NSObject {
    var currentEntry: IdiomEntry
    var currentSense: IdiomSense
    var currentPhrase: IdiomPhrase
    var currentElement: String
    var startTime: Date = Date.distantPast
    var onComplete: () -> Void
    var currentPhraseId: Int
    var currentSenseId: Int

    private let parser: XMLParser

    init(url: URL, onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        currentEntry = IdiomEntry()
        currentPhrase = IdiomPhrase()
        currentSense = IdiomSense()
        currentElement = ""
        currentPhraseId = 0
        currentSenseId = 0

        parser = XMLParser(contentsOf: url)!
        super.init()
        parser.delegate = self
    }

    func parse() {
        self.startTime = Date.init()
        parser.parse()
    }
}

extension IdiomParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {

        self.currentElement = elementName

        if elementName == "ERROR" {
            parser.abortParsing()
        } else if elementName == "sense" {
            self.currentSense.id = self.currentSenseId
            self.currentSenseId += 1
        } else if elementName == "phrase" {
            self.currentPhrase.id = self.currentPhraseId
            self.currentPhraseId += 1

            for (name, value) in attributeDict {
                if name == "furigana" {
                    self.currentPhrase.reading = value
                } else if name == "variant" {
                    if value == "transitive" {
                        self.currentPhrase.mode = IdiomPhrase.Mode.transitive
                    } else if value == "intransitive" {
                        self.currentPhrase.mode = IdiomPhrase.Mode.intransitive
                    } else {
                        self.currentPhrase.mode = IdiomPhrase.Mode.undefined
                    }
                }
            }
        } else if elementName == "definition" {
            for (name, value) in attributeDict {
                if name == "id" {
                    self.currentEntry.setId(id: value)
                    break
                }
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "definition" {
            IdiomDictionary.addEntry(entry: currentEntry)
            self.currentEntry = IdiomEntry()
        } else if elementName == "sense" {
            self.currentEntry.addMeaning(meaning: self.currentSense)
            self.currentSense = IdiomSense()
        } else if elementName == "phrase" {
            self.currentEntry.addPhrase(phrase: self.currentPhrase)
            self.currentPhrase = IdiomPhrase()
        }

        self.currentElement = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.currentElement == "phrase" {
            self.currentPhrase.writing = string
        } else if self.currentElement == "meaning" {
            self.currentSense.meaning = string
        } else if self.currentElement == "example" {
            self.currentSense.example = string
        } else if self.currentElement == "synonym" {
            self.currentEntry.addSynonym(synonym: string)
        } else if self.currentElement == "see-also" {
            self.currentEntry.addSeeAlso(seealso: string)
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parse error: \(parseError.localizedDescription)")
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        let interval = Date().timeIntervalSince(self.startTime)

        print("Parsed \(IdiomDictionary.entries.count) entries in \(interval) seconds")

        self.onComplete()
    }
}
