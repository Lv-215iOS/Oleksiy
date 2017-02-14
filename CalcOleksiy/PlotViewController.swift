//
//  PlotViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/30/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit
import AudioToolbox

class PlotViewController: UIViewController {
    
    // MARK: - Properties
    var function : String!
    
    // MARK: - IBOutlets
    @IBOutlet weak var functionLabel: UILabel!
    @IBOutlet weak var plotScrollView: UIScrollView!
    @IBOutlet weak var plotView: PlotView!
    
    // MARK: - IBActios
    @IBAction func backButtonPressed(_ sender: Any) {
        guard let navigationController = navigationController else {
            return
        }
        _ = navigationController.popViewController(animated: true)
        AudioServicesPlaySystemSound(1104)
    }
    
    // MARK: - View life cycle
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
        functionLabel.text = "y = " + function
    }
    
}

// MARK: - UIScrollViewDelegate
extension PlotViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return plotView
    }

}
