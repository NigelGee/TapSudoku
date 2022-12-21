//
//  ContentViewModel.swift
//  TapSudoku
//
//  Created by Nigel Gee on 15/12/2022.
//

import Foundation

extension ContentView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var board = Board(difficulty: .testing)
        @Published var selectedRow = -1
        @Published var selectedCol = -1
        @Published var selectedNum = 0
        @Published var solved = false
        @Published var showingNewGame = false
        @Published var counts = [Int: Int]()

        let spacing = 2.5

        func highlightState(for row: Int, col: Int) -> CellView.HighlightState {
            if row == selectedRow {
                if col == selectedCol {
                    return .selected
                } else {
                    return .highlighted
                }
            } else if col == selectedCol {
                return .highlighted
            } else {
                return .standard
            }
        }

        func enter(_ number: Int) {
            if board.playerBoard[selectedRow][selectedCol] == number {
                board.playerBoard[selectedRow][selectedCol] = 0
                selectedNum = 0
            } else {
                board.playerBoard[selectedRow][selectedCol] = number
                selectedNum = number
            }
        }

        func newGame(difficulty: Board.Difficulty) {
            board = Board(difficulty: difficulty)
            selectedRow = -1
            selectedCol = -1
            selectedNum = 0
        }

        func updateCounts() {
            solved = false
            var newCounts = [Int: Int]()
            var correctCount = 0

            for row in 0..<board.size {
                for col in 0..<board.size {
                    if validation(row: row, col: col) {
                        let value = board.playerBoard[row][col]

                        if value != 0 {
                            newCounts[value, default: 0] += 1
                        }
                    }
                }
            }

            counts = newCounts

            for i in 0...board.size {
                correctCount += newCounts[i, default: 0]
            }

            if correctCount == board.size * board.size {
                Task {
                    try await Task.sleep(for:.seconds(0.5))
                    showingNewGame = true
                    solved = true
                }
            }
        }

        func validation(row: Int, col: Int) -> Bool {
//            board.playerBoard[row][col] == board.fullBoard[row][col]

            guard row == selectedRow || col == selectedCol else { return true }

            // MARK:- Counts the numbers in a ROW
            var rowCounts = [Int: Int]()
            for i in board.playerBoard[row] {
                rowCounts[i, default: 0] += 1
            }

            // MARK:- Counts the numbers in a COLUMN
            var colCounts = [Int: Int]()
            for i in 0..<board.size {
                let value = board.playerBoard[i][col]
                colCounts[value, default: 0] += 1
            }

            // MARK:- Validates for only one number in ROW or COLUMN
            if (rowCounts[selectedNum] ?? 0) > 1 || (colCounts[selectedNum] ?? 0) > 1 {
                if board.playerBoard[row][col] == selectedNum {
                    return false
                }
            }

            // MARK:- Count and validates for only one number in 3x3 box
            for numRow in [0, 3, 6] {
                for numCol in [0, 3, 6] {
                    var boxCounts = [Int: Int]()
                    for r in numRow...numRow + 2 {
                        for c in numCol...numCol + 2 {
                            let value = board.playerBoard[r][c]
                            boxCounts[value, default: 0] += 1
                        }
                    }

                    if row == numRow || row == numRow + 1 || row == numRow + 2 {
                        if col == numCol || col == numCol + 1 || col == numCol + 2 {
                            for r in numRow...numRow + 2 {
                                for c in numCol...numCol + 2 {
                                    let value = board.playerBoard[r][c]
                                    if boxCounts[value] ?? 0 > 1 {
                                        if board.playerBoard[row][col] == selectedNum {
                                            return false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return true
        }

        func isDisabled(row: Int, col: Int) -> Bool {
            board.disableBoard[row][col] != 0
        }
    }
}
