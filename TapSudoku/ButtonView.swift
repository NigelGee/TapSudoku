//
//  ButtonView.swift
//  TapSudoku
//
//  Created by Nigel Gee on 14/12/2022.
//

import SwiftUI

struct ButtonView: View {
    @Binding var counts: [Int: Int]
    let enter: (Int) -> Void

    var body: some View {
        HStack {
            Grid {
                ForEach([0, 3, 6], id: \.self) { row in
                    GridRow {
                        ForEach(1..<4) { col in
                            Button("\(String(col + row))") {
                                enter(col + row)
                            }
                            .frame(maxWidth: .infinity)
                            .font(.largeTitle)
                            .disabled(counts[col + row, default: 0] == 9)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(counts: .constant([1: 1])) { _ in }
            .preferredColorScheme(.dark)
    }
}
