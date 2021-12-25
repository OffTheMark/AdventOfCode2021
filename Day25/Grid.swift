//
//  Grid.swift
//  Day25
//
//  Created by Marc-Antoine Malépart on 2021-12-25.
//

import Foundation

struct Grid {
    private(set) var cucumbersByPoint: [Point: SeaCucumber]
    let size: Size
    
    func movesForEastFacingCucumbers() -> Set<Move> {
        Set(
            cucumbersByPoint.compactMap({ point, cucumber -> Move? in
                guard cucumber == .east else {
                    return nil
                }
                
                var end = point
                end.x += 1
                if end.x >= size.width {
                    end.x = 0
                }
                
                guard cucumbersByPoint[end] == nil else {
                    return nil
                }
                
                return Move(start: point, end: end)
            })
        )
    }
    
    func movesForSouthFacingCucumbers() -> Set<Move> {
        Set(
            cucumbersByPoint.compactMap({ point, cucumber -> Move? in
                guard cucumber == .south else {
                    return nil
                }
                
                var end = point
                end.y += 1
                if end.y >= size.height {
                    end.y = 0
                }
                
                guard cucumbersByPoint[end] == nil else {
                    return nil
                }
                
                return Move(start: point, end: end)
            })
        )
    }
    
    mutating func apply(_ moves: Set<Move>) {
        for move in moves {
            guard let cucumber = cucumbersByPoint[move.start] else {
                continue
            }
            
            cucumbersByPoint.removeValue(forKey: move.start)
            cucumbersByPoint[move.end] = cucumber
        }
    }
}

extension Grid {
    init(rawValue: String) {
        let lines = rawValue.components(separatedBy: .newlines)
        var size = Size(width: 0, height: lines.count)
        
        let cucumbersByPoint: [Point: SeaCucumber] = lines.enumerated().reduce(into: [:], { result, element in
            let (y, line) = element
            
            size.width = max(size.width, line.count)
            
            for (x, character) in line.enumerated() {
                guard let seaCucumber = SeaCucumber(rawValue: character) else {
                    continue
                }
                
                let point = Point(x: x, y: y)
                result[point] = seaCucumber
            }
        })
        self.cucumbersByPoint = cucumbersByPoint
        self.size = size
    }
}

extension Grid: CustomStringConvertible {
    var description: String {
        let rangeOfX = 0 ..< size.width
        let rangeOfY = 0 ..< size.height
        
        let lines: [String] = rangeOfY.map({ y in
            let line = String(rangeOfX.map({ x -> Character in
                let point = Point(x: x, y: y)
                
                if let cucumber = cucumbersByPoint[point] {
                    return cucumber.rawValue
                }
                else {
                    return "."
                }
            }))
            return line
        })
        return lines.joined(separator: "\n")
    }
}

enum SeaCucumber: Character {
    case east = ">"
    case south = "v"
}

struct Size {
    var width: Int
    var height: Int
}

struct Point {
    var x: Int
    var y: Int
}

extension Point: Hashable {}

struct Move {
    let start: Point
    let end: Point
}

extension Move: Hashable {}
