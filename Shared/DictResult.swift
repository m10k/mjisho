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

struct DictResult: Identifiable {
    let id: Int
    let japanese: String
    let english: String
    let attributes: String
    let furigana: String

    init(id: Int, japanese: String, furigana: String, attributes: String, english: String) {
        self.id = id
        self.japanese = japanese
        self.english = english
        self.attributes = attributes
        self.furigana = furigana
    }
}
