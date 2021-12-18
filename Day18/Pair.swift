//
//  Pair.swift
//  Day18
//
//  Created by Marc-Antoine Malépart on 2021-12-18.
//

import Foundation

struct Pair {
    var left: Element
    var right: Element
    
    var magnitude: Int { 3 * left.magnitude + 2 * right.magnitude }
    
    enum Element {
        case value(Int)
        indirect case pair(Pair)
        
        var magnitude: Int {
            switch self {
            case .value(let value):
                return value
                
            case .pair(let pair):
                return pair.magnitude
            }
        }
        
        func requireValue(file: StaticString = #file, line: UInt = #line) throws -> Int {
            switch self {
            case .value(let value):
                return value
                
            case .pair(let pair):
                throw RequireError(code: .expectedValue(pair), file: file, line: line)
            }
        }
        
        func requirePair(file: StaticString = #file, line: UInt = #line) throws -> Pair {
            switch self {
            case .value(let value):
                throw RequireError(code: .expectedPair(value), file: file, line: line)
                
            case .pair(let pair):
                return pair
            }
        }
    }
    
    struct RequireError: Error {
        let code: Code
        let file: StaticString
        let line: UInt
        
        enum Code {
            case expectedValue(Pair)
            case expectedPair(Int)
        }
    }
}

extension Pair: CustomStringConvertible {
    var description: String {
        "[\(left.description), \(right.description)]"
    }
}

extension Pair.Element: CustomStringConvertible {
    var description: String {
        switch self {
        case .value(let value):
            return String(value)
            
        case .pair(let pair):
            return pair.description
        }
    }
}

extension Pair: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        self.left = try container.decode(Element.self)
        self.right = try container.decode(Element.self)
    }
}

extension Pair.Element: Decodable {
    init(from decoder: Decoder) throws {
        do {
            let pair = try Pair(from: decoder)
            self = .pair(pair)
        }
        catch {
            let singleContainer = try decoder.singleValueContainer()
            let value = try singleContainer.decode(Int.self)
            self = .value(value)
        }
    }
}

func add(_ lhs: Pair, _ rhs: Pair) throws -> Pair {
    var result = Pair(left: .pair(lhs), right: .pair(rhs))
    
    while true {
        let explosionResult = try explode(.pair(result))
        result = try explosionResult.element.requirePair()

        if explosionResult.hasExploded {
            continue
        }

        let splitResult = split(.pair(result))
        result = try splitResult.element.requirePair()

        if !splitResult.hasSplit {
            break
        }
    }
    
    return result
}

func explode(
    _ element: Pair.Element,
    depth: Int = 4
) throws -> (hasExploded: Bool, left: Pair.Element?, element: Pair.Element, right: Pair.Element?) {
    switch element {
    case .value:
        return (false, nil, element, nil)
        
    case .pair(let pair):
        if depth == 0 {
            return (true, pair.left, .value(0), pair.right)
        }
        
        let leftResult = try explode(pair.left, depth: depth - 1)
        
        if leftResult.hasExploded {
            let rightValue = try leftResult.right?.requireValue()
            let newPair = Pair(
                left: leftResult.element,
                right: addLeft(pair.right, value: rightValue)
            )
            
            return (true, leftResult.left, .pair(newPair), nil)
        }
        
        let rightResult = try explode(pair.right, depth: depth - 1)
        
        if rightResult.hasExploded {
            let leftValue = try rightResult.left?.requireValue()
            let newPair = Pair(
                left: addRight(leftResult.element, value: leftValue),
                right: rightResult.element
            )
            
            return (true, nil, .pair(newPair), rightResult.right)
        }
        
        return (false, nil, element, nil)
    }
}

func addLeft(_ element: Pair.Element, value: Int?) -> Pair.Element {
    guard let value = value else {
        return element
    }
    
    switch element {
    case .value(let elementValue):
        let result = elementValue + value
        
        return .value(result)
        
    case .pair(let pair):
        let result = Pair(
            left: addLeft(pair.left, value: value),
            right: pair.right
        )
        
        return .pair(result)
    }
}

func addRight(_ element: Pair.Element, value: Int?) -> Pair.Element {
    guard let value = value else {
        return element
    }
    
    switch element {
    case .value(let elementValue):
        let result = elementValue + value
        
        return .value(result)
        
    case .pair(let pair):
        let result = Pair(
            left: pair.left,
            right: addRight(pair.right, value: value)
        )
        
        return .pair(result)
    }
}

func split(_ element: Pair.Element) -> (hasSplit: Bool, element: Pair.Element) {
    switch element {
    case .value(let value):
        if value >= 10 {
            let leftValue = Int((Double(value) / 2).rounded(.towardZero))
            let rightValue = Int((Double(value) / 2).rounded(.toNearestOrAwayFromZero))
            let pair = Pair(left: .value(leftValue), right: .value(rightValue))
            
            return (true, .pair(pair))
        }
        
        return (false, element)
        
    case .pair(let pair):
        let leftResult = split(pair.left)
        if leftResult.hasSplit {
            let newPair = Pair(
                left: leftResult.element,
                right: pair.right
            )
            
            return (true, .pair(newPair))
        }
        
        let rightResult = split(pair.right)
        let newPair = Pair(
            left: pair.left,
            right: rightResult.element
        )
        
        return (rightResult.hasSplit, .pair(newPair))
    }
}
