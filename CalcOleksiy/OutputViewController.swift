//
//  MyViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/10/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

protocol AdvancedOutputInterface {
    func shakeInfo()
    func fillSecondLabel(str: String)
    func mainLabel () -> String
}

class OutputViewController: UIViewController, OutputInterface, AdvancedOutputInterface {
    
    @IBOutlet weak var mainField: UILabel!
    @IBOutlet weak var additionField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionField.backgroundColor = UIColor(red:1.0, green:0.0, blue:0.0, alpha: 0.3)
    }
    //MARK: - OutputProtocol
    func outputInfo(info: String){
        mainField.text = info
    }
    //MARK: - AdvancedOutputProtocol
    func shakeInfo() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x:mainField.center.x, y:mainField.center.y + 5)
        animation.toValue = CGPoint(x:mainField.center.x, y:mainField.center.y - 5)

        mainField.layer.add(animation, forKey: "position")
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
    
}
