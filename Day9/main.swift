//
//  main.swift
//  Day9
//
//  Created by Marc-Antoine Malépart on 2021-12-09.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day9: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let grid = Grid(rawValue: try readFile())
        
        let riskLevelSum = part1(grid: grid)
        printTitle("Part 1", level: .title1)
        print("Sum of risk level for low points:", riskLevelSum, terminator: "\n\n")
        
        let productOfSizeOfLargestBasins = part2(grid: grid)
        printTitle("Part 2", level: .title1)
        print("Product of the size of the largest basins:", productOfSizeOfLargestBasins)
    }
    
    func part1(grid: Grid) -> Int {
        return grid.lowPoints().reduce(into: 0, { sum, point in
            guard let height = grid[point] else {
                return
            }
            
            let riskLevel = height + 1
            sum += riskLevel
        })
    }
    
    func part2(grid: Grid) -> Int {
        let lowPoints = grid.lowPoints()
        
        let basins: [Basin] = lowPoints.map({ lowPoint in
            var basin: Basin = [lowPoint]
            
            func isValidToExplore(_ point: Point) -> Bool {
                if basin.contains(point) {
                    return false
                }
                
                switch grid[point] {
                case nil:
                    return false
                    
                case let height? where height >= 9:
                    return false
                    
                default:
                    return true
                }
            }
            
            var currentlyVisiting: Set<Point> = [lowPoint]
            var nextAdjacentPoints: Set<Point>
            repeat {
                nextAdjacentPoints = currentlyVisiting
                    .reduce(into: Set(), { result, point in
                        let nextAdjacentPointsForPoint = point.adjacentPoints.filter({ adjacentPoint in
                            guard isValidToExplore(adjacentPoint) else {
                                return false
                            }
                            
                            return grid[adjacentPoint]! > grid[point]!
                        })
                        result.formUnion(nextAdjacentPointsForPoint)
                    })
                
                basin.formUnion(nextAdjacentPoints)
                currentlyVisiting = nextAdjacentPoints
            }
            while !nextAdjacentPoints.isEmpty
            
            return basin
        })
        
        return basins
            .max(count: 3, sortedBy: { $0.count < $1.count })
            .reduce(1, { product, basin in
                product * basin.count
            })
    }
}

Day9.main()
