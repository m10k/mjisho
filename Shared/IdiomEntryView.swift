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

struct IdiomEntryView: View {
    let data: IdiomEntry

    init(data: IdiomEntry) {
        self.data = data
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 3, content: {
                Text("句").font(.title2).padding()

                VStack(alignment: .leading, spacing: 3) {
                    ForEach(data.phrases) { phrase in
                        VStack(alignment: .leading, spacing: 1) {
                            Text(phrase.reading).font(.footnote)
                            Text(phrase.writing).font(.title3)
                        }.padding(5)
                    }.padding(5)

                    Divider()
                }
            })

            HStack(alignment: .top, spacing: 3, content: {
                Text("意").font(.title2).padding()

                VStack(alignment: .leading, spacing: 3) {
                    ForEach(data.meanings) { meaning in
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(alignment: .top, spacing: 1) {
                                Text("説").padding()
                                Text(meaning.meaning).font(.title3).padding(5)
                            }
                            HStack(alignment: .top, spacing: 1) {
                                Text("例").padding()
                                Text(meaning.example).font(.title3).padding(5)
                            }
                        }.padding(5)
                    }
                }
            })

            if !data.synonyms.isEmpty {
                HStack(alignment: .top, spacing: 3) {
                    Text("類").font(.title2).padding()

                    VStack(alignment: .leading, spacing: 3) {
                        Divider()

                        ForEach(data.synonyms, id: \.self) {
                            synonym in
                            Text(synonym).font(.title3).padding(5)
                        }.padding(5)
                    }.padding(5)
                }
            }

            if !data.seealso.isEmpty {
                HStack(alignment: .top, spacing: 3, content: {
                    Text("他").font(.title2).padding()

                    VStack(alignment: .leading, spacing: 3) {
                        Divider()

                        ForEach(data.seealso, id: \.self) { seealso in
                            Text(seealso).font(.title3).padding(5)
                        }.padding(5)
                    }.padding(5)
                })
            }

            Spacer()
        }
    }
}

struct IdiomEntryView_Previews: PreviewProvider {
    static var previews: some View {
        IdiomEntryView(data: IdiomEntry(id: 0,
                                        phrases: [ IdiomPhrase(id: 0,
                                                               reading: "ああいえばこういう",
                                                               writing: "ああ言えばこう言う",
                                                               mode: IdiomPhrase.Mode.intransitive),
                                                   IdiomPhrase(id: 1,
                                                               reading: "ああいえばこういう",
                                                               writing: "ああ言えばこう言う",
                                                               mode: IdiomPhrase.Mode.transitive)],
                                        meanings: [IdiomSense(id: 0,
                                                              meaning: "色々と理屈を並べ、相手の意見に素直に従おうとしない様子。",
                                                              example: "全くこの子には呆れたね。ああ言えばこう言うで、少しにも人の言うことを聞こうとしないのだから。")],
                                        synonyms: [
                                            "ああ言えばこう言う",
                                            "ああ言えばこう言う"
                                        ],
                                        seealso: [
                                            "ああ言えばこう言う",
                                            "ああ言えばこう言う"
                                        ]))
    }
}
