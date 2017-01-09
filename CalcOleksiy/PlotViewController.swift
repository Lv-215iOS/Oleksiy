//
//  PlotViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/30/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class PlotViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var my: UILabel!
    @IBOutlet weak var plotScrollView: UIScrollView!
    @IBOutlet weak var plotView: PlotView!
    var mainViewController : ViewController? = nil
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        plotScrollView.contentSize = CGSize(width:600, height:600)
        plotScrollView.contentOffset = CGPoint(x: 100, y:100)
        plotScrollView.delegate = self
        plotScrollView.maximumZoomScale = 0.50
        plotScrollView.minimumZoomScale = 0.27
        plotScrollView.zoomScale = 0.27
        plotScrollView.layer.borderWidth = 1.5
        plotScrollView.layer.borderColor = UIColor.lightGray.cgColor
        plotScrollView.layer.cornerRadius = 15
        my.text = "y = " + (mainViewController?.outputController?.mainField.text!)!
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return plotView
    }
    
}
