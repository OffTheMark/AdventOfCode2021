//
//  Area.swift
//  Day17
//
//  Created by Marc-Antoine Malépart on 2021-12-17.
//

import Foundation

struct Area {
    let xRange: ClosedRange<Int>
    let yRange: ClosedRange<Int>
    
    func contains(_ point: Point) -> Bool {
        xRange.contains(point.x) && yRange.contains(point.y)
    }
    
    func hasMissed(_ point: Point) -> Bool {
        point.x > xRange.upperBound || point.y < yRange.lowerBound
    }
}

extension Area {
    init?(rawValue: String) {
        let parts = rawValue.removingPrefix("target area: ")
            .components(separatedBy: ", ")
        
        guard parts.count == 2 else {
            return nil
        }
        
        let xBounds = parts[0].removingPrefix("x=")
            .components(separatedBy: "..")
            .compactMap(Int.init)
        
        guard xBounds.count == 2 else {
            return nil
        }
        
        let yBounds = parts[1].removingPrefix("y=")
            .components(separatedBy: "..")
            .compactMap(Int.init)
        
        guard yBounds.count == 2 else {
            return nil
        }
        
        self.xRange = xBounds[0] ... xBounds[1]
        self.yRange = yBounds[0] ... yBounds[1]
    }
}

struct Point {
    var x: Int
    var y: Int
    
    static let zero = Point(x: 0, y: 0)
}

struct Velocity {
    var x: Int
    var y: Int
}

extension Velocity: Hashable {}

extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }
        
        return String(dropFirst(prefix.count))
    }
}
