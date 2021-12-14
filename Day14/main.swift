//
//  main.swift
//  Day14
//
//  Created by Marc-Antoine Malépart on 2021-12-14.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day14: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let parts = try readFile().components(separatedBy: "\n\n")
        let polymer = Polymer(rawValue: parts[0])
        let rules: [String: Character] = parts[1]
            .components(separatedBy: .newlines)
            .reduce(into: [:], { result, line in
                let lineParts = line.components(separatedBy: " -> ")
                let pair = lineParts[0]
                
                guard pair.count == 2 else {
                    return
                }
                
                guard lineParts[1].count == 1 else {
                    return
                }
                
                let element = lineParts[1].first!
                
                result[pair] = element
            })
        
        let differenceAfter10Steps = part1(polymer: polymer, rules: rules)
        printTitle("Part 1", level: .title1)
        print("Difference after 10 steps:", differenceAfter10Steps, terminator: "\n\n")
        
        let differenceAfter40Steps = part2(polymer: polymer, rules: rules)
        printTitle("Part 2", level: .title1)
        print("Difference after 40 steps:", differenceAfter40Steps)
    }
    
    func part1(polymer: Polymer, rules: [String: Character]) -> Int {
        iterate(numberOfTimes: 10, polymer: polymer, rules: rules)
    }
    
    func part2(polymer: Polymer, rules: [String: Character]) -> Int {
        iterate(numberOfTimes: 40, polymer: polymer, rules: rules)
    }
    
    func iterate(numberOfTimes: Int, polymer: Polymer, rules: [String: Character]) -> Int {
        let steps = 0 ..< numberOfTimes
        var countByPairOfElements = polymer.countByPairOfElements()
        var countByElement: [Character: Int] = polymer.rawValue
            .reduce(into: [:], { result, element in
                result[element, default: 0] += 1
            })
        
        for _ in steps {
            var newResult = [String: Int]()
            
            for (pair, count) in countByPairOfElements {
                guard let insertedElement = rules[pair] else {
                    continue
                }
                
                let newPairs = [
                    String([pair.first!, insertedElement]),
                    String([insertedElement, pair.last!])
                ]
                
                newPairs.forEach({ newPair in
                    newResult[newPair, default: 0] += count
                })
                countByElement[insertedElement, default: 0] += count
            }
            
            countByPairOfElements = newResult
        }
        
        let minAndMax = countByElement.minAndMax(by: { $0.value < $1.value })!
        return minAndMax.max.value - minAndMax.min.value
    }
}

Day14.main()
