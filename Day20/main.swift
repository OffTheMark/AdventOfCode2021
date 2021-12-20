//
//  main.swift
//  Day20
//
//  Created by Marc-Antoine Malépart on 2021-12-20.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day20: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let parts = try readFile().components(separatedBy: "\n\n")
        let enhancement = Enhancement(rawValue: parts[0])
        let grid = Grid(rawValue: parts[1])
        
        printTitle("Part 1", level: .title1)
        let gridEnhancedTwice = part1(grid: grid, enhancement: enhancement)
        print("Number of lit pixels after 2 enhancements:", gridEnhancedTwice.numberOfLitPixels(), terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let gridEnhanced50Times = part2(grid: grid, enhancement: enhancement)
        print("Number of lit pixels after 50 enhancements:", gridEnhanced50Times.numberOfLitPixels())
    }
    
    func part1(grid: Grid, enhancement: Enhancement) -> Grid {
        var grid = grid
        for _ in 0 ..< 2 {
            grid.enhance(using: enhancement)
        }
        
        return grid
    }
    
    func part2(grid: Grid, enhancement: Enhancement) -> Grid {
        var grid = grid
        for step in 0 ..< 50 {
            grid.enhance(using: enhancement)
        }
        
        return grid
    }
}

Day20.main()
