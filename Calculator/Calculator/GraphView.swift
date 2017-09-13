//
//  GraphView.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 3/27/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    private struct Constants {
        static let pointsPerUnit: CGFloat = 50
        static let toleranceRatio: CGFloat = 1.5
    }
    
    @IBInspectable var axesColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var graphColor: UIColor = .purple {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var zoomScale: CGFloat = 1.0 {
        didSet {
            zoomScale = min(maximumZoomScale, max(minimumZoomScale, zoomScale))
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var minimumZoomScale: CGFloat = 1.0
    @IBInspectable var maximumZoomScale: CGFloat = 1.0
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    var origin: CGPoint {
        set {
            userSetOrigin = newValue
            setNeedsDisplay()
        }
        get {
            return userSetOrigin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    var dataSource: ((Double) -> Double)? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var userSetOrigin: CGPoint?
    
    override func draw(_ rect: CGRect) {
        let drawer = AxesDrawer(color: axesColor, contentScaleFactor: contentScaleFactor)
        drawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: zoomScale * Constants.pointsPerUnit)
        drawGraph(in: rect)
    }
    
    private func drawGraph(in rect: CGRect) {
        guard let dataSource = dataSource else { return }
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        var isFirstPoint = true
        var previousY: CGFloat = 0
        
        for pixel in Int(rect.origin.x * contentScaleFactor) ..< Int((rect.width * contentScaleFactor)) {
            
            let absX = CGFloat(pixel) / contentScaleFactor
            let x = (absX - origin.x) / (zoomScale * Constants.pointsPerUnit)
            let y = CGFloat(dataSource(Double(x)))
            let absY = origin.y - CGFloat(y) * zoomScale * Constants.pointsPerUnit
            
            guard y.isNormal || y.isZero else { continue }
            
            let point = CGPoint(x: absX, y: absY)
            let isDiscontinuousPoint = abs(absY - previousY) > max(rect.width, rect.height) * Constants.toleranceRatio
            
            if isFirstPoint || isDiscontinuousPoint {
                path.move(to: point)
                isFirstPoint = false
            } else {
                path.addLine(to: point)
            }
            
            previousY = absY
        }
        
        graphColor.setStroke()
        path.stroke()
    }
    
    // MARK: - Gesture Handling
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            zoomScale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1.0
        default:
            break
        }
    }
    
    func translate(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .changed, .ended:
            let translation = panRecognizer.translation(in: self)
            origin = CGPoint(
                x: origin.x + translation.x,
                y: origin.y + translation.y
            )
            panRecognizer.setTranslation(.zero, in: self)
        default:
            break
        }
    }
    
    func resetOrigin(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        switch tapRecognizer.state {
        case .ended:
            let touchPoint = tapRecognizer.location(in: self)
            origin = touchPoint
        default:
            break
        }
    }
}
