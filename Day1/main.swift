//
//  main.swift
//  Day1
//
//  Created by Marc-Antoine Malépart on 2021-11-22.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day1: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let measurements = try readLines().compactMap(Int.init)
        
        let numberOfIncreases = part1(with: measurements)
        printTitle("Part 1", level: .title1)
        print("Number of increases:", numberOfIncreases, terminator: "\n\n")
        
        let numberOfWindowIncreases = part2(with: measurements)
        printTitle("Part 2", level: .title1)
        print("Number of increases:", numberOfWindowIncreases)
    }
    
    func part1(with measurements: [Int]) -> Int {
        let numberOfIncreases = measurements.windows(ofCount: 2)
            .reduce(into: 0, { result, window in
                let window = Array(window)
                if window[1] > window[0] {
                    result += 1
                }
            })
        
        return numberOfIncreases
    }
    
    func part2(with measurements: [Int]) -> Int {
        let windowsOfSize3 = measurements.windows(ofCount: 3)
        let numberOfIncreases = windowsOfSize3.windows(ofCount: 2)
            .reduce(into: 0, { result, pair in
                let pair = Array(pair)
                let leftSum = pair[0].reduce(0, +)
                let rightSum = pair[1].reduce(0, +)
                
                if rightSum > leftSum {
                    result += 1
                }
            })
        return numberOfIncreases
    }
}

Day1.main()
