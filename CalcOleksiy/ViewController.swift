//
//  ViewController.swift
//  CalcOleksiy
//
//  Created by adminaccount on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Parameters
    var outputController : OutputViewController? = nil
    var plotViewController : PlotViewController? = nil
    var inputController : InputViewController? = nil
    var calcBrain = CalcModel.sharedModel
    var lastOperation = ""

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calcBrain.resultOutput = { (value, error)->() in
            if (value != nil) {
                self.outputController!.outputInfo(info: "\(value!)")
            } else {
                self.outputController!.shakeInfo()
            }
        }
        inputController!.buttonDidPress = { [unowned self] (operation, sender)->() in
            let previousData = self.calcBrain.inputData
            if sender.currentTitle == "x²" {
                self.pressedButton(operation: " ̂", sender: sender)
                if previousData.characters.last != self.calcBrain.inputData.characters.last {
                    self.pressedButton(operation: "2", sender: sender)
                }
            } else if sender.currentTitle == "x³"{
                self.pressedButton(operation: " ̂", sender: sender)
                if previousData.characters.last != self.calcBrain.inputData.characters.last {
                    self.pressedButton(operation: "3", sender: sender)
                }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        calcBrain.saveInputData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutputControllerEmbedSegue" {
            outputController = segue.destination as? OutputViewController
        } else if segue.identifier == "InputControllerEmbedSegue" {
            inputController = segue.destination as? InputViewController
        } else if segue.identifier == "segue" {
            plotViewController = segue.destination as? PlotViewController
            plotViewController!.function = outputController!.mainField.text ?? ""
        }
    }
    
    // MARK: - Auxiliary functions
    private func pressedButton(operation : String, sender : UIButton) {
        
        guard let inputController = inputController,
              let outputController = outputController else {
            return
        }
        
        inputController.cleanButton.setTitle("c", for: .normal)
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
        case " ̂":
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
        case "⇐":
            calcBrain.utility(operation: .Clean)
            if outputController.mainLabel() == "0" {
                inputController.cleanButton.setTitle("ac", for: .normal)
            }
        case "c":
            inputController.cleanButton.setTitle("ac", for: .normal)
            outputController.fillSecondLabel(str: "")
            calcBrain.utility(operation: .AClean)
        case "ac":
            inputController.cleanButton.setTitle("ac", for: .normal)
            calcBrain.utility(operation: .AClean)
        case ".":
            calcBrain.utility(operation: .Dot)
        case "=":
            var xPersistance = true
            for i in outputController.mainLabel().characters {
                if i == "x" {
                    xPersistance = false
                    break
                }
            }
            if xPersistance {
                outputController.fillSecondLabel(str: outputController.mainLabel() )
                calcBrain.utility(operation: .Equal)
            } else {
                outputController.shakeInfo()
            }
        case ")":
            calcBrain.utility(operation: .RightBracket)
        case "(":
            calcBrain.utility(operation: .LeftBracket)
            
        case "plot":
            if calcBrain.functionTest() {
                performSegue(withIdentifier: "segue", sender: self)
            } else {
                outputController.shakeInfo()
            }
        case "x":
            calcBrain.xInput()
        default:
            print(operation)
            calcBrain.digit(value: Double(operation)!)
        }
        lastOperation = operation
    }
    
}

