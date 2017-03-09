//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 3/1/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: (value: Double?, description: String) = (nil, "")
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
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
        "√": .unary(sqrt),
        "sin": .unary(sin),
        "cos": .unary(cos),
        "tan": .unary(tan),
        "log": .unary(log),
        "x²": .unary({ $0 * $0 }),
        "±": .unary({ -$0 }),
        "×": .binary({ $0 * $1 }),
        "÷": .binary({ $0 / $1 }),
        "−": .binary({ $0 - $1 }),
        "+": .binary({ $0 + $1 }),
        "=": .equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator.value = value
                accumulator.description = symbol
            case .unary(let function):
                if accumulator.value != nil {
                    accumulator.value = function(accumulator.value!)
                    if resultIsPending {
                        accumulator.description = "\(pendingBinaryOperation!.description) \(symbol)(\(accumulator.description))"
                        pendingBinaryOperation?.description = ""
                    } else {
                        accumulator.description = "\(symbol)(\(accumulator.description))"
                    }
                }
            case .binary(let function):
                performPendingBinaryOperation()
                if accumulator.value != nil {
                    accumulator.description += " \(symbol)"
                    pendingBinaryOperation = PendingBinaryOperation(function: function, operand: accumulator.value!)
                    pendingBinaryOperation?.description = accumulator.description
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if resultIsPending {
            accumulator.description = pendingBinaryOperation!.description + " \(accumulator.description)"
            accumulator.value = pendingBinaryOperation!.perform(with: accumulator.value!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator.value = operand
        accumulator.description = format(operand)
    }
    
    var result: Double? {
        return accumulator.value
    }
    
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil && accumulator.value != nil
    }
    
    var description: String {
        return accumulator.description.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func format(_ operand: Double) -> String {
        return String(Int(operand))
    }
}
