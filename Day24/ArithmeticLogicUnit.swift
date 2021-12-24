//
//  ArithmeticLogicUnit.swift
//  Day24
//
//  Created by Marc-Antoine Malépart on 2021-12-24.
//

import Foundation

typealias Program = [Instruction]

final class ArithmeticLogicUnit {
    private(set) var variables: Variables
    private let program: Program
    private var instructionPointer: Int
    private(set) var inputs: [Int]
    
    init(
        variables: Variables = .init(),
        program: Program,
        inputs: [Int]
    ) {
        self.variables = variables
        self.program = program
        self.instructionPointer = program.startIndex
        self.inputs = inputs
    }
    
    func addInput(_ input: Int) {
        inputs.append(input)
    }
    
    func addInputs(_ inputs: [Int]) {
        self.inputs.append(contentsOf: inputs)
    }
    
    func run() throws -> Result {
        while let instruction = nextInstruction() {
            let instructionResult = try execute(instruction)
            
            switch instructionResult {
            case .waitingForInput:
                return .waitingForInput
                
            case .continue:
                continue
            }
        }
        
        return .finished
    }
    
    func execute(_ instruction: Instruction) throws -> InstructionResult {
        switch instruction {
        case .input(let a):
            if inputs.isEmpty {
                return .waitingForInput
            }
            
            let input = inputs.removeFirst()
            setValue(input, for: a)
            
        case .add(let a, let b):
            let valueForA = variables[keyPath: a.keyPath]
            let valueForB = value(for: b)
            let newValue = valueForA + valueForB
            
            setValue(newValue, for: a)
            
        case .multiply(let a, let b):
            let valueForA = variables[keyPath: a.keyPath]
            let valueForB = value(for: b)
            let newValue = valueForA * valueForB
            
            setValue(newValue, for: a)
            
        case .divide(let a, let b):
            let valueForA = variables[keyPath: a.keyPath]
            let valueForB = value(for: b)
            
            if valueForB == 0 {
                throw InstructionError.divideByZero(a: a, b: b)
            }
            
            let newValue = valueForA / valueForB
            
            setValue(newValue, for: a)
            
        case .modulo(let a, let b):
            let valueForA = variables[keyPath: a.keyPath]
            let valueForB = value(for: b)
            
            if valueForA < 0 || valueForB <= 0 {
                throw InstructionError.invalidModulo(a: a, b: b)
            }
            
            let newValue = valueForA % valueForB
            setValue(newValue, for: a)
            
        case .equals(let a, let b):
            let valueForA = variables[keyPath: a.keyPath]
            let valueForB = value(for: b)
            
            let newValue: Int
            if valueForA == valueForB {
                newValue = 1
            }
            else {
                newValue = 0
            }
            
            setValue(newValue, for: a)
        }
        
        return .continue
    }
    
    private func nextInstruction() -> Instruction? {
        guard program.indices.contains(instructionPointer) else {
            return nil
        }
        
        let instruction = program[instructionPointer]
        instructionPointer = program.index(after: instructionPointer)
        return instruction
    }
    
    private func setValue(_ value: Int, for variable: Instruction.Variable) {
        variables[keyPath: variable.writableKeypath] = value
    }
    
    private func value(for variable: Instruction.Variable) -> Int {
        variables[keyPath: variable.keyPath]
    }
    
    private func value(for instructionValue: Instruction.Value) -> Int {
        switch instructionValue {
        case .literal(let value):
            return value
            
        case .variable(let variable):
            return variables[keyPath: variable.keyPath]
        }
    }
    
    struct Variables {
        var w: Int = 0
        var x: Int = 0
        var y: Int = 0
        var z: Int = 0
    }
    
    enum InstructionResult {
        case `continue`
        case waitingForInput
    }
    
    enum InstructionError: Error {
        case divideByZero(a: Instruction.Variable, b: Instruction.Value)
        case invalidModulo(a: Instruction.Variable, b: Instruction.Value)
    }
    
    enum Result {
        case finished
        case waitingForInput
    }
}

enum Instruction {
    case input(a: Variable)
    case add(a: Variable, b: Value)
    case multiply(a: Variable, b: Value)
    case divide(a: Variable, b: Value)
    case modulo(a: Variable, b: Value)
    case equals(a: Variable, b: Value)
    
    var rightValue: Value? {
        switch self {
        case .add(_, let rightValue),
                .multiply(_, let rightValue),
                .divide(_, let rightValue),
                .modulo(_, let rightValue),
                .equals(_, let rightValue):
            return rightValue
            
        case .input:
            return nil
        }
    }
    
    enum Value {
        case literal(Int)
        case variable(Variable)
        
        var literal: Int? {
            switch self {
            case .literal(let literal):
                return literal
                
            case .variable:
                return nil
            }
        }
    }
    
    enum Variable: String {
        case w
        case x
        case y
        case z
        
        var writableKeypath: WritableKeyPath<ArithmeticLogicUnit.Variables, Int> {
            switch self {
            case .w:
                return \.w
                
            case .x:
                return \.x
                
            case .y:
                return \.y
                
            case .z:
                return \.z
            }
        }
        
        var keyPath: KeyPath<ArithmeticLogicUnit.Variables, Int> {
            switch self {
            case .w:
                return \.w
                
            case .x:
                return \.x
                
            case .y:
                return \.y
                
            case .z:
                return \.z
            }
        }
    }
}

extension Instruction {
    init?(rawValue: String) {
        var components = rawValue.components(separatedBy: " ")
        
        if components.isEmpty {
            return nil
        }
        
        let instruction = components.removeFirst()
        
        switch instruction {
        case "inp":
            guard components.count == 1, let variable = Variable(rawValue: components[0]) else {
                return nil
            }
            
            self = .input(a: variable)
            
        case "add":
            guard components.count == 2,
                  let a = Variable(rawValue: components[0]),
                  let b = Value(rawValue: components[1]) else {
                      return nil
                  }
            
            self = .add(a: a, b: b)
            
        case "mul":
            guard components.count == 2,
                  let a = Variable(rawValue: components[0]),
                  let b = Value(rawValue: components[1]) else {
                      return nil
                  }
            
            self = .multiply(a: a, b: b)
            
        case "div":
            guard components.count == 2,
                  let a = Variable(rawValue: components[0]),
                  let b = Value(rawValue: components[1]) else {
                      return nil
                  }
            
            self = .divide(a: a, b: b)
            
        case "mod":
            guard components.count == 2,
                  let a = Variable(rawValue: components[0]),
                  let b = Value(rawValue: components[1]) else {
                      return nil
                  }
            
            self = .modulo(a: a, b: b)
            
        case "eql":
            guard components.count == 2,
                  let a = Variable(rawValue: components[0]),
                  let b = Value(rawValue: components[1]) else {
                      return nil
                  }
            
            self = .equals(a: a, b: b)
            
        default:
            return nil
        }
    }
}

extension Instruction.Value {
    init?(rawValue: String) {
        if let variable = Instruction.Variable(rawValue: rawValue) {
            self = .variable(variable)
            return
        }
        
        if let literal = Int(rawValue) {
            self = .literal(literal)
            return
        }
        
        return nil
    }
}
