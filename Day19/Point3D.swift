//
//  Point3D.swift
//  Day19
//
//  Created by Marc-Antoine Malépart on 2021-12-19.
//

import Foundation
import Algorithms

struct Scanner {
    var beacons: Set<Point3D>
    
    func transformations() -> [Scanner] {
        var result = Array<Scanner>(repeating: Scanner(beacons: []), count: 24)
        
        for beacon in beacons {
            let transformations = beacon.transformations()
            
            for index in transformations.indices {
                result[index].beacons.insert(transformations[index])
            }
        }
        
        return result
    }
    
    func translation(to peer: Scanner) -> Point3D? {
        var countByDifference = [Point3D: Int]()
        
        for (beacon, peerBeacon) in product(beacons, peer.beacons) {
            let difference = beacon - peerBeacon
            countByDifference[difference, default: 0] += 1
        }
        
        return countByDifference.first(where: { $0.value >= 12 })?.key
    }
}

extension Scanner {
    init(rawValue: String) {
        let beaconRawValues = rawValue
            .components(separatedBy: .newlines)
            .dropFirst()
        
        self.beacons = Set(beaconRawValues.compactMap(Point3D.init))
    }
}

struct Point3D {
    var x: Int
    var y: Int
    var z: Int
    
    func rolled() -> Point3D {
        Point3D(x: x, y: z, z: -y)
    }
    
    func turned() -> Point3D {
        Point3D(x: -y, y: x, z: z)
    }
    
    func transformations() -> [Point3D] {
        var result = [Point3D]()
        var current = self
        
        for _ in 0 ..< 2 {
            for _ in 0 ..< 3 {
                current = current.rolled()
                result.append(current)
                
                for _ in 0 ..< 3 {
                    current = current.turned()
                    result.append(current)
                }
            }
            
            current = current.rolled().turned().rolled()
        }
        
        return result
    }
}

extension Point3D {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: ",").compactMap(Int.init)
        
        guard parts.count == 3 else {
            return nil
        }
        
        self.x = parts[0]
        self.y = parts[1]
        self.z = parts[2]
    }
}

extension Point3D: Hashable {}

extension Point3D {
    static prefix func -(point: Point3D) -> Point3D {
        Point3D(x: -point.x, y: -point.y, z: -point.z)
    }
    
    static func -(lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    static func +(lhs: Point3D, rhs: Point3D) -> Point3D {
        Point3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
}
