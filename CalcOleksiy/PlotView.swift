//
//  PlotView.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/31/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class PlotView: UIView {

    let inputFunc = ""
    
    override func draw(_ rect: CGRect) {
        //draw grid
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(1.7)
        context?.setStrokeColor(UIColor.darkGray.cgColor)
        let howMany = (1200 - 120) / 120
        for i in 0 ..< howMany {
            context?.move(to: CGPoint(x:120+i*120, y: 0))
            context?.addLine(to: CGPoint(x:120+i*120, y: 1200))
        }
        let howManyHorizontal = 1200 / 120;
        for i in 0 ..< howManyHorizontal {
            context?.move(to: CGPoint(x: 0 ,y: 1200 - i*120))
            context?.addLine(to: CGPoint(x:1200, y:1200 - i*120))
        }
        context?.strokePath()
        context!.setLineWidth(3.9)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        context?.move(to: CGPoint(x: 0 ,y:600))
        context?.addLine(to: CGPoint(x:1200, y:600))
        
        context?.move(to: CGPoint(x:600, y: 0))
        context?.addLine(to: CGPoint(x:600, y: 1200))

        context?.strokePath()
        context!.setLineWidth(3.9)
        context?.setStrokeColor(UIColor.white.cgColor)
        let path = UIBezierPath()
        path.lineWidth = 3.9
        var x = 0
        var p2 : CGPoint
        var y = CalcModel.sharedModel.plotFunctionIn(-10)
        var p1 = CGPoint(x:x, y:Int(lround(ceil((-y+10)*60))))
        path.move(to: p1)
        for i in 1 ..< 351 {
            x = i*1200/350
            y = CalcModel.sharedModel.plotFunctionIn(Double(i)*20/350-10)
            print("x - ", x)
            print("y - ", (-y+10)*60)
            p2 = CGPoint(x:x, y:Int(lround(ceil((-y+10)*60))))
            if (-y+10)*60 <= 1400 && (-y+10)*60 >= -400 {
                if abs(p2.y - p1.y) >= 1000 {
                    path.move(to: p2)
                } else {
                    path.addLine(to: p2)
                }
                p1 = p2
            }
        }
        
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.bounds = layer.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.white.cgColor
        pathLayer.position = CGPoint(x:600, y:600)
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 3.0
        pathLayer.lineJoin = kCALineJoinBevel
        
        layer.addSublayer(pathLayer)
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2.0
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        
        pathLayer.add(pathAnimation, forKey: "strokeEnd")

    }
}
