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
        let origin: Point3D = .zero
        let destination = Point3D(x: 1, y: 2, z: 3)
        
        print(origin)
        print(destination)
        
        let translatedOnce = origin.applying(.translation(to: destination))
        let translatedTwice = translatedOnce.applying(.translation(to: -destination))
        
        print(translatedOnce)
        print(translatedTwice)
    }
}

Day19.main()
