//
//  InputViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/12/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, InputInterface {
    @IBOutlet var portraitModeButtons: [UIButton]!
    
    var buttonDidPress: ((String, UIButton) -> ())? = nil
    
    @IBOutlet var buttonArray: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttonArray {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            button.layer.backgroundColor = UIColor(white: 1, alpha: 0.4).cgColor
        }
        for button in portraitModeButtons {
            if button.currentTitle == "π" || button.currentTitle == "e" {
                button.isEnabled = false
            }
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
        }
    }
    //MARK: - InputInterface
    @IBAction func buttonPressed(_ sender: UIButton) {
        buttonDidPress?(sender.currentTitle!, sender)
    }
}
