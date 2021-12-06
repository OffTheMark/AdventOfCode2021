//
//  Lanternfish.swift
//  Day6
//
//  Created by Marc-Antoine Malépart on 2021-12-06.
//

import Foundation

struct Lanternfish {
    private(set) var timer: Int
    
    mutating func iterate() -> IterationResult {
        let result: IterationResult
        
        if timer == 0 {
            result = .create
        }
        else {
            result = .none
        }
        
        timer -= 1
        
        if timer < 0 {
            timer = 6
        }
        
        return result
    }
    
    enum IterationResult {
        case create
        case none
    }
}
