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
    var lastOperation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calcBrain.result = { (value, error)->() in
            if (value != nil) {
                self.outputController?.outputInfo(info: "\(value!)")
            } else {
                self.outputController?.shakeInfo()
            }
        }
        inputController?.buttonDidPress = { [unowned self] (operation, sender)->() in
            self.pressedButton(operation: operation, sender: sender)
        }
        
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutputControllerEmbedSegue" {
            outputController = segue.destination as? OutputViewController
        } else if segue.identifier == "InputControllerEmbedSegue" {
            inputController = segue.destination as? InputViewController
        }
    }
    
    func pressedButton(operation : String, sender : UIButton) {
        switch operation {
            // binary operations
        case "+":
            calcBrain.binary(operation: .Plus)
        case "-":
            calcBrain.binary(operation: .Minus)
        case "*":
            calcBrain.binary(operation: .Mul)
        case "/":
            calcBrain.binary(operation: .Div)
        case "%":
            calcBrain.binary(operation: .Mod)
        case "^":
            calcBrain.binary(operation: .Power)
            
            // unary operations
        case "sin":
             calcBrain.unary(operation: .Sin)
        case "cos":
             calcBrain.unary(operation: .Cos)
        case "tg":
             calcBrain.unary(operation: .Tg)
        case "ctg":
            calcBrain.unary(operation: .Ctg)
        case "sqrt":
             calcBrain.unary(operation: .Sqrt)
            
            //utility operations
        case "C":
            calcBrain.utility(operation: .Clean)
        case "AC":
            outputController?.fillSecondLabel(str: "")
            calcBrain.utility(operation: .AClean)
        case ".":
            calcBrain.utility(operation: .Dot)
        case "=":
            outputController?.fillSecondLabel(str: (outputController?.mainLabel())!)
            calcBrain.utility(operation: .Equal)
        case ")":
            calcBrain.utility(operation: .RightBracket)
        case "(":
            calcBrain.utility(operation: .LeftBracket)
        default:
            calcBrain.digit(value: Double(operation)!)
        }
        lastOperation = operation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

