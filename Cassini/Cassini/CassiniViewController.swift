//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Oleksii Huralnyk on 4/20/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = DemoURL.NASA[segue.identifier ?? ""],
            let imageViewController = segue.destination.contentViewController as? ImageViewController {
            imageViewController.imageURL = url
            imageViewController.title = (sender as? UIButton)?.currentTitle
        }
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        
        if primaryViewController.contentViewController == self,
            let imageController = secondaryViewController.contentViewController as? ImageViewController,
            imageController.imageURL == nil {
            return true
        }
        
        return false
    }
}

extension UIViewController {
    
    var contentViewController: UIViewController {
        if let navController = self as? UINavigationController {
            return navController.visibleViewController ?? self
        }
        
        return self
    }
}
