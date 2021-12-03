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
        let numbers: [BinaryNumber] = try readLines().map({ rawValue in
            rawValue.compactMap(Bit.init)
        })
        
        let powerConsumption = part1(with: numbers)
        printTitle("Part 1", level: .title1)
        print("Power consumption:", powerConsumption, terminator: "\n\n")
        
        let lifeSupportRating = part2(with: numbers)
        printTitle("Part 2", level: .title1)
        print("Life support rating:", lifeSupportRating)
    }
    
    func part1(with numbers: [BinaryNumber]) -> Int {
        let bitOccurencesByOffset: [Int: [Bit: Int]] = numbers
            .reduce(into: [:], { result, number in
                for (offset, character) in number.enumerated() {
                    var bitOccurences = result[offset, default: [:]]
                    bitOccurences[character, default: 0] += 1
                    
                    result[offset] = bitOccurences
                }
            })
        
        var rawGammaRate = BinaryNumber()
        var rawEpsilonRate = BinaryNumber()
        
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
        
        let gammaRate = Int(rawGammaRate)
        let epsilonRate = Int(rawEpsilonRate)
        
        return gammaRate * epsilonRate
    }
    
    func part2(with numbers: [BinaryNumber]) -> Int {
        let oxygenGeneratorRating = oxygenGeneratorRating(from: numbers)
        let co2ScrubberRating = co2ScrubberRating(from: numbers)
        
        return oxygenGeneratorRating * co2ScrubberRating
    }
    
    private func oxygenGeneratorRating(from numbers: [BinaryNumber]) -> Int {
        var candidates = numbers
        
        for offset in 0 ..< candidates[0].count {
            if candidates.count == 1 {
                return Int(candidates.first!)
            }
            
            var bitOccurences = [Bit: Int]()
            for candidate in candidates {
                let index = candidate.index(candidate.startIndex, offsetBy: offset)
                let bit = candidate[index]
                bitOccurences[bit, default: 0] += 1
            }
            
            let mostCommonBit: Bit
            if bitOccurences[.zero] == bitOccurences[.one] {
                mostCommonBit = .one
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
                return Int(candidates.first!)
            }
        }
        
        fatalError("Could not find oxygen rating")
    }
    
    private func co2ScrubberRating(from numbers: [BinaryNumber]) -> Int {
        var candidates = numbers
        
        for offset in 0 ..< candidates[0].count {
            if candidates.count == 1 {
                return Int(candidates.first!)
            }
            
            var bitOccurences = [Bit: Int]()
            for candidate in candidates {
                let index = candidate.index(candidate.startIndex, offsetBy: offset)
                let bit = candidate[index]
                bitOccurences[bit, default: 0] += 1
            }
            
            let leastCommonBit: Bit
            if bitOccurences[.zero] == bitOccurences[.one] {
                leastCommonBit = .zero
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
                return Int(candidates.first!)
            }
        }
        
        fatalError("Could not find CO2 scrubber rating")
    }
}

enum Bit: Character {
    case zero = "0"
    case one = "1"
}

typealias BinaryNumber = Array<Bit>

extension Int {
    init(_ binaryNumber: BinaryNumber) {
        let rawValue = String(binaryNumber.map(\.rawValue))
        self.init(rawValue, radix: 2)!
    }
}

Day3.main()
