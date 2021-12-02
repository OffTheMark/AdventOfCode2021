//
//  main.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2021-12-02.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day2: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let commands = try readLines().compactMap(Command.init)
        
        let part1Product = part1(with: commands)
        printTitle("Part 1", level: .title1)
        print("Product:", part1Product, terminator: "\n\n")
        
        let part2Product = part2(with: commands)
        printTitle("Part 2", level: .title1)
        print("Product:", part2Product)
    }
    
    func part1(with commands: [Command]) -> Int {
        var submarine = Submarine()
        
        for command in commands {
            switch command.direction {
            case .forward:
                submarine.x += command.value
                
            case .down:
                submarine.depth += command.value
                
            case .up:
                submarine.depth -= command.value
            }
        }
        
        return submarine.depth * submarine.x
    }
    
    func part2(with commands: [Command]) -> Int {
        var submarine = Submarine()
        
        for command in commands {
            switch command.direction {
            case .down:
                submarine.aim += command.value
                
            case .up:
                submarine.aim -= command.value
                
            case .forward:
                submarine.x += command.value
                submarine.depth += submarine.aim * command.value
            }
        }
        
        return submarine.depth * submarine.x
    }
}

Day2.main()
