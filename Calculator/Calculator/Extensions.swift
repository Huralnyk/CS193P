//
//  Extensions.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 4/17/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var contentViewController: UIViewController? {
        if let navController = self as? UINavigationController {
            return navController.visibleViewController
        } else {
            return self
        }
    }
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
