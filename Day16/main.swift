//
//  main.swift
//  Day16
//
//  Created by Marc-Antoine Malépart on 2021-12-16.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day16: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let hexadecimal = Packet.Hexadecimal(rawValue: try readFile())
        
        let sumOfVersionNumbers = part1(hexadecimal: hexadecimal)
        printTitle("Part 1", level: .title1)
        print("Sum of version numbers in all packets:", sumOfVersionNumbers, terminator: "\n\n")
    }
    
    func part1(hexadecimal: Packet.Hexadecimal) -> Int {
        let packet = Packet(rawValue: hexadecimal.binary())
        
        return packet.allVersions.reduce(0, +)
    }
}

Day16.main()
