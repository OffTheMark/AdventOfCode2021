//
//  Point.swift
//  Day15
//
//  Created by Marc-Antoine Malépart on 2021-12-15.
//

import Foundation

struct Graph {
    let riskLevelByPoint: [Point: Int]
    let size: Size
    
    var topLeft: Point { .zero }
    var bottomRight: Point { Point(x: size.width - 1, y: size.height - 1) }
}

extension Graph {
    init(rawValue: String) {
        let lines = rawValue.components(separatedBy: .newlines)
        var size = Size(width: 0, height: lines.count)
        
        let riskLevelByPoint: [Point: Int] = lines.enumerated().reduce(into: [:], { result, pair in
            let (y, line) = pair
            
            size.width = max(size.width, line.count)
            
            for (x, character) in line.enumerated() {
                guard let riskLevel = Int(String(character)) else {
                    continue
                }
                
                let point = Point(x: x, y: y)
                result[point] = riskLevel
            }
        })
        
        self.riskLevelByPoint = riskLevelByPoint
        self.size = size
    }
}

struct Path {
    let destination: Point
    let riskLevel: Int
}

struct Point {
    var x: Int
    var y: Int
    
    static let zero = Point(x: 0, y: 0)
    
    var neighbors: [Point] {
        let moves: [Move] = [.left, .top, .right, .bottom]
        return moves.map({ self + $0 })
    }
}

extension Point: Hashable {}

extension Point {
    static func + (lhs: Point, rhs: Move) -> Point {
        Point(
            x: lhs.x + rhs.deltaX,
            y: lhs.y + rhs.deltaY
        )
    }
}

struct Size {
    var width: Int
    var height: Int
}

struct Move {
    var deltaX: Int
    var deltaY: Int
    
    static let left = Move(deltaX: -1, deltaY: 0)
    static let top = Move(deltaX: 0, deltaY: -1)
    static let right = Move(deltaX: 1, deltaY: 0)
    static let bottom = Move(deltaX: 0, deltaY: 1)
}
