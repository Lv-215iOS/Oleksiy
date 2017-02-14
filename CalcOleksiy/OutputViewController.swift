//
//  MyViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/10/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class OutputViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mainField: UILabel!
    @IBOutlet weak var additionField: UILabel!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mainField.text = CalcModel.sharedModel.inputData
        additionField.backgroundColor = UIColor(red:0.205, green:0.197, blue:0.10, alpha: 0.3)
        mainField.adjustsFontSizeToFitWidth = true
        mainField.minimumScaleFactor = 0.8
        mainField.lineBreakMode = .byTruncatingHead
    }
    
}

// MARK: - OutputInterface
extension OutputViewController: OutputInterface {
    
    func outputInfo(info: String){
        mainField.text = info
    }
    
}
// MARK: - AdvancedOutputInterface
extension OutputViewController: AdvancedOutputInterface {
    
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
        return mainField.text ?? ""
    }
    
}
