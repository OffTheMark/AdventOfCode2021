//
//  Grid.swift
//  Day9
//
//  Created by Marc-Antoine Malépart on 2021-12-09.
//

import Foundation

struct Grid {
    let elevationByPoint: [Point: Int]
    let size: Size
    
    subscript(point: Point) -> Int? {
        elevationByPoint[point]
    }
    
    func lowPoints() -> Set<Point> {
        elevationByPoint.reduce(into: Set<Point>(), { result, pair in
            let (point, height) = pair
            let isLowPoint = point.adjacentPoints.allSatisfy({ adjacentPoint in
                guard let adjacentHeight = self[adjacentPoint] else {
                    return true
                }
                
                return height < adjacentHeight
            })
            
            if isLowPoint {
                result.insert(point)
            }
        })
    }
}

typealias Basin = Set<Point>

extension Grid {
    init(rawValue: String) {
        var elevationByPoint = [Point: Int]()
        let lines = rawValue.components(separatedBy: .newlines)
        var size = Size(width: 0, height: lines.count)
        
        for (y, line) in lines.enumerated() {
            size.width = line.count
            
            for (x, character) in line.enumerated() {
                let point = Point(x: x, y: y)
                let elevation = Int(String(character))!
                
                elevationByPoint[point] = elevation
            }
        }
        
        self.elevationByPoint = elevationByPoint
        self.size = size
    }
}

struct Size {
    var width: Int
    var height: Int
}

extension Size: Equatable {}

struct Point {
    var x: Int
    var y: Int
    
    var adjacentPoints: [Point] {
        Move.adjacentMoves.map({ self + $0 })
    }
}

extension Point: Hashable {}

extension Point {
    static func + (lhs: Point, rhs: Move) -> Point {
        Self(
            x: lhs.x + rhs.deltaX,
            y: lhs.y + rhs.deltaY
        )
    }
}

struct Move {
    let deltaX: Int
    let deltaY: Int
    
    static let top = Move(deltaX: 0, deltaY: -1)
    static let right = Move(deltaX: 1, deltaY: 0)
    static let bottom = Move(deltaX: 0, deltaY: 1)
    static let left = Move(deltaX: -1, deltaY: 0)
    
    static let adjacentMoves: [Move] = [.top, .right, .bottom, .left]
}

extension Move: Equatable {}
