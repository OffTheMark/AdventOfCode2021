//
//  main.swift
//  Day1
//
//  Created by Marc-Antoine Malépart on 2021-11-22.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day1: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        // TODO: Complete day 1 part 1
    }
}

Day1.main()
