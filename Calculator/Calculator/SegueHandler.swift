//
//  SegueHandler.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 4/17/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegue(_ identifier: SegueIdentifier, sender: Any? = nil) {
        self.performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier else {
            fatalError("Invalid segue identifier \(String(describing: segue.identifier)).")
        }
        
        return segueIdentifier(for: identifier)
    }
    
    func segueIdentifier(for identifier: String) -> SegueIdentifier {
        guard let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(String(describing: identifier)).")
        }
        
        return segueIdentifier
    }
}
