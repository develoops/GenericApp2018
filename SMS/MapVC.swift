//
//  MapVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 05-07-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class MapVC: UIViewController,UIScrollViewDelegate {

    let scrollView = UIScrollView()
    var nombreMapa:String!
    var imageView = UIImageView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    scrollView.delegate = self
    scrollView.isPagingEnabled = true
    scrollView.bounces = true
    scrollView.zoomScale = 2.0
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 12.0
    
    
    imageView = UIImageView(image: UIImage(named: nombreMapa))
    scrollView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height - (self.navigationController?.navigationBar.frame.height)!)
        view.addSubview(self.scrollView)
    imageView.frame = scrollView.frame
    scrollView.addSubview(imageView)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return imageView
    }
}
