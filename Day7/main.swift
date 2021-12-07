//
//  main.swift
//  Day7
//
//  Created by Marc-Antoine Malépart on 2021-12-07.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day7: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let positions = try readFile()
            .components(separatedBy: ",")
            .compactMap(Int.init)
        
        let totalFuelCost = part1(positions: positions)
        printTitle("Part 1", level: .title1)
        print("Total fuel cost:", totalFuelCost, terminator: "\n\n")
        
        let gaussFuelCost = part2(positions: positions)
        printTitle("Part 2", level: .title1)
        print("Total fuel cost:", gaussFuelCost)
    }
    
    func part1(positions: [Int]) -> Int {
        let (minimum, maximum) = positions.minAndMax()!
        
        let totalFuelCostByDestination: [Int: Int] = (minimum ... maximum).reduce(into: [:], { result, destination in
            let totalCost = positions.reduce(into: 0, { total, position in
                total += linearCost(start: position, end: destination)
            })
            
            result[destination] = totalCost
        })
        
        return totalFuelCostByDestination.values.min()!
    }
    
    func part2(positions: [Int]) -> Int {
        let (minimum, maximum) = positions.minAndMax()!
        
        let totalFuelCostByDestination: [Int: Int] = (minimum ... maximum).reduce(into: [:], { result, destination in
            let totalCost = positions.reduce(into: 0, { total, position in
                total += gaussSumCost(start: position, end: destination)
            })
            
            result[destination] = totalCost
        })
        
        return totalFuelCostByDestination.values.min()!
    }
    
    private func linearCost(start: Int, end: Int) -> Int {
        abs(start - end)
    }
    
    private func gaussSumCost(start: Int, end: Int) -> Int {
        let distance = abs(start - end)
        return (distance * (distance + 1)) / 2
    }
}

Day7.main()
