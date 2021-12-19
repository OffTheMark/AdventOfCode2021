//
//  Point3D.swift
//  Day19
//
//  Created by Marc-Antoine Malépart on 2021-12-19.
//

import Foundation

struct Point3D {
    var x: Double
    var y: Double
    var z: Double
    
    private var rows: [[Double]] {
        [[x], [y], [z], [1]]
    }
    
    static let zero = Point3D(x: 0, y: 0, z: 0)
    
    func applying(_ transform: Transform3D) -> Point3D {
        var result = self
        result.apply(transform)
        return result
    }
    
    mutating func apply(_ transform: Transform3D) {
        let rows = rows
        let indices = 0 ..< 4
        
        let newX: Double = indices.reduce(into: 0, { result, index in
            result += transform.rows[0][index] * rows[index][0]
        })
        let newY: Double = indices.reduce(into: 0, { result, index in
            result += transform.rows[1][index] * rows[index][0]
        })
        let newZ: Double = indices.reduce(into: 0, { result, index in
            result += transform.rows[2][index] * rows[index][0]
        })
        
        self.x = newX
        self.y = newY
        self.z = newZ
    }
}

extension Point3D: Hashable {}

extension Point3D {
    static prefix func -(point: Point3D) -> Point3D {
        Point3D(x: -point.x, y: -point.y, z: -point.z)
    }
}

struct Transform3D {
    var rows: [[Double]]
    
    static let identity = Transform3D(
        rows: [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]
    )
    
    func product(_ other: Transform3D) -> Transform3D {
        func result(row: Int, column: Int) -> Double {
            let indices = 0 ..< 4
            
            return indices.reduce(into: 0, { result, index in
                result += self.rows[row][index] * other.rows[index][column]
            })
        }
        
        let rows = 0 ..< 4
        let columns = 0 ..< 4
        
        return Transform3D(
            rows: rows.map({ row in
                columns.map({ column in
                    result(row: row, column: column)
                })
            })
        )
    }
    
    static func rotationAroundXAxis(by angle: Measurement<UnitAngle>) -> Transform3D {
        let radians = angle.converted(to: .radians)
        let sine = sin(radians.value)
        let cosine = cos(radians.value)
        
        return Transform3D(
            rows: [
                [1, 0, 0, 0],
                [0, cosine, -sine, 0],
                [0, sine, cosine, 0],
                [0, 0, 0, 1]
            ]
        )
    }
    
    static func rotationAroundYAxis(by angle: Measurement<UnitAngle>) -> Transform3D {
        let radians = angle.converted(to: .radians)
        let sine = sin(radians.value)
        let cosine = cos(radians.value)
        
        return Transform3D(
            rows: [
                [cosine, 0, sine, 0],
                [0, 1, 0, 0],
                [-sine, 0, cosine, 0],
                [0, 0, 0, 1]
            ]
        )
    }
    
    static func rotationAroundZAxis(by angle: Measurement<UnitAngle>) -> Transform3D {
        let radians = angle.converted(to: .radians)
        let sine = sin(radians.value)
        let cosine = cos(radians.value)
        
        return Transform3D(
            rows: [
                [cosine, -sine, 0, 0],
                [sine, cosine, 0, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1]
            ]
        )
    }
    
    static func translation(to point: Point3D) -> Transform3D {
        Transform3D(
            rows: [
                [1, 0, 0, point.x],
                [0, 1, 0, point.y],
                [0, 0, 1, point.z],
                [0, 0, 0, 1]
            ]
        )
    }
}
