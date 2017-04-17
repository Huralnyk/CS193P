//
//  GraphViewController.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 3/27/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    typealias BinaryFunction = (_ x: Double) -> Double
    
    var function: BinaryFunction? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: #selector(graphView.changeScale))
            graphView.addGestureRecognizer(pinchRecognizer)
            let panRecognizer = UIPanGestureRecognizer(target: graphView, action: #selector(graphView.translate))
            graphView.addGestureRecognizer(panRecognizer)
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(graphView.resetOrigin))
            doubleTapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapRecognizer)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Private
    
    private func updateUI() {
        graphView?.dataSource = function
    }
}
