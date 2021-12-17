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
        
        let (highestPoint, velocities) = parts1And2(area: area)
        printTitle("Part 1", level: .title1)
        print("Highest y position:", highestPoint, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        print("Number of distinct initial velocities:", velocities.count)
    }
    
    func parts1And2(area: Area) -> (highestPoint: Int, velocities: Set<Velocity>) {
        let possibleXVelocities = 0 ... area.xRange.upperBound
        
        let xPositionsByXVelocity: [[Int]] = possibleXVelocities.map({ velocity in
            var x = 0
            let xPositions = [0] + (0 ... velocity).dropFirst().reversed().map({ deltaX in
                x += deltaX
                return x
            })
            
            return xPositions
        })
        
        var highestY = 0
        var velocities = Set<Velocity>()
        for initialY in area.yRange.lowerBound ..< -area.yRange.lowerBound {
            var yPosition = 0
            var deltaY = initialY
            var highestLocalY = 0
            var numberOfSteps = 0
            
            while yPosition >= area.yRange.lowerBound {
                if yPosition <= area.yRange.upperBound {
                    for initialX in possibleXVelocities {
                        let step = min(
                            numberOfSteps,
                            xPositionsByXVelocity[initialX].count - 1
                        )
                        
                        let xPosition = xPositionsByXVelocity[initialX][step]
                        if area.xRange.contains(xPosition) {
                            highestY = max(highestY, highestLocalY)
                            velocities.insert(.init(x: initialX, y: initialY))
                        }
                    }
                }
                
                yPosition += deltaY
                
                if deltaY == 0 {
                    highestLocalY = yPosition
                }
                
                deltaY -= 1
                numberOfSteps += 1
            }
        }
        
        return (highestY, velocities)
    }
}

Day17.main()
