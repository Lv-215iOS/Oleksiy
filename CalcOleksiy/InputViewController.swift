		//
//  InputViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/12/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit
import AudioToolbox
        
    class InputViewController: UIViewController, InputInterface {
    
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet var portraitModeButtons: [UIButton]!
    var buttonDidPress: ((String, UIButton) -> ())? = nil
    @IBOutlet var buttonArray: [UIButton]!
    
    @IBAction func touchDownAction(_ sender: UIButton) {
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
        sender.layer.backgroundColor = UIColor(white: 0.228, alpha: 0.8).cgColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttonArray {
            button.adjustsImageWhenDisabled = false
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 20
            button.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            button.layer.backgroundColor = UIColor(white: 1, alpha: 0.4).cgColor
            button.setTitleColor(.white, for: .highlighted)
        }
        for button in portraitModeButtons {
             button.adjustsImageWhenDisabled = false
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            button.setTitleColor(.white, for: .highlighted)
        }
    }
    
    @IBAction func touchDragOutsideAction(_ sender: UIButton) {
        if ["1","2","3","4","5","6","7","8","9","0","."].contains(sender.currentTitle!) {
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            sender.layer.backgroundColor = UIColor(white: 1, alpha: 0.4).cgColor
        } else if ["=","+","-","*","/"," ̂","c","ac"].contains(sender.currentTitle!) {
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            sender.backgroundColor = UIColor(red:254/255, green:249/255, blue:226/255, alpha: 1)
        } else {
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            sender.backgroundColor = UIColor(red:54/255, green:52/255, blue:3/255, alpha: 1)
        }
    }
    //MARK: - InputInterface
    @IBAction func buttonPressed(_ sender: UIButton) {
        if ["1","2","3","4","5","6","7","8","9","0","."].contains(sender.currentTitle!) {
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            sender.layer.backgroundColor = UIColor(white: 1, alpha: 0.4).cgColor
        } else if ["=","+","-","*","/"," ̂","c","ac"].contains(sender.currentTitle!) {
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            sender.backgroundColor = UIColor(red:254/255, green:249/255, blue:226/255, alpha: 1)
        } else {
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(white: 0.667, alpha: 1).cgColor
            sender.backgroundColor = UIColor(red:54/255, green:52/255, blue:3/255, alpha: 1)
        }
        buttonDidPress?(sender.currentTitle!, sender)
        AudioServicesPlaySystemSound(1104)
    }
}
