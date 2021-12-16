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
        let packet = try Packet(rawValue: hexadecimal.binary())
        
        let sumOfVersionNumbers = part1(packet: packet)
        printTitle("Part 1", level: .title1)
        print("Sum of version numbers in all packets:", sumOfVersionNumbers, terminator: "\n\n")
        
        let valueOfPacket = part2(packet: packet)
        printTitle("Part 2", level: .title1)
        print("Value of outermost packet:", valueOfPacket)
    }
    
    func part1(packet: Packet) -> Int {
        packet.allVersions.reduce(0, +)
    }
    
    func part2(packet: Packet) -> Int {
        packet.value
    }
}

Day16.main()
