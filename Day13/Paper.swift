//
//  Paper.swift
//  Day13
//
//  Created by Marc-Antoine Malépart on 2021-12-13.
//

import Foundation

struct Paper {
    private(set) var points: Set<Point>
    
    mutating func apply(_ fold: Fold) {
        let coordinatePath: WritableKeyPath<Point, Int>
        let value: Int
        switch fold {
        case .alongX(let x):
            coordinatePath = \.x
            value = x
        
        case .alongY(let y):
            coordinatePath = \.y
            value = y
        }
        
        let foldingPoints = points.filter({ $0[keyPath: coordinatePath] > value })
        for var foldingPoint in foldingPoints {
            points.remove(foldingPoint)
            foldingPoint[keyPath: coordinatePath] = value - (foldingPoint[keyPath: coordinatePath] - value)
            points.insert(foldingPoint)
        }
    }
}

extension Paper: CustomStringConvertible {
    var description: String {
        var bottomRightCorner: Point = .zero
        for point in points {
            bottomRightCorner.x = max(bottomRightCorner.x, point.x)
            bottomRightCorner.y = max(bottomRightCorner.y, point.y)
        }
        
        let lines: [String] = (0 ... bottomRightCorner.y).map({ y in
            let line = String(
                (0 ... bottomRightCorner.x).map({ x -> Character in
                    let point = Point(x: x, y: y)
                    
                    if points.contains(point) {
                        return "#"
                    }
                    else {
                        return " "
                    }
                })
            )
            return line
        })
        return lines.joined(separator: "\n")
    }
}

extension Paper {
    init(rawValue: String) {
        let points = rawValue
            .components(separatedBy: .newlines)
            .compactMap(Point.init)
        
        self.points = Set(points)
    }
}

struct Point {
    var x: Int
    var y: Int
    
    static let zero = Point(x: 0, y: 0)
}

extension Point {
    init?(rawValue: String) {
        let parts = rawValue
            .components(separatedBy: ",")
            .compactMap(Int.init)
        
        guard parts.count == 2 else {
            return nil
        }
        
        self.x = parts[0]
        self.y = parts[1]
    }
}

extension Point: Hashable {}

enum Fold {
    case alongX(Int)
    case alongY(Int)
}

extension Fold {
    init?(rawValue: String) {
        let rawValue = rawValue.removingPrefix("fold along ")
        let parts = rawValue.components(separatedBy: "=")
        
        guard parts.count == 2 else {
            return nil
        }
        
        guard let value = Int(parts[1]) else {
            return nil
        }
        
        switch parts[0] {
        case "x":
            self = .alongX(value)
            
        case "y":
            self = .alongY(value)
            
        default:
            return nil
        }
    }
}

extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }
        
        return String(dropFirst(prefix.count))
    }
}
