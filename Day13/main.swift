//
//  main.swift
//  Day13
//
//  Created by Marc-Antoine Malépart on 2021-12-13.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day13: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let parts = try readFile().components(separatedBy: "\n\n")
        let paper = Paper(rawValue: parts[0])
        let folds = parts[1]
            .components(separatedBy: .newlines)
            .compactMap(Fold.init)
        
        let numberOfPointsAfterFirstFold = part1(paper: paper, fold: folds.first!)
        printTitle("Part 1", level: .title1)
        print("Number of points after the first fold:", numberOfPointsAfterFirstFold, terminator: "\n\n")
        
        let output = part2(paper: paper, folds: folds)
        printTitle("Part 2", level: .title1)
        print("Activation code:", output, separator: "\n\n")
    }
    
    func part1(paper: Paper, fold: Fold) -> Int {
        var paper = paper
        paper.apply(fold)
        return paper.points.count
    }
    
    func part2(paper: Paper, folds: [Fold]) -> String {
        var paper = paper
        folds.forEach({ fold in
            paper.apply(fold)
        })
        return String(describing: paper)
    }
}

Day13.main()
