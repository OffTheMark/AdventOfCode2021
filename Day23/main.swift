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
        let fingerprint = Fingerprint(rawValue: try readFile())
        
        printTitle("Part 1", level: .title1)
        let leastEnergyToOrganizeAmphipods = part1(fingerprint: fingerprint)
        print(
            "Least energy required to organize the amphipods:",
            leastEnergyToOrganizeAmphipods,
            terminator: "\n\n"
        )
    }
    
    func part1(fingerprint: Fingerprint) -> Int {
        let result = dijkstra(fingerprint: fingerprint)
        
        var current = WeightedFingerprint(fingerprint: fingerprint, moves: [], cost: 0)
        print(current.fingerprint, terminator: "\n\n")
        
        for move in result.moves {
            current = current.applying(move)
            print(current.fingerprint, terminator: "\n\n")
        }
        
        return result.cost
    }
    
    func dijkstra(fingerprint: Fingerprint) -> WeightedFingerprint {
        let initial = WeightedFingerprint(
            fingerprint: fingerprint,
            moves: [],
            cost: 0
        )
        var frontier = Heap<WeightedFingerprint>(
            array: [initial],
            sort: { $0.cost < $1.cost }
        )
        var visited = Set<Fingerprint>()
        var minimumCostByFingerprint = [initial.fingerprint: initial.cost]
        
        while let leastCostlyFingerprint = frontier.remove() {
            if leastCostlyFingerprint.fingerprint == Fingerprint.target {
                return leastCostlyFingerprint
            }
            
            visited.insert(leastCostlyFingerprint.fingerprint)
            
            for path in leastCostlyFingerprint.fingerprint.possiblePaths() {
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
    let moves: [Path]
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
            moves: moves + [path],
            cost: newCost
        )
    }
}

Day23.main()
