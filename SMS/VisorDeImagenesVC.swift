//
//  VisorDeImagenesVC.swift
//  muro
//
//  Created by Arturo Sanhueza on 01-02-18.
//  Copyright © 2018 Arturo Sanhueza. All rights reserved.
//

import UIKit

class VisorDeImagenesVC: UIViewController,UIScrollViewDelegate {
    var imagenes:[UIImage]!
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var indicador:Int! = nil
    let userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imagenes = [UIImage(named: "btn_Favoritos"),UIImage(named: "Btn_Favoritos_azul"),UIImage(named: "btn_Favoritos_calor")] as! [UIImage]
        scrollView.frame = CGRect(x: 80.0, y: 80.0, width: view.frame.width, height: view.frame.height - 200.0)
        scrollView.contentSize.width = (view.frame.width * CGFloat(imagenes.count))
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.isPagingEnabled = true
        view.backgroundColor = UIColor.gray
        pageControl.frame = CGRect(x: view.frame.width/2.0 - 20.0, y: scrollView.frame.maxY, width: 50.0, height: 30.0)
        view.addSubview(pageControl)
        pageControl.numberOfPages = imagenes.count
        
        let indi = userDefaults.integer(forKey: "indicadorZoom")
        pageControl.currentPage = indi

        for (index, image) in imagenes.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: (view.frame.width * CGFloat(index)), y: view.frame.origin.y, width: view.frame.width - 160.0, height: view.frame.height - 200.0))
            imageView.image = image
        scrollView.addSubview(imageView)
        scrollView.contentOffset.x = (view.frame.width * CGFloat(indi))
}
        view.addSubview(scrollView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pageControl.currentPage = Int(x/w)
        pageControl.currentPageIndicatorTintColor = UIColor.white
        
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


