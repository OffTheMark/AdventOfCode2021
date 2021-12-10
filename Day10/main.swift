//
//  main.swift
//  Day10
//
//  Created by Marc-Antoine Malépart on 2021-12-10.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Collections

struct Day10: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines().map(Line.init)
        
        let totalSyntaxErrorScore = part1(lines: lines)
        printTitle("Part 1", level: .title1)
        print("Total syntax error score:", totalSyntaxErrorScore, terminator: "\n\n")
        
        let middleScore = part2(lines: lines)
        printTitle("Part 2", level: .title1)
        print("Middle score:", middleScore)
    }
    
    func part1(lines: [Line]) -> Int {
        let syntaxScoreByClosingBracket: [Character: Int] = [")": 3, "]": 57, "}": 1_197, ">": 25_137]
        
        return lines.reduce(into: 0, { total, line in
            guard let firstIllegalCharacter = line.firstIllegalCharacter(),
                  let score = syntaxScoreByClosingBracket[firstIllegalCharacter] else {
                return
            }
            
            total += score
        })
    }
    
    func part2(lines: [Line]) -> Int {
        let nonCorruptedLines = lines.filter({ $0.firstIllegalCharacter() == nil })
        let scoreByClosingBacket: [Character: Int] = [")": 1, "]": 2, "}": 3, ">": 4]
        
        let scores: [Int] = nonCorruptedLines
            .map({ line in
                let charactersToComplete = line.charactersToComplete()
                let score = charactersToComplete.reduce(into: 0, { result, character in
                    result *= 5
                    result += scoreByClosingBacket[character]!
                })
                return score
            })
            .sorted()
        let middleIndex = scores.count / 2
        
        return scores[middleIndex]
    }
}

Day10.main()
