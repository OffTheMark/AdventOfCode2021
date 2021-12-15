//
//  main.swift
//  Day15
//
//  Created by Marc-Antoine Malépart on 2021-12-15.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day15: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let graph = Graph(rawValue: try readFile())
        
        let shortestPath = part1(graph: graph)
        printTitle("Part 1", level: .title1)
        print("Total risk level of shortest path:", shortestPath.riskLevel, terminator: "\n\n")
        
        let shortestPathInBiggerGraph = part2(graph: graph)
        printTitle("Part 2", level: .title1)
        print("Total risk level of shortest path in bigger graph:", shortestPathInBiggerGraph.riskLevel)
    }
    
    func part1(graph: Graph) -> Path {
        dijkstra(graph: graph)
    }
    
    func part2(graph: Graph) -> Path {
        var biggerRiskLevelByPoint = [Point: Int]()
        for (row, column) in product(0 ..< 5, 0 ..< 5) {
            for (point, value) in graph.riskLevelByPoint {
                var newPoint = point
                newPoint.x += graph.size.width * column
                newPoint.y += graph.size.height * row
                
                var newValue = value
                newValue += row + column
                if newValue >= 10 {
                    newValue = newValue % 9
                }
                
                biggerRiskLevelByPoint[newPoint] = newValue
            }
        }
        
        var biggerSize = graph.size
        biggerSize.width *= 5
        biggerSize.height *= 5
        
        let biggerGraph = Graph(riskLevelByPoint: biggerRiskLevelByPoint, size: biggerSize)
        return dijkstra(graph: biggerGraph)
    }
    
    func dijkstra(graph: Graph) -> Path {
        var frontier = Heap<Path>(
            array: [Path(destination: graph.topLeft, riskLevel: 0)],
            sort: { $0.riskLevel < $1.riskLevel }
        )
        var visited = Set<Point>()
        var minimumRiskLevelByPoint = [graph.topLeft: 0]
        
        while let shortestPath = frontier.remove() {
            if shortestPath.destination == graph.bottomRight {
                return shortestPath
            }
            
            visited.insert(shortestPath.destination)
            
            for neighbor in shortestPath.destination.neighbors {
                if visited.contains(neighbor) || !graph.riskLevelByPoint.keys.contains(neighbor) {
                    continue
                }
                
                let newRisk = shortestPath.riskLevel + graph.riskLevelByPoint[neighbor, default: 0]
                
                if newRisk < minimumRiskLevelByPoint[neighbor, default: Int.max] {
                    minimumRiskLevelByPoint[neighbor] = newRisk
                    
                    let path = Path(destination: neighbor,riskLevel: newRisk)
                    frontier.insert(path)
                }
            }
        }
        
        fatalError("Could not find shortest path")
    }
}

Day15.main()
