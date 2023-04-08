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

struct DictInput: View {
    private var placeholder: String = "日本語または英語を入力"
    @State public var searchString: String = ""

    let searchAction: (String) -> Void

    init(searchAction: @escaping (String) -> Void,
         placeholder: String) {
        self.searchAction = searchAction
        self.placeholder = placeholder
    }

    init(searchAction: @escaping (String) -> Void) {
        self.searchAction = searchAction
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0.0) {
            TextField(self.placeholder, text: $searchString,
                          onCommit: {
                            self.searchAction(searchString)
                          })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8.0)
        }
    }
}

struct DictInput_Previews: PreviewProvider {
    static var previews: some View {
        DictInput(searchAction: { query in
            print(query)
        })
    }
}
