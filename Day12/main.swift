//
//  main.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2021-12-12.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day12: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let graph = Dictionary<Cave, Set<Cave>>(rawValue: try readFile())
        
        let numberOfPathsVisitingSmallCavesAtMostOnce = part1(graph: graph)
        printTitle("Part 1", level: .title1)
        print("Number of paths that visit small caves at most once:", numberOfPathsVisitingSmallCavesAtMostOnce, terminator: "\n\n")
        
        let numberOfPathsVisitingOneSmallCaveAtMostTwice = part2(graph: graph)
        printTitle("Part 2", level: .title1)
        print("Number of paths that visit a small cave at most twice:", numberOfPathsVisitingOneSmallCaveAtMostTwice)
    }
    
    func part1(graph: [Cave: Set<Cave>]) -> Int {
        var foundPaths = [[Cave]]()
        
        func depthFirstSearch(current: Cave, goal: Cave, currentPath: [Cave]) {
            var currentPath = currentPath
            currentPath.append(current)
            
            if current == goal {
                foundPaths.append(currentPath)
                return
            }
            
            for next in graph[current, default: []] {
                let isValid: Bool
                switch next.size {
                case .large:
                    isValid = true
                    
                case .small:
                    isValid = !currentPath.contains(next)
                }
                
                guard isValid else {
                    continue
                }
                
                depthFirstSearch(current: next, goal: goal, currentPath: currentPath)
            }
        }
        
        depthFirstSearch(current: .start, goal: .end, currentPath: [])
        
        return foundPaths.count
    }
    
    func part2(graph: [Cave: Set<Cave>]) -> Int {
        var foundPaths = [[Cave]]()
        
        func depthFirstSearch(current: Cave, goal: Cave, currentPath: [Cave]) {
            var currentPath = currentPath
            currentPath.append(current)
            
            if current == goal {
                foundPaths.append(currentPath)
                return
            }
            
            for next in graph[current, default: []] {
                let isValid: Bool
                switch next.size {
                case .large:
                    isValid = true
                    
                case .small:
                    if next == .start {
                        isValid = false
                        break
                    }
                    
                    let smallCaves = currentPath.filter({ $0.size == .small })
                    
                    if !smallCaves.contains(next) {
                        isValid = true
                        break
                    }
                    
                    let distinctSmallCaves = Set(smallCaves)
                    isValid = distinctSmallCaves.count == smallCaves.count
                }
                
                guard isValid else {
                    continue
                }
                
                depthFirstSearch(current: next, goal: goal, currentPath: currentPath)
            }
        }
        
        depthFirstSearch(current: .start, goal: .end, currentPath: [])
        
        return foundPaths.count
    }
}

Day12.main()
