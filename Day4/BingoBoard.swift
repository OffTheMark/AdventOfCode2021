//
//  BingoBoard.swift
//  Day4
//
//  Created by Marc-Antoine Malépart on 2021-12-04.
//

import Foundation

struct BingoBoard {
    private var markedPositions = Set<Position>()
    let numbersByPosition: [Position: Int]
    
    mutating func markNumber(_ number: Int) {
        let positions: [Position] = numbersByPosition
            .reduce(into: [], { result, pair in
                if pair.value == number {
                    result.append(pair.key)
                }
            })
        markedPositions.formUnion(positions)
    }
    
    func unmarkedNumbers() -> [Int] {
        numbersByPosition.reduce(into: [], { result, pair in
            if markedPositions.contains(pair.key) {
                return
            }
            
            result.append(pair.value)
        })
    }
    
    func isWinning() -> Bool {
        let containsFullyMarkedRow = (0 ..< 5).contains(where: { row in
            isRowFullyMarked(row)
        })
        
        if containsFullyMarkedRow {
            return true
        }
        
        let containsFullyMarkedColumn = (0 ..< 5).contains(where: { column in
            isColumnFullyMarked(column)
        })
        
        return containsFullyMarkedColumn
    }
    
    private func isRowFullyMarked(_ row: Int) -> Bool {
        return (0 ..< 5).allSatisfy({ column in
            markedPositions.contains(.init(row: row, column: column))
        })
    }
    
    private func isColumnFullyMarked(_ column: Int) -> Bool {
        return (0 ..< 5).allSatisfy({ row in
            markedPositions.contains(.init(row: row, column: column))
        })
    }
    
    struct Position: Hashable {
        let row: Int
        let column: Int
    }
}

extension BingoBoard {
    init(rawValue: String) {
        let lines = rawValue.components(separatedBy: .newlines)
        
        let numbersByPosition: [Position: Int] = lines.enumerated()
            .reduce(into: [:], { result, pair in
                let (row, line) = pair
                let numbers = line.components(separatedBy: .whitespaces).compactMap(Int.init)
                
                for (column, number) in numbers.enumerated() {
                    let position = Position(row: row, column: column)
                    result[position] = number
                }
            })
        self.numbersByPosition = numbersByPosition
    }
}
