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

struct SettingsView: View {
    let title: String = "mjishoについて"

    let edrdg_url: String = "https://www.edrdg.org"
    let edrdg_title: String = "Electronic Dictionary Research and Development Group"
    let kanyouku_url: String = "https://www.books-sanseido.jp/booksearch/BookSearchDetail.action?shopCode=&areaCode=&shoshiKubun=1&isbn=4-385-13846-X"
    let kanyouku_title: String = "三省堂慣用句便覧"
    let dictinfo: String =    "このアプリはEDRDGプロジェクトに編集されたJMdict辞書を使用しています。\n" +
        "慣用句は倉持保男・阪田雪子編の慣用句便覧（三省堂）により。\n" +
        "詳しくは以下のウェブサイトをご覧下さい。"

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {

            Text(title).font(.title).padding()
            Text(dictinfo).font(.caption).padding()
            Link(edrdg_title, destination: URL(string: edrdg_url)!).padding()
            Link(kanyouku_title, destination: URL(string: kanyouku_url)!).padding()

            Divider().padding()

            HStack(alignment: .top, spacing: 3) {
                Spacer()
                Button("辞書データを更新", action: {
                    removeDict()
                    initializeDict()
                }).padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                            .shadow(radius: 1)
                            .padding(1)
                    }
                )
                .foregroundColor(.primary).animation(.spring())
                .padding()

                Spacer()
            }

            Spacer()

        }.padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
