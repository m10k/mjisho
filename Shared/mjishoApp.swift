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

func getLocalUrl(file: String) -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent(file)
}

func removeLocalUrl(file: URL) -> Bool {
    do {
        try FileManager.default.removeItem(at: file)
        return true
    } catch {
        return false
    }
}

func localUrlExists(url: URL) -> Bool {
    do {
        return try url.checkResourceIsReachable()
    } catch {
        return false
    }
}

func downloadDict(source: URL, destination: URL,
                  doneFunc: @escaping (URL) -> Void,
                  errorFunc: @escaping 	(Error) -> Void) -> Void {
    let dictDownload = URLSession.shared.downloadTask(with: source) {
        urlOrNil, responseOrNil, errorOrNil in

        guard let downloadedUrl: URL = urlOrNil else { return }

        do {
            let compressed = try! Data(contentsOf: downloadedUrl)
            let xml = try NSData(data: compressed).decompressed(using: .lzfse) as Data?
            try xml!.write(to: destination, options: .atomic)

            doneFunc(destination)
        } catch {
            print("\(error)")
            errorFunc(error)
        }
    }

    dictDownload.resume()
}

func removeDict() {
    let localDictUrl: URL = getLocalUrl(file: mjishoApp.dictName)
    let localIdiomsUrl: URL = getLocalUrl(file: mjishoApp.idiomsName)

    if !removeLocalUrl(file: localDictUrl) {
        print("Dictionary couldn't be removed. Maybe it hasn't been downloaded?")
    }
    if !removeLocalUrl(file: localIdiomsUrl) {
        print("Idiom dictionary couldn't be removed. Maybe it hasn't been downloaded?")
    }

    MJisho.clear()
    IdiomDictionary.clear()
}

func parseDict(dictUrl: URL) {
    let parser = MJishoParser(url: dictUrl, onComplete: {
        print("Dictionary successfully parsed")
    })

    parser.parse()
}

func parseIdioms(dictUrl: URL) {
    let parser = IdiomParser(url: dictUrl, onComplete: {
        print("Idioms dictionary successfully parsed")
    })

    parser.parse()
}

func initializeDict() {
    let localDictUrl: URL = getLocalUrl(file: mjishoApp.dictName)
    let localIdiomsUrl: URL = getLocalUrl(file: mjishoApp.idiomsName)

    if !localUrlExists(url: localDictUrl) {
        print("Dictionary doesn't exist locally. Will download...")

        downloadDict(source: mjishoApp.dictUrl, destination: localDictUrl, doneFunc: {
            url in
            parseDict(dictUrl: url)
        }, errorFunc: {
            err in
            print(err)
            /* FIXME: Display an error message to the user and exit */
        })
    } else {
        parseDict(dictUrl: localDictUrl)
    }

    if !localUrlExists(url: localIdiomsUrl) {
        print("Idiom dictionary doesn't exist locally. Will download...")

        downloadDict(source: mjishoApp.idiomsUrl, destination: localIdiomsUrl, doneFunc: {
            url in
            parseIdioms(dictUrl: url)
        }, errorFunc: {
            err in
            print(err)
            /* FIXME: Display an error message */
        })
    } else {
        parseIdioms(dictUrl: localIdiomsUrl)
    }
}

@main
struct mjishoApp: App {
    let captionLoading: String = "辞書を初期化しています。\n暫くお待ちを"
    static let dictUrl = URL(string: "https://m10k.jp/JMdict_e.lzfse")!
    static let dictName: String = "dict.xml"
    static let idiomsUrl = URL(string: "https://m10k.jp/kanyouku.xml.lzfse")!
    static let idiomsName: String = "kanyouku.xml"

    @State var loading: Bool = true

    func parseDict(dictUrl: URL) {
        let parser = MJishoParser(url: dictUrl, onComplete: {
            self.loading = false
        })

        parser.parse()
    }

    func parseIdioms(dictUrl: URL) {
        let parser = IdiomParser(url: dictUrl, onComplete: {
            self.loading = false
        })

        parser.parse()
    }

    func initializeDict() {
        let localDictUrl: URL = getLocalUrl(file: mjishoApp.dictName)
        let localIdiomsUrl: URL = getLocalUrl(file: mjishoApp.idiomsName)

        if !localUrlExists(url: localDictUrl) {
            print("Dictionary doesn't exist locally. Will download...")

            downloadDict(source: mjishoApp.dictUrl, destination: localDictUrl, doneFunc: {
                url in
                parseDict(dictUrl: url)
            }, errorFunc: {
                err in

                self.loading = false
                /* FIXME: Display an error message to the user and exit */
            })
        } else {
            parseDict(dictUrl: localDictUrl)
        }

        if !localUrlExists(url: localIdiomsUrl) {
            print("Idiom dictionary doesn't exist locally. Will download...")

            downloadDict(source: mjishoApp.idiomsUrl, destination: localIdiomsUrl, doneFunc: {
                url in
                parseIdioms(dictUrl: url)
            }, errorFunc: {
                err in

                self.loading = false
                /* FIXME: Display an error message */
            })
        } else {
            parseIdioms(dictUrl: localIdiomsUrl)
        }
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                ZStack(alignment: .center) {
                    DictionaryView()

                    if self.loading {
                        StatusIndicator(caption: captionLoading)
                    }
                }.tabItem {
                    Image(systemName: "character.book.closed")
                    Text("言葉")
                }

                IdiomView()
                .tabItem {
                    Image(systemName: "quote.bubble")
                    Text("慣用句")
                }

                SettingsView()
                .tabItem{
                    Image(systemName: "command.square")
                    Text("設定")
                }
            }.font(.headline).onAppear(perform: {
                initializeDict()
            }).disabled(loading)
        }
    }
}
