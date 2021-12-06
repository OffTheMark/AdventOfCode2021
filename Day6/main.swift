//
//  main.swift
//  Day6
//
//  Created by Marc-Antoine Malépart on 2021-12-06.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day6: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let fishes = try readFile()
            .components(separatedBy: ",")
            .compactMap({ rawValue in
                Int(rawValue)
            })
        
        let numberOfFishesAfter80Days = iterate(fishes: fishes, numberOfDays: 80)
        printTitle("Part 1", level: .title1)
        print("Number of fishes:", numberOfFishesAfter80Days, terminator: "\n\n")
        
        let numberOfFishesAfter256Days = iterate(fishes: fishes, numberOfDays: 256)
        printTitle("Part 2", level: .title1)
        print("Number of fishes:", numberOfFishesAfter256Days)
    }
    
    func iterate(fishes: [Int], numberOfDays: Int) -> Int {
        var countByTimer = Array(repeating: 0, count: 9)
        for fish in fishes {
            countByTimer[fish] += 1
        }
        
        for _ in 0 ..< numberOfDays {
            let numberOfNewFishes = countByTimer[0]
            
            for timer in countByTimer.indices.dropLast() {
                countByTimer[timer] = countByTimer[timer + 1]
            }
            
            countByTimer[6] += numberOfNewFishes
            countByTimer[8] = numberOfNewFishes
        }
        
        return countByTimer.reduce(0, +)
    }
}

Day6.main()
