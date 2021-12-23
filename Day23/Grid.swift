//
//  Grid.swift
//  Day23
//
//  Created by Marc-Antoine Malépart on 2021-12-23.
//

import Foundation
import Algorithms

// MARK: Fingerprint

struct Fingerprint {
    var amphipodsByPosition: [Point: Amphipod]
    
    static let target: Fingerprint = {
        let amphipodsByPosition: [Point: Amphipod] = Amphipod.allCases
            .reduce(into: [:], { result, amphipod in
                for sideRoom in amphipod.sideRooms {
                    result[sideRoom] = amphipod
                }
            })
        
        return Fingerprint(amphipodsByPosition: amphipodsByPosition)
    }()
    
    func isValid(_ path: Path) -> Bool {
        let pointsOfPathExceptStart = path.points().subtracting([path.start])
        
        return pointsOfPathExceptStart.allSatisfy({ amphipodsByPosition[$0] == nil })
    }
    
    func possiblePaths() -> [Path] {
        return amphipodsByPosition.reduce(into: [], { result, pair in
            let (start, amphipod) = pair
            
            if amphipod.sideRooms.contains(start) {
                if start.y == 3 {
                    return
                }
                
                var pointUnderStart = start
                pointUnderStart.y += 1
                let whatsUnder = amphipodsByPosition[pointUnderStart]
                
                if whatsUnder == amphipod {
                    return
                }
            }
            
            let validPaths = paths(for: amphipod, startingAt: start)
                .filter({ isValid($0) })
            result.append(contentsOf: validPaths)
        })
    }
    
    private func paths(for amphipod: Amphipod, startingAt start: Point) -> [Path] {
        if Graph.sideRooms.contains(start) {
            return Graph.pathsToHallwayStopsByStart[start, default: []]
        }
        
        if Graph.hallwayStops.contains(start) {
            let sideRoomsForAmphipod = amphipod.sideRooms
            let pathsToSideRooms = Graph.pathsToSideRoomsByStart[start, default: []]
            
            return pathsToSideRooms.filter({ path in
                guard sideRoomsForAmphipod.contains(path.end) else {
                    return false
                }
                
                if path.end.y == 2 {
                    var pointUnderEnd = path.end
                    pointUnderEnd.y += 1
                    
                    return amphipodsByPosition[pointUnderEnd] == amphipod
                }
                
                return true
            })
        }
        
        return []
    }
}

extension Fingerprint {
    init(rawValue: String) {
        let amphipodsByPosition: [Point: Amphipod] = rawValue.components(separatedBy: .newlines).enumerated()
            .reduce(into: [:], { result, pair in
                let (y, line) = pair
                
                for (x, character) in line.enumerated() {
                    guard let amphipod = Amphipod(rawValue: character) else {
                        continue
                    }
                    
                    let point = Point(x: x, y: y)
                    result[point] = amphipod
                }
            })
        self.amphipodsByPosition = amphipodsByPosition
    }
}

extension Fingerprint: CustomStringConvertible {
    var description: String {
        let rangeOfX = 0 ... 12
        let rangeOfY = 0 ... 4
        
        let lines: [String] = rangeOfY.map({ y in
            let line = String(rangeOfX.map({ x -> Character in
                let point = Point(x: x, y: y)
                
                if let amphipod = amphipodsByPosition[point] {
                    return amphipod.rawValue
                }
                
                if Graph.hallway.contains(point) || Graph.sideRooms.contains(point) {
                    return "."
                }
                
                return "#"
            }))
            return line
        })
        return lines.joined(separator: "\n")
    }
}

extension Fingerprint: Hashable {}

// MARK: - Graph

enum Graph {
    static let sideRoomsByAmphipod: [Amphipod: Set<Point>] = {
        Amphipod.allCases.reduce(into: [:], { result, amphipod in
            result[amphipod] = amphipod.sideRooms
        })
    }()
    
    static let sideRooms: Set<Point> = Set(sideRoomsByAmphipod.values.flatMap({ $0 }))
    
    static let hallwayStops: Set<Point> = {
        let hallwayX = [1, 2, 4, 6, 8, 10, 11]
        return Set(hallwayX.map({ Point(x: $0, y: 1) }))
    }()
    
    static let hallway: Set<Point> = {
        let rangeOfX = 1 ... 11
        return Set(rangeOfX.map({ Point(x: $0, y: 1) }))
    }()
    
    static let pathsToHallwayStopsByStart: [Point: [Path]] = {
        product(sideRooms, hallwayStops).reduce(into: [:], { result, pair in
            let (start, end) = pair
            let path = Path(start: start, end: end)
            result[start, default: []].append(path)
        })
    }()
    
    static let pathsToSideRoomsByStart: [Point: [Path]] = {
        product(hallwayStops, sideRooms).reduce(into: [:], { result, pair in
            let (start, end) = pair
            let path = Path(start: start, end: end)
            result[start, default: []].append(path)
        })
    }()
}

// MARK: - Amphipod

enum Amphipod: Character {
    case amber = "A"
    case bronze = "B"
    case copper = "C"
    case desert = "D"
    
    var sideRooms: Set<Point> {
        let sideRoomRangeOfY = 2 ... 3
        let x = sideRoomX
        
        return Set(sideRoomRangeOfY.map({ Point(x: x, y: $0) }))
    }
    
    private var sideRoomX: Int {
        switch self {
        case .amber:
            return 3
        
        case .bronze:
            return 5
            
        case .copper:
            return 7
            
        case .desert:
            return 9
        }
    }
    
    var requiredEnergy: Int {
        switch self {
        case .amber:
            return 1
            
        case .bronze:
            return 10
            
        case .copper:
            return 100
            
        case .desert:
            return 1_000
        }
    }
}

extension Amphipod: CaseIterable {}

extension Amphipod: Hashable {}

// MARK: - Path

struct Path {
    let start: Point
    let end: Point
    
    private var rangeOfX: ClosedRange<Int> { min(start.x, end.x) ... max(start.x, end.x) }
    private var rangeOfY: ClosedRange<Int> { min(start.y, end.y) ... max(start.y, end.y) }
    
    func points() -> Set<Point> {
        let pointWithGreatestY = [start, end].max(by: { $0.y < $1.y })!
        
        return Set(
            rangeOfX.map({ Point(x: $0, y: rangeOfY.lowerBound) }) +
            rangeOfY.map({ Point(x: pointWithGreatestY.x, y: $0) })
        )
    }
    
    init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }
    
    var distance: Int { rangeOfX.count + rangeOfY.count - 2 }
}

extension Path: Equatable {}

// MARK: - Point

struct Point {
    var x: Int
    var y: Int
}

extension Point: Hashable {}
