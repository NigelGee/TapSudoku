//
//  Color-Cells.swift
//  TapSudoku
//
//  Created by Nigel Gee on 13/12/2022.
//

import SwiftUI

extension Color {
    // an unselected square
    static let squareStandard = Color(red: 0.22, green: 0.25, blue: 0.3)

    // the square that is currently active for input
    static let squareSelected = Color.blue

    // a square in the same row or column as our selected square
    static let squareHighlighted = Color.blue.opacity(0.6)

    // text for a square with the correct number
    static let squareTextCorrect = Color.white

    // same, but for the wrong number
    static let squareTextWrong = Color.red

    // text for a square that has the same number as our selected square
    static let squareTextSame = Color.yellow
}
