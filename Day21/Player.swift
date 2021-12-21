//
//  Player.swift
//  Day21
//
//  Created by Marc-Antoine Malépart on 2021-12-21.
//

import Foundation

protocol Die {
    mutating func roll() -> Int
}

struct DeterministicDie: Die {
    private var currentIndex = 0
    
    mutating func roll() -> Int {
        let result = (currentIndex % 100) + 1
        currentIndex = (currentIndex + 1) % 100
        return result
    }
}

struct Player {
    var position: Position
    var score: Int = 0
    let targetScore: Int
    
    var hasWon: Bool { score >= targetScore }
    
    mutating func move(by positions: Int) {
        position.move(by: positions)
        score += position.rawValue
    }
}

extension Player: Hashable {}

struct Position {
    private(set) var rawValue: Int
    
    mutating func move(by positions: Int) {
        rawValue = (((rawValue - 1) + positions) % 10) + 1
    }
}

extension Position: Hashable {}

extension Position {
    init?(rawValue: String) {
        guard let rawValue = Int(rawValue) else {
            return nil
        }
        
        self.rawValue = rawValue
    }
}
