//
//  PlotViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/30/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class PlotViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var plotScrollView: UIScrollView!
    @IBOutlet weak var plotView: PlotView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        plotScrollView.contentSize = CGSize(width:600, height:600)
        plotScrollView.contentOffset = CGPoint(x: 100, y:100)
        plotScrollView.delegate = self
        plotScrollView.maximumZoomScale = 1.5
        plotScrollView.minimumZoomScale = 0.54
        plotScrollView.zoomScale = 0.54
        plotScrollView.layer.borderWidth = 1.5
        plotScrollView.layer.borderColor = UIColor.lightGray.cgColor
        plotScrollView.layer.cornerRadius = 15
        /*
        let data = [0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77, 0.99, 0.55]
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(0.6)
        context?.setStrokeColor(gray: 0.667, alpha: 1)
        let howMany = (900 - 50) / 50
        
        // Here the lines go
        for i in 0 ..< howMany {
            context?.move(to: CGPoint(x:50+i*50, y: 0))
            context?.addLine(to: CGPoint(x:50+i*50, y: 300))
        }
        context?.strokePath()
        let howManyHorizontal = (300 - 0 - 50) / 50;
        for i in 0 ..< howManyHorizontal {
            context?.move(to: CGPoint(x: 0 ,y: 300 - 50 - i*50))
            context?.addLine(to: CGPoint(x:900, y:300 - 50 - i*50))
        }
        context?.strokePath()
        let path = UIBezierPath()
        var p1 = CGPoint(x:25, y:300 - 300*data[0])
        path.move(to: p1)
        for i in 1 ..< 12 {
            let p2 = CGPoint(x:25+i*25, y:Int(300 - 300*data[i]))
            let circle = UIBezierPath(ovalIn:CGRect(origin: p2, size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
            path.addLine(to: p2)
            //path.addQuadCurve(to: midPoint, controlPoint: controlPointsForPoints(p1: midPoint, p2: p1))
            //path.addQuadCurve(to: p2, controlPoint: controlPointsForPoints(p1: midPoint, p2: p2))
            p1=p2
        }
        path.stroke()
        */
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return plotView
    }
    
}
