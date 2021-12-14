//
//  Polymer.swift
//  Day14
//
//  Created by Marc-Antoine Malépart on 2021-12-14.
//

import Foundation
import Algorithms

struct Polymer {
    let rawValue: String
    
    func countByPairOfElements() -> [String: Int] {
        return rawValue.windows(ofCount: 2).reduce(into: [:], { result, window in
            let pair = String(window)
            result[pair, default: 0] += 1
        })
    }
}
