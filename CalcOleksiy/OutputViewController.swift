//
//  MyViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/10/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

protocol OutputInterface {
    func outputInfo(info: String)
}

class OutputViewController: UIViewController, OutputInterface{
    
    @IBOutlet weak var mainField: UILabel!
    @IBOutlet weak var additionField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionField.backgroundColor = UIColor(red:1.0, green:0.0, blue:0.0, alpha: 0.3)
    }
    
    func outputInfo(info: String){
        mainField.text = info//
    }
    
    func shakeInfo() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x:mainField.center.x, y:mainField.center.y + 5)
        animation.toValue = CGPoint(x:mainField.center.x, y:mainField.center.y - 5)

        mainField.layer.add(animation, forKey: "position")
    }
    
    func appendInfo(info: String){
        if mainField.text != nil {
            mainField.text = mainField.text! + info
        } else {
            mainField.text = info
        }
    }
    
    func fillSecondLabel(str : String) {
        additionField.text = str
    }
    
    func  mainLabel() -> String {
        if mainField.text != nil {
            return mainField.text!
        }
        return ""
    }
    
    func deleteLast() {
        mainField.text!.remove(at: mainField.text!.index(before: mainField.text!.endIndex))
    }
}
