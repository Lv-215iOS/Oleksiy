//
//  ViewController.swift
//  CalcOleksiy
//
//  Created by adminaccount on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedButton(_ sender: UIButton) {
        if sender.currentTitle == "=" {
            let model = CalcModel(withData: label.text!)
            model.calculateData()
            model.printInputData()
            model.printOutputData()
             label.text = String(model.CalculateRPN())
        } else {
            label.text = label.text! + sender.currentTitle!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

