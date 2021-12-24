//
//  main.swift
//  Day24
//
//  Created by Marc-Antoine Malépart on 2021-12-24.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day24: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let program: Program = try readLines().compactMap(Instruction.init)
        
        printTitle("Part 1", level: .title1)
        let solution = solve(program: program)
        print("Largest model number accepted by MONAD:", solution.maximum, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        print("Smallest model number accepted by MONAD:", solution.minimum)
    }
    
    func part1(program: Program) -> Int {
        let possibleModelNumbers = 11_111_111_111_111 ... 99_999_999_999_999
        
        return possibleModelNumbers.reversed().first(where: { modelNumber in
            if String(modelNumber).contains("0") {
                return false
            }
            
            do {
                let computer = ArithmeticLogicUnit(program: program, inputs: modelNumber.digits)
                let result = try computer.run()
                
                switch result {
                case .finished:
                    if computer.variables.z == 0 {
                        return true
                    }
                    else {
                        return false
                    }
                    
                case .waitingForInput:
                    return false
                }
            }
            catch {
                return false
            }
        })!
    }
    
    func solve(program: Program) -> (maximum: Int, minimum: Int) {
        var maximum = 99_999_999_999_999
        var minimum = 11_111_111_111_111
        var stack = [(index: Int, b: Int)]()
        
        for i in 0 ..< 14 {
            let a = program[18 * i + 5].rightValue!.literal!
            var b = program[18 * i + 15].rightValue!.literal!
            
            if a > 0 {
                stack.append((i, b))
                continue
            }
            
            let removed = stack.removeLast()
            let j = removed.index
            b = removed.b
            
            let maximumPower: Int
            if a > -b {
                maximumPower = Int(pow(Double(10), Double(13 - j)))
            }
            else {
                maximumPower = Int(pow(Double(10), Double(13 - i)))
            }
            let minimumPower: Int
            if a < -b {
                minimumPower = Int(pow(Double(10), Double(13 - j)))
            }
            else {
                minimumPower = Int(pow(Double(10), Double(13 - i)))
            }
            
            maximum -= abs((a + b) * maximumPower)
            minimum += abs((a + b) * minimumPower)
        }
        
        return (maximum, minimum)
    }
}

Day24.main()

extension Int {
    var digits: [Int] {
        String(self).compactMap({ Int(String($0)) })
    }
}
