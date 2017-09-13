//
//  ImageViewController.swift
//  Cassini
//
//  Created by Oleksii Huralnyk on 4/17/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

final class ImageViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

    var imageURL: URL? {
        didSet {
            imageView.image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
        get {
            return imageView.image
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    private func fetchImage() {
        guard let url = imageURL else { return }
        
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let imageData = try? Data(contentsOf: url), url == self?.imageURL {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: imageData)
                }
            }
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
