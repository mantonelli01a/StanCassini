//
//  imageViewController.swift
//  StanCassini
//
//  Created by Michael Antonelli on 05/02/2017.
//  Copyright © 2017 Michael Antonelli. All rights reserved.
//

import UIKit

class imageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if imageURL != nil {
            spinner?.startAnimating()
            DispatchQueue.global(Int(QOS_CLASS_USER_INITIATED.rawValue), 0).async {
                let contentsOfURL = NSData(contentsOf: imageURL as! URL)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.image = UIImage(data: imageData as Data)
                        } else {
                            spinner?.stopAnimating()
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                    
                }
            }
        }
    }
    
    @IBOutlet weak var scrolView: UIScrollView! {
        didSet {
            scrolView.contentSize = imageView.frame.size
            scrolView.delegate = self
            scrolView.minimumZoomScale = 0.03
            scrolView.maximumZoomScale = 1.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrolView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(<#T##animated: Bool##Bool#>)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrolView.addSubview(imageView)
        

        // Do any additional setup after loading the view.
    }

    
}
