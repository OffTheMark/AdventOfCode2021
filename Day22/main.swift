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
        let signedVolumesByCuboid = signedVolumesByCuboid(steps: steps, bounds: bounds)
        
        return signedVolumesByCuboid.reduce(into: 0, { result, element in
            let (cuboid, signedVolume) = element
            
            result += cuboid.cubeCount * signedVolume
        })
    }
    
    func part2(steps: [RebootStep]) -> Int {
        let signedVolumesByCuboid = signedVolumesByCuboid(steps: steps)
        
        return signedVolumesByCuboid.reduce(into: 0, { result, element in
            let (cuboid, signedVolume) = element
            
            result += cuboid.cubeCount * signedVolume
        })
    }
    
    func signedVolumesByCuboid(steps: [RebootStep], bounds: Cuboid? = nil) -> [Cuboid: Int] {
        func stepCuboid(step: RebootStep, bounds: Cuboid?) -> Cuboid? {
            guard let bounds = bounds else {
                return step.cuboid
            }
            
            return step.cuboid.intersection(bounds)
        }
        
        let signedVolumesByCuboid: [Cuboid: Int] = steps.reduce(into: [:], { result, step in
            guard let stepCuboid = stepCuboid(step: step, bounds: bounds) else {
                return
            }
            
            var diff = [Cuboid: Int]()
            var fullyContainedCuboids = Set<Cuboid>()
            
            for (cuboid, signedVolume) in result {
                if stepCuboid.fullyContains(cuboid) {
                    fullyContainedCuboids.insert(cuboid)
                    continue
                }
                
                // When a new "on" or "off" cuboid comes in, find intersections with the step's cuboid and any
                // preexisting cuboid. If there are any, add the intersection to the diff with the opposite sign to
                // cancel it out.
                if let intersection = stepCuboid.intersection(cuboid) {
                    diff[intersection, default: 0] -= signedVolume
                }
            }
            
            // When a new "on" cuboid comes in, add it the diff with a positive sign.
            if step.state == .on {
                diff[stepCuboid, default: 0] += 1
            }
            
            // If the step's cuboid fully contains a preexisting cuboid, we can remove it.
            for cuboid in fullyContainedCuboids {
                result.removeValue(forKey: cuboid)
            }
            
            // Apply the signed volume difference to the accumulated result.
            result.merge(diff, uniquingKeysWith: { left, right in
                left + right
            })
            
            // Remove all cuboids where the signed volume is zero.
            for (cuboid, signedVolume) in result where signedVolume == 0 {
                result.removeValue(forKey: cuboid)
            }
        })
        
        return signedVolumesByCuboid
    }
}

Day22.main()
