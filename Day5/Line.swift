//
//  Line.swift
//  Day5
//
//  Created by Marc-Antoine Malépart on 2021-12-05.
//

import Foundation
import Algorithms

struct Line {
    let start: Point
    let end: Point
    
    var isVertical: Bool { start.x == end.x }
    var isHorizontal: Bool { start.y == end.y }
    
    var points: [Point] {
        let length = max(abs(start.x - end.x), abs(start.y - end.y))
        let slope = Point(
            x: (end.x - start.x).signum(),
            y: (end.y - start.y).signum()
        )
        
        return (0...length).map({ $0 * slope + start })
    }
}

extension Line {
    init?(rawValue: String) {
        let points = rawValue.components(separatedBy: " -> ").compactMap(Point.init)
        
        guard points.count == 2 else {
            return nil
        }
        
        self.start = points[0]
        self.end = points[1]
    }
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

extension Point {
    init?(rawValue: String) {
        let coordinates = rawValue.components(separatedBy: ",").compactMap(Int.init)
        
        guard coordinates.count == 2 else {
            return nil
        }
        
        self.x = coordinates[0]
        self.y = coordinates[1]
    }
}

extension Point {
    static func + (lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func * (lhs: Int, rhs: Point) -> Point {
        Point(x: lhs * rhs.x, y: lhs * rhs.y)
    }
}
