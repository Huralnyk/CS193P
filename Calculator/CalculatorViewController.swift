//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 2/27/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit



class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var memory: UILabel!
    @IBOutlet weak var graphButton: UIButton!
    
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            buttons.forEach { $0.setBackgroundImage(UIImage(color: $0.backgroundColor!), for: .normal) }
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
    
    var userIsInTheMiddleOfTyping = false
    var userIsUsingMemorizedVariable = false
    
    var brain = CalculatorBrain() {
        didSet {
            updateUI()
        }
    }
    
    var variables: [String: Double]?
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = numberFormatter.string(from: NSNumber(value: newValue))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation("✅") { [weak weakSelf = self] in
            weakSelf?.display.textColor = .green
            return sqrt($0)
        }
    }

    
    // MARK: - Actions
    
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
    }
    
    @IBAction func resetCalculator(_ sender: UIButton) {
        brain = CalculatorBrain()
        displayValue = 0
        history.text = " "
        userIsInTheMiddleOfTyping = false
        userIsUsingMemorizedVariable = false
    }
    
    @IBAction func touchBackspace() {
        if userIsInTheMiddleOfTyping {
            removeLastDigit()
        } else {
            brain.undo()
        }
    }
    
    @IBAction func setVariable(_ sender: UIButton) {
        brain.setOperand(variable: "M")
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func startUsingVariable(_ sender: UIButton) {
        variables = ["M": displayValue]
        userIsUsingMemorizedVariable = true
        userIsInTheMiddleOfTyping = false
        updateUI()
    }
    
    // MARK: - Helpers
    
    private func updateUI() {
        let (result, isPending, description) = brain.evaluate(using: userIsUsingMemorizedVariable ? variables : nil)
        let suffix = isPending ? "..." : "="
        displayValue = result ?? 0
        history.text = description.isEmpty ? " " : "\(description) \(suffix)"
        if let memorizedValue = variables?["M"] {
            memory.text = "M = \(memorizedValue)"
        } else {
            memory.text = " "
        }
        graphButton.isEnabled = !isPending
    }
    
    private func removeLastDigit() {
        let characters = display.text!.characters.dropLast()
        let textToPutInDisplay = String(characters)
        
        if textToPutInDisplay.isEmpty {
            display.text = "0"
            userIsInTheMiddleOfTyping = false
        } else {
            display.text = textToPutInDisplay
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .drawGraph:
            if let graphController = segue.destination.contentViewController as? GraphViewController {
                graphController.function = { self.brain.evaluate(using: ["M": $0]).result ?? 0 }
                graphController.title = brain.description
            }
        }
    }
}

// MARK: - Segue Handler

extension CalculatorViewController: SegueHandler {
    
    enum SegueIdentifier: String {
        case drawGraph
    }
}

// MARK: - Extension

extension CalculatorViewController: UISplitViewControllerDelegate {
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        
        if primaryViewController.contentViewController == self,
            let graphController = secondaryViewController.contentViewController as? GraphViewController,
            graphController.function == nil {
            return true
        }
        
        return false
    }
}


