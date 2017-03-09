//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 3/1/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
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
                accumulator = value
            case .unary(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binary(let function):
                performPendingBinaryOperation()
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if resultIsPending {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        return accumulator
    }
    
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil && accumulator != nil
    }
    
    var description: String {
        return ""
    }
}
