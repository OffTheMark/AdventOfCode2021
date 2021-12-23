//
//  main.swift
//  Day23
//
//  Created by Marc-Antoine Malépart on 2021-12-23.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day23: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let rawValue = try readFile()
        
        printTitle("Part 1", level: .title1)
        let leastEnergyToOrganizeAmphipods = part1(rawValue: rawValue)
        print(
            "Least energy required to organize the amphipods:",
            leastEnergyToOrganizeAmphipods,
            terminator: "\n\n"
        )
        
        printTitle("Part 2", level: .title1)
        let leastEnergyToOrganizeAmphipodsFromFullDiagram = part2(rawValue: rawValue)
        print(
            "Least energy required to organize the amphipods from the full diagram:",
            leastEnergyToOrganizeAmphipodsFromFullDiagram
        )
    }
    
    func part1(rawValue: String) -> Int {
        let fingerprint = Fingerprint(rawValue: rawValue)
        let graph = Graph(heightOfSideRooms: 2)
        let result = dijkstra(fingerprint: fingerprint, graph: graph)
        
        return result.cost
    }
    
    func part2(rawValue: String) -> Int {
        var lines = rawValue.components(separatedBy: .newlines)
        lines.insert("  #D#C#B#A#  ", at: 3)
        lines.insert("  #D#B#A#C#  ", at: 4)
        let rawValue = lines.joined(separator: "\n")
        
        let fingerprint = Fingerprint(rawValue: rawValue)
        let graph = Graph(heightOfSideRooms: 4)
        
        let result = dijkstra(fingerprint: fingerprint, graph: graph)
        return result.cost
    }
    
    func dijkstra(fingerprint: Fingerprint, graph: Graph) -> WeightedFingerprint {
        let target = Fingerprint.target(ofHeight: graph.heightOfSideRooms)
        
        let initial = WeightedFingerprint(
            fingerprint: fingerprint,
            cost: 0
        )
        var frontier = Heap<WeightedFingerprint>(
            array: [initial],
            sort: { $0.cost < $1.cost }
        )
        var visited = Set<Fingerprint>()
        var minimumCostByFingerprint = [initial.fingerprint: initial.cost]
        
        while let leastCostlyFingerprint = frontier.remove() {
            if leastCostlyFingerprint.fingerprint == target {
                return leastCostlyFingerprint
            }
            
            visited.insert(leastCostlyFingerprint.fingerprint)
            
            for path in leastCostlyFingerprint.fingerprint.possiblePaths(using: graph) {
                let newFingerprint = leastCostlyFingerprint.applying(path)
                
                if visited.contains(newFingerprint.fingerprint) {
                    continue
                }
                
                if newFingerprint.cost < minimumCostByFingerprint[newFingerprint.fingerprint, default: Int.max] {
                    minimumCostByFingerprint[newFingerprint.fingerprint] = newFingerprint.cost
                    
                    frontier.insert(newFingerprint)
                }
            }
        }
        
        fatalError("Could not find result")
    }
}

struct WeightedFingerprint {
    let fingerprint: Fingerprint
    let cost: Int
    
    func applying(_ path: Path) -> WeightedFingerprint {
        var newFingerprint = fingerprint
        var newCost = cost
        
        if let removed = newFingerprint.amphipodsByPosition.removeValue(forKey: path.start) {
            newFingerprint.amphipodsByPosition[path.end] = removed
            newCost += path.distance * removed.requiredEnergy
        }
        
        return WeightedFingerprint(
            fingerprint: newFingerprint,
            cost: newCost
        )
    }
}

Day23.main()
