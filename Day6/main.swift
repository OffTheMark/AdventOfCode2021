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
                Int(rawValue).flatMap(Lanternfish.init)
            })
        
        let numberOfFishesAfter80Days = iterate(fishes: fishes, numberOfDays: 80)
        printTitle("Part 1", level: .title1)
        print("Number of fishes:", numberOfFishesAfter80Days, terminator: "\n\n")
    }
    
    func iterate(fishes: [Lanternfish], numberOfDays: Int) -> Int {
        var fishes = fishes
        
        for _ in 0 ..< numberOfDays {
            var numberOfNewFishes = 0
            
            for index in fishes.indices {
                let result = fishes[index].iterate()
                
                if result == .create {
                    numberOfNewFishes += 1
                }
            }
            
            let newFishes = Array<Lanternfish>(repeating: Lanternfish(timer: 8), count: numberOfNewFishes)
            fishes.append(contentsOf: newFishes)
        }
        
        return fishes.count
    }
}

Day6.main()
