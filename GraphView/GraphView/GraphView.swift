//
//  GraphView.swift
//  GraphView
//
//  Created by Oleksii Huralnyk on 4/4/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

protocol GraphViewDelegate {
    func graphView(_ graphView: GraphView, yValueForX x: CGFloat) -> CGFloat
}

@IBDesignable class GraphView: UIView {
    
    private struct Constants {
        static let defaultPointsPerUnit: CGFloat = 50
    }
    
    @IBInspectable var scale: CGFloat = 1.0 {
        didSet {
            scale = max(0.1, min(10, scale))
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var color: UIColor = .blue {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    private var origin: CGPoint {
        return CGPoint(x: bounds.maxX * anchorPoint.x, y: bounds.maxY * anchorPoint.y)
    }
    
    private var drawer = AxesDrawer()
        
        

    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawer.color = color
        drawer.contentScaleFactor = contentScaleFactor
        drawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale * Constants.defaultPointsPerUnit)
    }
    
    private func drawAxes() {
        
    }
    
    private func drawGraph() {
        
    }

}
