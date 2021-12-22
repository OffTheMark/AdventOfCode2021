//
//  Cuboid.swift
//  Day22
//
//  Created by Marc-Antoine Malépart on 2021-12-22.
//

import Foundation
import Algorithms

enum CubeState: String {
    case on
    case off
}

struct RebootStep {
    let state: CubeState
    let cuboid: Cuboid
}

extension RebootStep {
    init?(rawValue: String) {
        let components = rawValue.components(separatedBy: " ")
        
        guard components.count == 2 else {
            return nil
        }
        
        guard let state = CubeState(rawValue: components[0]) else {
            return nil
        }
        
        guard let cuboid = Cuboid(rawValue: components[1]) else {
            return nil
        }
        
        self.state = state
        self.cuboid = cuboid
    }
}

struct Cuboid {
    let rangeOfX: ClosedRange<Int>
    let rangeOfY: ClosedRange<Int>
    let rangeOfZ: ClosedRange<Int>
    
    var cubeCount: Int {
        let keyPaths: [KeyPath<Cuboid, ClosedRange<Int>>] = [\.rangeOfX, \.rangeOfY, \.rangeOfZ]
        
        return keyPaths.reduce(into: 1, { result, keyPath in
            result *= self[keyPath: keyPath].count
        })
    }
    
    var points: [Point3D] {
        var points = [Point3D]()
        
        for x in rangeOfX {
            for y in rangeOfY {
                for z in rangeOfZ {
                    let point = Point3D(x: x, y: y, z: z)
                    points.append(point)
                }
            }
        }
        
        return points
    }
    
    func fullyContains(_ other: Cuboid) -> Bool {
        let keyPaths: [KeyPath<Cuboid, ClosedRange<Int>>] = [\.rangeOfX, \.rangeOfY, \.rangeOfZ]
        
        return keyPaths.allSatisfy({ self[keyPath: $0].fullyContains(other[keyPath: $0]) })
    }
    
    func intersection(_ other: Cuboid) -> Cuboid? {
        guard overlaps(other) else {
            return nil
        }
        
        let newRangeOfX = max(rangeOfX.lowerBound, other.rangeOfX.lowerBound) ... min(rangeOfX.upperBound, other.rangeOfX.upperBound)
        let newRangeOfY = max(rangeOfY.lowerBound, other.rangeOfY.lowerBound) ... min(rangeOfY.upperBound, other.rangeOfY.upperBound)
        let newRangeOfZ = max(rangeOfZ.lowerBound, other.rangeOfZ.lowerBound) ... min(rangeOfZ.upperBound, other.rangeOfZ.upperBound)
        
        return Cuboid(
            rangeOfX: newRangeOfX,
            rangeOfY: newRangeOfY,
            rangeOfZ: newRangeOfZ
        )
    }
    
    func overlaps(_ other: Cuboid) -> Bool {
        let keyPaths: [KeyPath<Cuboid, ClosedRange<Int>>] = [\.rangeOfX, \.rangeOfY, \.rangeOfZ]
        
        return keyPaths.allSatisfy({ self[keyPath: $0].overlaps(other[keyPath: $0]) })
    }
}

extension Cuboid: Hashable {}

extension Cuboid {
    init?(rawValue: String) {
        let components = rawValue.components(separatedBy: ",")
        
        guard components.count == 3 else {
            return nil
        }
        
        guard let rangeOfX = ClosedRange<Int>(rawValue: components[0].removingPrefix("x=")) else {
            return nil
        }
        
        guard let rangeOfY = ClosedRange<Int>(rawValue: components[1].removingPrefix("y=")) else {
            return nil
        }
        
        guard let rangeOfZ = ClosedRange<Int>(rawValue: components[2].removingPrefix("z=")) else {
            return nil
        }
        
        self.rangeOfX = rangeOfX
        self.rangeOfY = rangeOfY
        self.rangeOfZ = rangeOfZ
    }
}

extension ClosedRange where Element == Int {
    init?(rawValue: String) {
        let components = rawValue.components(separatedBy: "..").compactMap(Int.init)
        
        guard components.count == 2 else {
            return nil
        }
        
        self = components[0] ... components[1]
    }
    
    func fullyContains(_ other: ClosedRange<Int>) -> Bool {
        other.lowerBound >= lowerBound && other.upperBound <= upperBound
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

struct Point3D {
    var x: Int
    var y: Int
    var z: Int
}

extension Point3D: Hashable {}
