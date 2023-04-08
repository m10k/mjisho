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

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool

    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct StatusIndicator: View {
    @State var loading: Bool = true
    var caption: String

    init(caption: String) {
        self.caption = caption
    }

    func setLoading(loading: Bool) -> Void {
        self.loading = loading
    }

    var body: some View {
        VStack(alignment: .center) {
            ActivityIndicator(isAnimating: $loading, style: .large)
                .padding()
            Text(caption)
                .multilineTextAlignment(.center)
                .padding()
        }.padding()
    }
}

struct StatusIndicator_Previews: PreviewProvider {
    static var previews: some View {
        StatusIndicator(caption: "辞書を初期化しています。\n暫くお待ちを")
    }
}
