//
//  ContentView.swift
//  TapSudoku
//
//  Created by Nigel Gee on 13/12/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                    ForEach(0..<9) { row in
                        GridRow {
                            ForEach(0..<9) { col in
                                CellView(number: vm.board.playerBoard[row][col],
                                         selectedNumber: vm.selectedNum,
                                         highlightState: vm.highlightState(for: row, col: col),
                                         isCorrect: vm.validation(row: row, col: col),
                                         isDisable: vm.isDisabled(row: row, col: col)) {
                                    vm.selectedRow = row
                                    vm.selectedCol = col
                                    vm.selectedNum = vm.board.playerBoard[row][col]
                                }

                                if col == 2 || col == 5 {
                                    Spacer()
                                        .frame(width: vm.spacing, height: 1)
                                }
                            }
                        }
                        .padding(.bottom, row == 2 || row == 5 ? vm.spacing : 0)
                    }
                }
                .padding(5)

                Spacer()

                ButtonView(counts: $vm.counts) { number in
                    vm.enter(number)
                }
            }
            .navigationTitle("Tap Sudoku")
            .toolbar {
                Button{
                    vm.showingNewGame = true
                } label: {
                    Label("Start a New Game", systemImage: "plus")
                }
            }
        }
        .onAppear {
//            vm.showingNewGame = true
            vm.updateCounts()
        }
        .onChange(of: vm.board) { _ in
            vm.updateCounts()
        }
        .preferredColorScheme(.dark)
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .alert("Start a new game", isPresented: $vm.showingNewGame) {
            ForEach(Board.Difficulty.allCases, id: \.self) { difficulty in
                Button(String(describing: difficulty).capitalized) {
                    vm.newGame(difficulty: difficulty)
                }

                Button("Cancel", role: .cancel) { }
            }
        } message: {
            if vm.solved {
                Text("You solved the board correctly - good job!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
