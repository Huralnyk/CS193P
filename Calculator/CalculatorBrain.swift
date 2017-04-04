//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 3/1/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import Foundation

func factorial(_ n: Double) -> Double {
    if n >= 0 {
        return n == 0 ? 1 : n * factorial(n - 1)
    } else {
        return 0 / 0
    }
}

struct CalculatorBrain {
    
    private var accumulator: (value: Double?, description: String) = (nil, "")
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var memory: [Action] = []
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 6
        return formatter
    }()
    
    private enum Operation {
        case constant(Double)
        case random
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
    }
    
    private enum Operand {
        case constant(Double)
        case variable(String)
    }
    
    private enum Action {
        case operation(symbol: String, operation: Operation)
        case operand(Operand)
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        var description: String
        
        init(function: @escaping (Double, Double) -> Double, operand: Double) {
            self.function = function
            self.firstOperand = operand
            self.description = ""
        }
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": .constant(.pi),
        "e": .constant(M_E),
        "Rand": .random,
        "√": .unary(sqrt),
        "sin": .unary(sin),
        "cos": .unary(cos),
        "tan": .unary(tan),
        "log": .unary(log10),
        "ln": .unary(log),
        "x²": .unary({ $0 * $0 }),
        "eˣ": .unary({ pow(M_E, $0) }),
        "1/x": .unary({ 1 / $0 }),
        "x!": .unary(factorial),
        "±": .unary({ -$0 }),
        "xʸ": .binary({ pow($0, $1) }),
        "x³": .unary( { pow($0, 3) }),
        "×": .binary({ $0 * $1 }),
        "÷": .binary({ $0 / $1 }),
        "−": .binary({ $0 - $1 }),
        "+": .binary({ $0 + $1 }),
        "=": .equals
    ]
    
    
    // MARK: - Public
    
    var result: Double? {
        return evaluate().result
    }
    
    var resultIsPending: Bool {
        return evaluate().isPending
    }
    
    var description: String {
        return evaluate().description
    }
    
    mutating func addUnaryOperation(_ symbol: String, operation: @escaping (Double) -> Double) {
        operations[symbol] = .unary(operation)
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            memory.append(.operation(symbol: symbol, operation: operation))
        }
    }
    
    mutating func setOperand(_ value: Double) {
        memory.append(.operand(.constant(value)))
    }
    
    mutating func setOperand(variable named: String) {
        memory.append(.operand(.variable(named)))
    }
    
    mutating func undo() {
        guard !memory.isEmpty else { return }
        memory.removeLast()
    }
    
    func evaluate(using variables: [String: Double]? = nil) -> (result: Double?, isPending: Bool, description: String) {
        var result: Double?
        var description: String = ""
        var pendingBinaryOperation: PendingBinaryOperation?
        
        func perform(_ operation: Operation, with symbol: String) {
            switch operation {
            case .constant(let value):
                result = value
                description = symbol
            case .random:
                result = random()
                description = symbol
            case .unary(let function):
                if result != nil {
                    result = function(result!)
                    if pendingBinaryOperation != nil {
                        description = "\(pendingBinaryOperation!.description) \(symbol)(\(description))"
                        pendingBinaryOperation?.description = ""
                    } else {
                        description = "\(symbol)(\(description))"
                    }
                }
            case .binary(let function):
                performPendingBinaryOperation()
                if result != nil {
                    description += " \(symbol)"
                    pendingBinaryOperation = PendingBinaryOperation(function: function, operand: result!)
                    pendingBinaryOperation?.description = description
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
        
        func performPendingBinaryOperation() {
            if pendingBinaryOperation != nil && result != nil {
                description = pendingBinaryOperation!.description + " \(description)"
                result = pendingBinaryOperation!.perform(with: result!)
                pendingBinaryOperation = nil
            }
        }
        
        func set(_ operand: Operand) {
            switch operand {
            case .constant(let value):
                result = value
                description = format(value)
            case .variable(let name):
                result = variables?[name] ?? 0
                description = name
            }
        }

        
        
        for action in memory {
            switch action {
            case let .operation(symbol, operation):
                perform(operation, with: symbol)
            case let .operand(operand):
                set(operand)
            }
        }
        
        return (result, pendingBinaryOperation != nil, description.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    // MARK: - Private Helpers
    
    private func format(_ operand: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: operand))!
    }
    
    private func random() -> Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
}
