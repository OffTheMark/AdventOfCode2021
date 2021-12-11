//
//  main.swift
//  Day11
//
//  Created by Marc-Antoine Malépart on 2021-12-11.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day11: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let grid = Grid(rawValue: try readFile())
        
        let totalFlashes = part1(grid: grid)
        printTitle("Part 1", level: .title1)
        print("Total flashes after 100 steps:", totalFlashes, terminator: "\n\n")
        
        let firstStepWhereAllOctopusesFlash = part2(grid: grid)
        printTitle("Part 2", level: .title1)
        print("First step where all octopuses flash:", firstStepWhereAllOctopusesFlash)
    }
    
    func part1(grid: Grid) -> Int {
        var grid = grid
        let steps = 1 ... 100
        
        return steps.reduce(into: 0, { total, _ in
            total += grid.iterate()
        })
    }
    
    func part2(grid: Grid) -> Int {
        var grid = grid
        let steps = 1...
        
        return steps.first(where: { _ in
            let numberOfFlashes = grid.iterate()
            return numberOfFlashes == 100
        })!
    }
}

Day11.main()
