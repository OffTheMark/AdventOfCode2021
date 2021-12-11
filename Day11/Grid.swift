//
//  Grid.swift
//  Day11
//
//  Created by Marc-Antoine Malépart on 2021-12-11.
//

import Foundation

struct Grid {
    private(set) var energyLevelByPoint: [Point: Int]
    
    mutating func iterate() -> Int {
        var flashingPoints = Set<Point>()
        
        for point in energyLevelByPoint.keys {
            energyLevelByPoint[point, default: 0] += 1
        }
        
        var currentlyFlashing: Set<Point>
        repeat {
            currentlyFlashing = Set(
                energyLevelByPoint.keys.filter({ point in
                    if flashingPoints.contains(point) {
                        return false
                    }
                    
                    let level = energyLevelByPoint[point]!
                    return level > 9
                })
            )
            
            for flashingPoint in currentlyFlashing {
                for adjacentPoint in flashingPoint.adjacentPoints where energyLevelByPoint[adjacentPoint] != nil {
                    energyLevelByPoint[adjacentPoint, default: 0] += 1
                }
            }
            
            flashingPoints.formUnion(currentlyFlashing)
        }
        while !currentlyFlashing.isEmpty
                
        for point in flashingPoints {
            energyLevelByPoint[point] = 0
        }
                
        return flashingPoints.count
    }
}

extension Grid {
    init(rawValue: String) {
        var energyLevelByPoint = [Point: Int]()
        let lines = rawValue.components(separatedBy: .newlines)
        
        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                let point = Point(x: x, y: y)
                let elevation = Int(String(character))!
                
                energyLevelByPoint[point] = elevation
            }
        }
        
        self.energyLevelByPoint = energyLevelByPoint
    }
}

struct Size {
    var width: Int
    var height: Int
}

struct Point {
    var x: Int
    var y: Int
    
    var adjacentPoints: [Point] { Move.adjacentMoves.map({ self + $0 }) }
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

struct Move {
    var deltaX: Int
    var deltaY: Int
    
    static let topLeft = Move(deltaX: -1, deltaY: -1)
    static let top = Move(deltaX: 0, deltaY: -1)
    static let topRight = Move(deltaX: 1, deltaY: -1)
    static let right = Move(deltaX: 1, deltaY: 0)
    static let bottomRight = Move(deltaX: 1, deltaY: 1)
    static let bottom = Move(deltaX: 0, deltaY: 1)
    static let bottomLeft = Move(deltaX: -1, deltaY: 1)
    static let left = Move(deltaX: -1, deltaY: 0)
    
    static let adjacentMoves: [Move] = [.topLeft, .top, .topRight, .right, .bottomRight, .bottom, .bottomLeft, .left]
}
