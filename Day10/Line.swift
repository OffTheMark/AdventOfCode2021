//
//  Line.swift
//  Day10
//
//  Created by Marc-Antoine Malépart on 2021-12-10.
//

import Foundation
import Collections

struct Line {
    static let startingBrackets: Set<Character> = ["(", "[", "{", "<"]
    static let closingBrackets: Set<Character> = [")", "]", "}", ">"]
    static let closingBracketsByOpeningBracket: [Character: Character] = ["(": ")", "[": "]", "{": "}", "<": ">"]
    
    let rawValue: String
    
    func firstIllegalCharacter() -> Character? {
        var stack = Deque<Character>()
        
        for character in rawValue {
            if Self.startingBrackets.contains(character) {
                stack.append(character)
            }
            
            if Self.closingBrackets.contains(character) {
                guard let openingBracket = stack.popLast() else {
                    continue
                }
                
                let closingBracket = Self.closingBracketsByOpeningBracket[openingBracket]!
                if closingBracket != character {
                    return character
                }
            }
        }
        
        return nil
    }
    
    func charactersToComplete() -> [Character] {
        var stack = Deque<Character>()
        
        for character in rawValue {
            if Self.startingBrackets.contains(character) {
                stack.append(character)
            }
            
            if Self.closingBrackets.contains(character) {
                _ = stack.popLast()
            }
        }
        
        var charactersToComplete = [Character]()
        while let openingBracket = stack.popLast() {
            let closingBracket = Self.closingBracketsByOpeningBracket[openingBracket]!
            charactersToComplete.append(closingBracket)
        }
        
        return charactersToComplete
    }
}
