//
//  main.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2021-12-03.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day3: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let numbers = try readLines()
        
        let powerConsumption = part1(with: numbers)
        printTitle("Part 1", level: .title1)
        print("Power consumption:", powerConsumption, terminator: "\n\n")
        
        let lifeSupportRating = part2(with: numbers)
        printTitle("Part 2", level: .title1)
        print("Life support rating:", lifeSupportRating)
    }
    
    func part1(with numbers: [String]) -> Int {
        let bitOccurencesByOffset: [Int: [Character: Int]] = numbers
            .reduce(into: [:], { result, number in
                for (offset, character) in number.enumerated() {
                    var bitOccurences = result[offset, default: [:]]
                    bitOccurences[character, default: 0] += 1
                    
                    result[offset] = bitOccurences
                }
            })
        
        var rawGammaRate = ""
        var rawEpsilonRate = ""
        
        for (_, bitOccurences) in bitOccurencesByOffset.sorted(by: { $0.key < $1.key }) {
            let mostCommonBit = bitOccurences
                .max(by: { $0.value < $1.value })!
                .key
            let leastCommonBit = bitOccurences
                .min(by: { $0.value < $1.value })!
                .key
            
            rawGammaRate.append(mostCommonBit)
            rawEpsilonRate.append(leastCommonBit)
        }
        
        let gammaRate = Int(rawGammaRate, radix: 2)!
        let epsilonRate = Int(rawEpsilonRate, radix: 2)!
        
        return gammaRate * epsilonRate
    }
    
    func part2(with numbers: [String]) -> Int {
        let oxygenGeneratorRating = oxygenGeneratorRating(from: numbers)
        let co2ScrubberRating = co2ScrubberRating(from: numbers)
        
        return oxygenGeneratorRating * co2ScrubberRating
    }
    
    private func oxygenGeneratorRating(from numbers: [String]) -> Int {
        var candidates = numbers
        
        for offset in 0 ..< candidates[0].count {
            if candidates.count == 1 {
                return Int(candidates.first!, radix: 2)!
            }
            
            var bitOccurences = [Character: Int]()
            
            for candidate in candidates {
                let index = candidate.index(candidate.startIndex, offsetBy: offset)
                let bit = candidate[index]
                bitOccurences[bit, default: 0] += 1
            }
            
            let mostCommonBit: Character
            if bitOccurences["0"] == bitOccurences["1"] {
                mostCommonBit = "1"
            }
            else {
                mostCommonBit = bitOccurences
                    .max(by: { $0.value < $1.value })!
                    .key
            }
            
            candidates.removeAll(where: { candidate in
                let index = candidate.index(candidate.startIndex, offsetBy: offset)
                return candidate[index] != mostCommonBit
            })
            
            if candidates.count == 1 {
                return Int(candidates.first!, radix: 2)!
            }
        }
        
        fatalError("Could not find oxygen rating")
    }
    
    private func co2ScrubberRating(from numbers: [String]) -> Int {
        var candidates = numbers
        
        for offset in 0 ..< candidates[0].count {
            if candidates.count == 1 {
                return Int(candidates.first!, radix: 2)!
            }
            
            var bitOccurences = [Character: Int]()
            
            for candidate in candidates {
                let index = candidate.index(candidate.startIndex, offsetBy: offset)
                let bit = candidate[index]
                bitOccurences[bit, default: 0] += 1
            }
            
            let leastCommonBit: Character
            if bitOccurences["0"] == bitOccurences["1"] {
                leastCommonBit = "0"
            }
            else {
                leastCommonBit = bitOccurences
                    .min(by: { $0.value < $1.value })!
                    .key
            }
            
            candidates.removeAll(where: { candidate in
                let index = candidate.index(candidate.startIndex, offsetBy: offset)
                return candidate[index] != leastCommonBit
            })
            
            if candidates.count == 1 {
                return Int(candidates.first!, radix: 2)!
            }
        }
        
        fatalError("Could not find CO2 scrubber rating")
    }
}

Day3.main()
