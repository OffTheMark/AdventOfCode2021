//
//  Position.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2021-12-02.
//

import Foundation

struct Submarine {
    var depth = 0
    var x = 0
    var aim = 0
}

struct Command {
    let direction: Direction
    let value: Int
    
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: " ")
        
        guard parts.count == 2 else {
            return nil
        }
        
        guard let direction = Direction(rawValue: parts[0]) else {
            return nil
        }
        
        guard let value = Int(parts[1]) else {
            return nil
        }
        
        self.direction = direction
        self.value = value
    }
    
    enum Direction: String {
        case forward
        case down
        case up
    }
}
