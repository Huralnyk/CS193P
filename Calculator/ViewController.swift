//
//  ViewController.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 2/27/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
    
    var userIsInTheMiddleOfTyping = false
    
    var brain = CalculatorBrain()
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = numberFormatter.string(from: NSNumber(value: newValue))
        }
    }
    
    var historyValue: String {
        get {
            return history.text ?? ""
        }
        set {
            if newValue.isEmpty {
                history.text = " "
            } else {
                let suffix = brain.resultIsPending ? "..." : "="
                history.text = "\(newValue) \(suffix)"
            }
        }
    }

    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        
        if digit == ".", textCurrentlyInDisplay.contains(digit) { return }
        
        if userIsInTheMiddleOfTyping {
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
            historyValue = brain.description
        }
    }
    
    @IBAction func resetCalculator(_ sender: UIButton) {
        brain = CalculatorBrain()
        displayValue = 0
        historyValue = ""
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func removeLastDigit() {
        let characters = display.text!.characters.dropLast()
        let textToPutInDisplay = String(characters)
        
        if textToPutInDisplay.isEmpty {
            display.text = "0"
            userIsInTheMiddleOfTyping = false
        } else {
           display.text = textToPutInDisplay
        }
    }
}

