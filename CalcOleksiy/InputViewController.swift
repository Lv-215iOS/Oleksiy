//
//  InputViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/12/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

protocol InputInterface {
    var buttonDidPress: ((String, UIButton) -> ())? {get set}
}

class InputViewController: UIViewController, InputInterface {
    
    var buttonDidPress: ((String, UIButton) -> ())? = nil
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        buttonDidPress?(sender.currentTitle!, sender)
    }
}
