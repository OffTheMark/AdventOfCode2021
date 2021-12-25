//
//  main.swift
//  Day25
//
//  Created by Marc-Antoine Malépart on 2021-12-25.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day25: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let grid = Grid(rawValue: try readFile())
        
        printTitle("Part 1", level: .title1)
        let result = part1(grid: grid)
        print("First step on which no sea cucumbers move:", result.numberOfSteps, terminator: "\n\n")
        print(result.grid)
    }
    
    func part1(grid: Grid) -> (numberOfSteps: Int, grid: Grid) {
        let steps = 1...
        var grid = grid
        
        let numberOfSteps = steps.first(where: { _ in
            let movesForEastFacing = grid.movesForEastFacingCucumbers()
            grid.apply(movesForEastFacing)
            
            let movesForSouthFacing = grid.movesForSouthFacingCucumbers()
            grid.apply(movesForSouthFacing)
            
            return movesForEastFacing.isEmpty && movesForSouthFacing.isEmpty
        })!
        
        return (numberOfSteps, grid)
    }
}

Day25.main()
