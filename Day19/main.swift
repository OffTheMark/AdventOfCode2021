//
//  main.swift
//  Day19
//
//  Created by Marc-Antoine Malépart on 2021-12-19.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day19: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let scanners: [Scanner] = try readFile()
            .components(separatedBy: "\n\n")
            .map(Scanner.init)
        
        printTitle("Part 1", level: .title1)
        let (beaconPositions, scannerPositions) = part1(scanners: scanners)
        print("Number of beacons:", beaconPositions.count, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let largestDistanceBetweenScanners = part2(scanners: scannerPositions)
        print("Largest distance between scanners:", largestDistanceBetweenScanners)
    }
    
    func part1(scanners: [Scanner]) -> (beacons: Set<Point3D>, scanners: Set<Point3D>) {
        var remainingScanners = scanners
        var current = remainingScanners.removeFirst()
        var scannerPositions = Set<Point3D>()
        
        while !remainingScanners.isEmpty {
            for index in remainingScanners.indices {
                let scanner = remainingScanners[index]
                var translation: Point3D?
                
                if let transformed = scanner.transformations()
                    .first(where: { transformed in
                        translation = current.translation(to: transformed)
                        return translation != nil
                    }),
                   let translation = translation {
                    scannerPositions.insert(translation)
                    current.beacons.formUnion(transformed.beacons.map({ $0 + translation }))
                    remainingScanners.remove(at: index)
                    break
                }
            }
        }
        
        return (current.beacons, scannerPositions)
    }
    
    func part2(scanners: Set<Point3D>) -> Int {
        return scanners
            .combinations(ofCount: 2)
            .map({ pair -> Int in
                pair[0].manhattanDistance(to: pair[1])
            })
            .max()!
    }
}

Day19.main()
