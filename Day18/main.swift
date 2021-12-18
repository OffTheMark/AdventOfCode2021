//
//  main.swift
//  Day18
//
//  Created by Marc-Antoine Malépart on 2021-12-18.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day18: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let decoder = JSONDecoder()
        
        let pairs: [Pair] = try readLines().map({ rawValue in
            let data = Data(rawValue.utf8)
            return try decoder.decode(Pair.self, from: data)
        })
        
        let totalResult = try part1(pairs: pairs)
        printTitle("Part 1", level: .title1)
        print("Result:", totalResult)
        print("Magnitude:", totalResult.magnitude, terminator: "\n\n")
        
        let sumWithGreatestMagnitude = try part2(pairs: pairs)
        printTitle("Part 2", level: .title1)
        print("Sum with greatest magnitude:", sumWithGreatestMagnitude)
        print("Magnitude:", sumWithGreatestMagnitude.magnitude)
    }
    
    func part1(pairs: [Pair]) throws -> Pair {
        var result = pairs.first!
        var iterator = pairs.dropFirst().makeIterator()
        
        while let next = iterator.next() {
            result = try add(result, next)
        }
        
        return result
    }
    
    func part2(pairs: [Pair]) throws -> Pair {
        let permutations = pairs.permutations(ofCount: 2)
        let sums: [Pair] = try permutations.map({ permutation in
            try add(permutation[0], permutation[1])
        })
        
        return sums.max(by: { $0.magnitude < $1.magnitude })!
    }
}

Day18.main()
