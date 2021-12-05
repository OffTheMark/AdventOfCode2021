//
//  main.swift
//  Day5
//
//  Created by Marc-Antoine Malépart on 2021-12-05.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day5: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines().compactMap(Line.init)
        
        printTitle("Part 1", level: .title1)
        let numberOfIntersectingPointsForPart1 = part1(with: lines)
        print("Number of intersecting points:", numberOfIntersectingPointsForPart1, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let numberOfIntersectingPointsForPart2 = part2(with: lines)
        print("Number of intersecting points:", numberOfIntersectingPointsForPart2)
    }
    
    func part1(with lines: [Line]) -> Int {
        let countByPoint: [Point: Int] = lines.reduce(into: [:], { result, line in
            guard line.isVertical || line.isHorizontal else {
                return
            }
            
            for point in line.points {
                result[point, default: 0] += 1
            }
        })
        
        return countByPoint.count(where: { $0.value >= 2 })
    }
    
    func part2(with lines: [Line]) -> Int {
        let countByPoint: [Point: Int] = lines.reduce(into: [:], { result, line in
            for point in line.points {
                result[point, default: 0] += 1
            }
        })
        
        return countByPoint.count(where: { $0.value >= 2 })
    }
}

Day5.main()
