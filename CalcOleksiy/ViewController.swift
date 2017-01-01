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
    var calcBrain = CalcModel.sharedModel
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
            if sender.currentTitle == "x²" {
                self.pressedButton(operation: "^", sender: sender)
                self.pressedButton(operation: "2", sender: sender)
            } else if sender.currentTitle == "x³"{
                self.pressedButton(operation: "^", sender: sender)
                self.pressedButton(operation: "3", sender: sender)
            } else if sender.currentTitle == "π" {
                self.pressedButton(operation: String(M_PI), sender: sender)
            } else if sender.currentTitle == "e" {
                self.pressedButton(operation: String(M_E), sender: sender)
            } else {
                self.pressedButton(operation: operation, sender: sender)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
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
        case "sinh":
            calcBrain.unary(operation: .Sinh)
        case "cosh":
            calcBrain.unary(operation: .Cosh)
        case "tgh":
            calcBrain.unary(operation: .Tgh)
        case "ln":
            calcBrain.unary(operation: .Ln)	
        case "√":
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
            
        case "plot":
            performSegue(withIdentifier: "segue", sender: self)
        case "x":
            calcBrain.XInput()
        default:
            print(operation)
            calcBrain.digit(value: Double(operation)!)
        }
        lastOperation = operation
    }
}

