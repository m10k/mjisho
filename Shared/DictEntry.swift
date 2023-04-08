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

import SwiftUI

struct DictEntry: View {
    let data: MJishoEntry

    init(data: MJishoEntry) {
        self.data = data
    }

    var body: some View {
        HStack(alignment: .top, spacing: 3) {
            VStack(alignment: .leading, spacing: 3) {
                VStack(alignment: .leading) {
                    ForEach(self.data.readings, id: \.self) {
                        furigana in

                        Text(furigana).font(.footnote)
                    }

                    ForEach(self.data.writings, id: \.self) {
                        writing in

                        Text(writing).font(.title3)
                    }
                }
            }.frame(minWidth: 128.0,
                    maxWidth: 128.0,
                    alignment: .topLeading)

            VStack(alignment: .leading, spacing: 3) {
                ForEach(self.data.meanings) {
                    sense in

                    ForEach(sense.english, id: \.self) {
                        meaning in
                        Text(meaning).font(.body)
                    }
                }
            }
        }
    }
}

struct DictEntry_Previews: PreviewProvider {
    static var previews: some View {
        let entry = MJishoEntry(id: 0,
                                readings: ["ほげ", "ホゲ"],
                                writings: ["保気", "歩毛", "ＨＯＧＥ"],
                                meanings: [
                                    MJishoSense(english: [
                                        "hoge", "foobar", "foo"
                                    ])
                                ])

        DictEntry(data: entry)
    }
}
