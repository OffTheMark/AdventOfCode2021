//
//  main.swift
//  Day4
//
//  Created by Marc-Antoine Malépart on 2021-12-04.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day4: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let content = try readFile()
        var parts = content.components(separatedBy: "\n\n")
        let drawnNumbers = parts.removeFirst().components(separatedBy: ",").compactMap(Int.init)
        let boards = parts.map(BingoBoard.init)
        
        let scoreOfFirstWinningBoard = part1(drawnNumbers: drawnNumbers, boards: boards)
        printTitle("Part 1", level: .title1)
        print("Score:", scoreOfFirstWinningBoard, terminator: "\n\n")
        
        let scoreOfLastWinningBoard = part2(drawnNumbers: drawnNumbers, boards: boards)
        printTitle("Part 2", level: .title1)
        print("Score:", scoreOfLastWinningBoard)
    }
    
    func part1(drawnNumbers: [Int], boards: [BingoBoard]) -> Int {
        var boards = boards
        
        for (drawnNumber, index) in product(drawnNumbers, boards.indices) {
            boards[index].markNumber(drawnNumber)
            
            if boards[index].isWinning() {
                let sumOfUnmarkedNumbers = boards[index].unmarkedNumbers().reduce(0, +)
                return drawnNumber * sumOfUnmarkedNumbers
            }
        }
        
        fatalError("No board has won after drawing all numbers")
    }
    
    func part2(drawnNumbers: [Int], boards: [BingoBoard]) -> Int {
        var boards = boards
        var boardIndicesThatHaveNotWon = Set<Int>(boards.indices)
        
        for (drawnNumber, index) in product(drawnNumbers, boards.indices) where boardIndicesThatHaveNotWon.contains(index) {
            boards[index].markNumber(drawnNumber)
            
            if boards[index].isWinning() {
                boardIndicesThatHaveNotWon.remove(index)
                
                if boardIndicesThatHaveNotWon.isEmpty {
                    let sumOfUnmarkedNumbers = boards[index].unmarkedNumbers().reduce(0, +)
                    return drawnNumber * sumOfUnmarkedNumbers
                }
            }
        }
        
        fatalError("At least one board has not won after drawing all numbers")
    }
}

Day4.main()
