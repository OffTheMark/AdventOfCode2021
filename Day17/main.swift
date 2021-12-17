//
//  main.swift
//  Day17
//
//  Created by Marc-Antoine Malépart on 2021-12-17.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day17: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let area = Area(rawValue: try readFile())!
        
        let (highestPoint, velocities) = solve(area: area)
        printTitle("Part 1", level: .title1)
        print("Highest y position:", highestPoint, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        print("Number of distinct initial velocities:", velocities.count)
    }
    
    func solve(area: Area) -> (highestY: Int, velocities: Set<Velocity>) {
        // The X velocities to consider range from 0 to the maximum X of the target area. Otherwise, the probe would
        // surely overshoot the target area.
        let xVelocities = 0 ... area.xRange.upperBound
        
        // We can precalculate all valid X positions for each initial velocity at every step. They all begin at zero and
        // increase less and less until X becomes constant, which is when the x velocity becomes zero.
        let xPositionsByXVelocity: [[Int]] = xVelocities.map({ initialX in
            var x = 0
            let positions = [0] + (0 ... initialX).dropFirst().reversed().map({ deltaX in
                x += deltaX
                return x
            })
            return positions
        })
        
        // We consider the Y velocities ranging from the lower bound to the inverse of the lower bound for y
        // coordinates.
        let yVelocities = area.yRange.lowerBound ..< -area.yRange.lowerBound
        
        var highestY = 0
        var successfulInitialVelocities = Set<Velocity>()
        
        for initialY in yVelocities {
            var yPosition = 0
            var deltaY = initialY
            var highestYForCurrentVelocity = 0
            var currentStep = 0
            
            while yPosition >= area.yRange.lowerBound {
                if yPosition <= area.yRange.upperBound {
                    for initialX in xVelocities {
                        let initialVelocity = Velocity(x: initialX, y: initialY)
                        
                        let index = min(
                            currentStep,
                            xPositionsByXVelocity[initialVelocity.x].count - 1
                        )
                        let xPosition = xPositionsByXVelocity[initialVelocity.x][index]
                        
                        if area.xRange.contains(xPosition) {
                            highestY = max(highestY, highestYForCurrentVelocity)
                            successfulInitialVelocities.insert(initialVelocity)
                        }
                    }
                }
                
                yPosition += deltaY
                
                if deltaY == 0 {
                    // The highest point for each initial velocity is the y coordinate at which the y velocity is zero.
                    highestYForCurrentVelocity = yPosition
                }
                
                deltaY -= 1
                currentStep += 1
            }
        }
        
        return (highestY, successfulInitialVelocities)
    }
}

Day17.main()
