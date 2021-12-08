//
//  Entry.swift
//  Day8
//
//  Created by Marc-Antoine Malépart on 2021-12-08.
//

import Foundation

struct Entry {
    let signalPatterns: [Set<SignalWire>]
    let outputSignals: [Set<SignalWire>]
}

extension Entry {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: " | ")
        
        guard parts.count == 2 else {
            return nil
        }
        
        self.signalPatterns = parts[0]
            .components(separatedBy: .whitespaces)
            .map({ Set($0.compactMap(SignalWire.init)) })
        self.outputSignals = parts[1]
            .components(separatedBy: .whitespaces)
            .map({ Set($0.compactMap(SignalWire.init)) })
    }
}

enum SignalWire: Character, CaseIterable {
    case a = "a"
    case b = "b"
    case c = "c"
    case d = "d"
    case e = "e"
    case f = "f"
    case g = "g"
}

enum Segment: Character, CaseIterable {
    case a = "a"
    case b = "b"
    case c = "c"
    case d = "d"
    case e = "e"
    case f = "f"
    case g = "g"
}
