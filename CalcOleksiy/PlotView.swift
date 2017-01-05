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
        let howMany = (1200 - 50) / 50
        for i in 0 ..< howMany {
            context?.move(to: CGPoint(x:50+i*50, y: 0))
            context?.addLine(to: CGPoint(x:50+i*50, y: 1200))
        }
        let howManyHorizontal = 1200 / 50;
        for i in 0 ..< howManyHorizontal {
            context?.move(to: CGPoint(x: 0 ,y: 1200 - i*50))
            context?.addLine(to: CGPoint(x:1200, y:1200 - i*50))
        }
        context?.strokePath()
        context!.setLineWidth(1.9)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        context?.move(to: CGPoint(x: 0 ,y:600))
        context?.addLine(to: CGPoint(x:1200, y:600))
        
        context?.move(to: CGPoint(x:600, y: 0))
        context?.addLine(to: CGPoint(x:600, y: 1200))

        context?.strokePath()
        context!.setLineWidth(1.9)
        context?.setStrokeColor(UIColor.white.cgColor)
        let path = UIBezierPath()
        path.lineWidth = 1.9
        var x = 0
        var y = CalcModel.sharedModel.plotFunctionIn(-10)
        var p1 = CGPoint(x:x, y:Int(lround((-y+10)*60)))
        path.move(to: p1)
        for i in 1 ..< 251 {
            x = i*1200/250
            y = CalcModel.sharedModel.plotFunctionIn(Double(i)*20/250-10)
            print("y - ")
            print(lround((y+10)*60))
            let p2 = CGPoint(x:x, y:Int(lround((-y+10)*60)))
            if abs(p2.y - p1.y) >= 1000 {
                path.move(to: p2)
            } else {
                path.addLine(to: p2)
            }
            p1 = p2
        }
        path.stroke()
    }
}
