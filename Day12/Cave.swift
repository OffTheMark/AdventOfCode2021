//
//  Cave.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2021-12-12.
//

import Foundation

extension Dictionary where Key == Cave, Value == Set<Cave> {
    init(rawValue: String) {
        let passages: [(Cave, Cave)] = rawValue
            .components(separatedBy: .newlines)
            .compactMap({ line in
                let parts = line.components(separatedBy: "-")
                
                guard parts.count == 2 else {
                    return nil
                }
                
                return (Cave(rawValue: parts[0]), Cave(rawValue: parts[1]))
            })
        
        self = passages.reduce(into: [:], { result, passage in
            result[passage.0, default: []].insert(passage.1)
            result[passage.1, default: []].insert(passage.0)
        })
    }
}

struct Cave {
    let rawValue: String
    
    static let start: Cave = "start"
    static let end: Cave = "end"
    
    var size: Size {
        if rawValue.contains(where: { $0.isUppercase }) {
            return .large
        }
        
        return .small
    }
    
    enum Size {
        case small
        case large
    }
}

extension Cave: Hashable {}

extension Cave: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
