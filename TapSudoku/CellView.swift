//
//  CellView.swift
//  TapSudoku
//
//  Created by Nigel Gee on 13/12/2022.
//

import SwiftUI

struct CellView: View {
    enum HighlightState {
        case standard, highlighted, selected

        var color: Color {
            switch self {
            case .standard:
                return .squareStandard
            case .highlighted:
                return .squareHighlighted
            case .selected:
                return .squareSelected
            }
        }
    }

    let number: Int
    let selectedNumber: Int
    let highlightState: HighlightState
    let isCorrect: Bool
    let isDisable: Bool
    var onSelected: ()-> Void

    var body: some View {
        Button(action: onSelected) {
            Text(displayNumber)
                .font(.title)
                .foregroundColor(foregroundColor)
                .frame(maxWidth: 100, maxHeight: 100)
                .background(highlightState.color)
        }
        .disabled(isDisable)
        .buttonStyle(.plain)
        .accessibilityShowsLargeContentViewer()
    }

    var displayNumber: String {
        if number == 0 {
            return ""
        } else {
            return String(number)
        }
    }

    var foregroundColor: Color {
        if isCorrect {
            if number == selectedNumber {
                return .squareTextSame
            } else {
                return .squareTextCorrect
            }
        } else {
            return .squareTextWrong
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(number: 1, selectedNumber: 1, highlightState: .standard, isCorrect: true, isDisable: false) { }
    }
}
