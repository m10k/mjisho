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

struct IdiomView: View {
    @State var results: [IdiomEntry] = []
    @State var result_string: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            if !result_string.isEmpty {
                Text(result_string).font(.title).padding()
                Divider()
            }
            if results.isEmpty {
                Text("ヒント：簡単正規表現").font(.title2).padding()
                Text("? は一文字を補い、* は何でも補う文字です。\n").font(.title3).padding()
                Text("例：「こ?ろ」は　心、小室、焜炉、・・・\n" +
                        "　　「こ*ろ」は　頃、心、高速道路、・・・\n").font(.title3).padding()
            } else {
                List(results) { result in
                    IdiomEntryView(data: result)
                }
            }

            Spacer()

            DictInput(searchAction: { query in
                results.removeAll()
                results = IdiomDictionary.lookup(query: query)

                if results.isEmpty {
                    result_string = "\(query) に一致する慣用句は見付からなかった"
                } else {
                    result_string = ""
                }
            }, placeholder: "慣用句を入力")
        }
    }
}

struct IdiomView_Previews: PreviewProvider {
    static var previews: some View {
        IdiomView()
    }
}
