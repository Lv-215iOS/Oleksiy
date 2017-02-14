//
//  PlotView.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/31/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class PlotView: UIView {

    // MARK: - Parameters
    let inputFunc = ""
    
    // MARK: - View life cycle
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let viewWidth = bounds.width
        let viewHeight = bounds.height
        
        // Draw grid
        context.setLineWidth(kGridLineWidth)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        let howManyVertical = (Int(viewHeight) - kGridStep) / kGridStep
        for i in 0 ..< howManyVertical {
            context.move(to: CGPoint(x:kGridStep+i*kGridStep, y: 0))
            context.addLine(to: CGPoint(x:kGridStep+i*kGridStep, y: Int(viewHeight)))
        }
        let howManyHorizontal = Int(viewWidth) / kGridStep;
        for i in 0 ..< howManyHorizontal {
            context.move(to: CGPoint(x: 0 ,y: Int(viewWidth) - i*kGridStep))
            context.addLine(to: CGPoint(x:Int(viewWidth), y:Int(viewWidth) - i*kGridStep))
        }
        context.strokePath()
        
        // Draw coordinate system
        context.setLineWidth(kCoordinateLineWidth)
        context.setStrokeColor(UIColor.black.cgColor)
        context.move(to: CGPoint(x: 0 ,y:Int(viewWidth/2)))
        context.addLine(to: CGPoint(x:Int(viewWidth), y:Int(viewWidth/2)))
        context.move(to: CGPoint(x:Int(viewWidth/2), y: 0))
        context.addLine(to: CGPoint(x:Int(viewWidth/2), y: Int(viewWidth)))
        context.strokePath()
        
        // Draw plot
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let path = UIBezierPath()
            var x = 0
            var y = CalcModel.sharedModel.functionIn(kGraphInterpolateFrom)
            var p1 = CGPoint(x:x, y:Int(lround(ceil((-y-kGraphInterpolateFrom)*60))))
            var p2 : CGPoint
            path.move(to: p1)
            for i in 1 ..< kFunctionStep + 1 {
                x = i*Int(viewWidth)/kFunctionStep
                y = CalcModel.sharedModel.functionIn(Double(i)*kGraphLength/Double(kFunctionStep) + kGraphInterpolateFrom)
                print("x - ", x)
                print("y - ", (-y-kGraphInterpolateFrom)*60)
                p2 = CGPoint(x:x, y:Int(lround(ceil((-y-kGraphInterpolateFrom)*60))))
                if (-y-kGraphInterpolateFrom)*60 <= 1400 && Int((-y-kGraphInterpolateFrom)*60) >= -kFunctionStep {
                    if abs(p2.y - p1.y) >= 300 {
                        path.move(to: p2)
                    } else {
                        path.addLine(to: p2)
                    }
                    p1 = p2
                }
            }
            
            // Plot animation setup
            let pathLayer: CAShapeLayer = CAShapeLayer()
            pathLayer.bounds = self.layer.bounds
            pathLayer.path = path.cgPath
            pathLayer.strokeColor = UIColor.white.cgColor
            pathLayer.position = CGPoint(x:Int(viewWidth/2), y:Int(viewHeight/2))
            pathLayer.fillColor = nil
            pathLayer.lineWidth = kGraphLineWidth
            pathLayer.lineJoin = kCALineJoinBevel
            
            let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 2.0
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            DispatchQueue.main.sync {
                self.layer.addSublayer(pathLayer)
                pathLayer.add(pathAnimation, forKey: "strokeEnd")
            }
        }
    }
    
}
