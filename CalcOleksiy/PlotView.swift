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
        context!.setLineWidth(0.7)
        context?.setStrokeColor(UIColor.darkGray.cgColor)
        let howMany = (600 - 50) / 50
        for i in 0 ..< howMany {
            context?.move(to: CGPoint(x:50+i*50, y: 0))
            context?.addLine(to: CGPoint(x:50+i*50, y: 600))
        }
        let howManyHorizontal = 600 / 50;
        for i in 0 ..< howManyHorizontal {
            context?.move(to: CGPoint(x: 0 ,y: 600 - i*50))
            context?.addLine(to: CGPoint(x:600, y:600 - i*50))
        }
        context?.strokePath()
        context!.setLineWidth(1.9)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        context?.move(to: CGPoint(x: 0 ,y:300))
        context?.addLine(to: CGPoint(x:600, y:300))
        
        context?.move(to: CGPoint(x:300, y: 0))
        context?.addLine(to: CGPoint(x:300, y: 600))

        context?.strokePath()
        context!.setLineWidth(1.9)
        context?.setStrokeColor(UIColor.black.cgColor)
        let path = UIBezierPath()
        path.lineWidth = 1.9
        var x = 0
        var y = CalcModel.sharedModel.plotFunctionIn(-10)
        var p1 = CGPoint(x:x, y:Int(lround((y+10)*30)))
        path.move(to: p1)
        for i in 1 ..< 101 {
            x = i*600/100
            y = CalcModel.sharedModel.plotFunctionIn(Double(i)*20/100-10)
            print("y - ")
            print(lround((y+10)*30))
            let p2 = CGPoint(x:x, y:Int(lround((-y+10)*30)))
            path.addLine(to: p2)
            //path.addQuadCurve(to: midPoint, controlPoint: controlPointsForPoints(p1: midPoint, p2: p1))
            //path.addQuadCurve(to: p2, controlPoint: controlPointsForPoints(p1: midPoint, p2: p2))
            p1=p2
        }
        path.stroke()
    }
}
