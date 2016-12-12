//
//  ViewController.swift
//  CalcOleksiy
//
//  Created by adminaccount on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var outputController : OutputViewController? = nil
    var inputController : InputViewController? = nil
    var calcBrain = CalcModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calcBrain.result = { (value, error)->() in
            if (value != nil) {
                self.calcBrain.inputData = "\(value!)"
                self.outputController?.Label.text =  "\(value!)"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutputControllerEmbedSegue" {
            outputController = segue.destination as? OutputViewController
            outputController?.mainViewController = self
        } else if segue.identifier == "InputControllerEmbedSegue" {
            inputController = segue.destination as? InputViewController
            inputController?.mainViewController = self
        }
    }
    
    func pressedButton(operation : String) {
        if operation == "-" {
            calcBrain.binary(operation: .Minus)
            self.outputController?.Label.text =  (self.outputController?.Label.text)! + "\(operation)"
        } else if operation == "C" {
            self.outputController?.Label.text = ""
            calcBrain.inputData = ""
        } else if operation == "=" {
            calcBrain.utility(operation: .Equal)
        } else {
            self.outputController?.Label.text =  (self.outputController?.Label.text)! + "\(operation)"
            calcBrain.inputData += operation
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

