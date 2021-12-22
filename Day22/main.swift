//
//  main.swift
//  Day22
//
//  Created by Marc-Antoine Malépart on 2021-12-22.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day22: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let steps: [RebootStep] = try readLines().compactMap(RebootStep.init)
        
        printTitle("Part 1", level: .title1)
        let numberOfCubesThatAreOnInBounds = part1(steps: steps)
        print("Number of cubes that are on:", numberOfCubesThatAreOnInBounds, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let numberOfCubesThatAreOn = part2(steps: steps)
        print("Number of cubes that are on:", numberOfCubesThatAreOn)
    }
    
    func part1(steps: [RebootStep]) -> Int {
        let bounds = Cuboid(
            rangeOfX: -50 ... 50,
            rangeOfY: -50 ... 50,
            rangeOfZ: -50 ... 50
        )
        
        let statesByPoint: [Point3D: CubeState] = steps.reduce(into: [:], { result, step in
            guard let intersection = step.cuboid.intersection(bounds) else {
                return
            }
            
            intersection.points.forEach({ point in
                result[point] = step.state
            })
        })
        
        return statesByPoint.count(where: { _, state in
            state == .on
        })
    }
    
    func part2(steps: [RebootStep]) -> Int {
        let signedCountsByCuboid: [Cuboid: Int] = steps.reduce(into: [:], { result, step in
            var diff = [Cuboid: Int]()
            var fullyContainedCuboids = Set<Cuboid>()
            
            for (cuboid, signedCount) in result {
                if step.cuboid.fullyContains(cuboid) {
                    fullyContainedCuboids.insert(cuboid)
                    continue
                }
                
                if let intersection = step.cuboid.intersection(cuboid) {
                    diff[intersection, default: 0] -= signedCount
                }
            }
            
            if step.state == .on {
                diff[step.cuboid, default: 0] += 1
            }
            
            for cuboid in fullyContainedCuboids {
                result.removeValue(forKey: cuboid)
            }
            
            result.merge(diff, uniquingKeysWith: { left, right in
                left + right
            })
            
            for (cuboid, count) in result where count == 0 {
                result.removeValue(forKey: cuboid)
            }
        })
        
        return signedCountsByCuboid.reduce(into: 0, { result, element in
            let (cuboid, signedCount) = element
            
            result += cuboid.cubeCount * signedCount
        })
    }
}

Day22.main()
