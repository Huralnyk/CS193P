//
//  AsteroidView.swift
//  Asteroids
//
//  Created by Oleksii Huralnyk on 6/7/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

class AsteroidView: UIImageView {
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        image = UIImage(named: "asteroid\((arc4random() % 9) + 1)")
        frame.size = image?.size ?? .zero
    }
}
