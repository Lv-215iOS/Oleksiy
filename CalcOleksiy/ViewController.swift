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
                self.outputController?.outputInfo(info: "\(value!)")
            }
        }
        inputController?.buttonDidPress = { [unowned self] (operation)->() in
            self.pressedButton(operation: operation)
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
        switch operation {
        case "+":
            outputController?.appendInfo(info: operation)
            calcBrain.binary(operation: .Plus)
        case "-":
            outputController?.appendInfo(info: operation)
            calcBrain.binary(operation: .Minus)
        case "*":
            outputController?.appendInfo(info: operation)
            calcBrain.binary(operation: .Mul)
        case "/":
            outputController?.appendInfo(info: operation)
            calcBrain.binary(operation: .Div)
        case "%":
            outputController?.appendInfo(info: operation)
            calcBrain.binary(operation: .Mod)
        case "^":
            outputController?.appendInfo(info: operation)
            calcBrain.binary(operation: .Power)
        case "sin":
            outputController?.appendInfo(info: operation)
            calcBrain.unary(operation: .Sin)
        case "cos":
            outputController?.appendInfo(info: operation)
            calcBrain.unary(operation: .Cos)
        case "tg":
            outputController?.appendInfo(info: operation)
            calcBrain.unary(operation: .Tg)
        case "ctg":
            outputController?.appendInfo(info: operation)
            calcBrain.unary(operation: .Ctg)
        case "sqrt":
            outputController?.appendInfo(info: operation)
            calcBrain.unary(operation: .Sqrt)
        case "C":
            outputController?.deleteLast()//
            calcBrain.utility(operation: .Clean)
        case "AC":
            outputController?.outputInfo(info: "")
            outputController?.fillSecondLabel(str: "")
            calcBrain.utility(operation: .AClean)
        case ".":
            outputController?.appendInfo(info: operation)
            calcBrain.utility(operation: .Dot)
        case "=":
            outputController?.fillSecondLabel(str: (outputController?.mainLabel())!)
            calcBrain.utility(operation: .Equal)
        case ")":
            outputController?.appendInfo(info: operation)
            calcBrain.utility(operation: .RightBracket)
        case "(":
            outputController?.appendInfo(info: operation)
            calcBrain.utility(operation: .LeftBracket)
        default:
            outputController?.appendInfo(info: operation)
            calcBrain.digit(value: Double(operation)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

