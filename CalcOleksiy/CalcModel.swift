//
//  CalcModel.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

enum BinaryOperation : String{
    case Plus = "+"
    case Minus = "-"
    case Mul = "*"
    case Div = "/"
    case Power = "^"
    case Mod = "%"
}

enum UtilityOperation : String{
    case RightBracket = ")"
    case LeftBracket = "("
    case Dot = "."
    case Equal = "="
    case Clean = "C"
    case AClean = "AC"
}

enum UnaryOperation : String{
    case Sin = "sin"
    case Cos = "cos"
    case Tg = "tg"
    case Ctg = "ctg"
    case Sqrt = "sqrt"
}


protocol CalcBrainInterface {
    func digit(value: Double)
    func binary(operation: BinaryOperation)
    func unary(operation: UnaryOperation)
    func utility(operation: UtilityOperation)
    var result: ((Double?, Error?)->())? {get set}
}


class CalcModel: NSObject, CalcBrainInterface {
    static let sharedCalcModel = CalcModel() //sigleton
    private var inputData = ""
    private var inputDataArray = [String]() //seperate string into math components
    private var outputData = [String]() //reverse polish notation in array
    
    //MARK - CalcBrainInterface
    
    func digit(value: Double){
        inputData += String(Int(value
        ))
    }
    func binary(operation: BinaryOperation){
        inputData += operation.rawValue
    }
    func unary(operation: UnaryOperation){
        inputData += operation.rawValue

    }
    func utility(operation: UtilityOperation){
        if operation == .Equal {
            let temp = CalculateRPN()
            
            result?(temp,nil)
            inputData = "\(temp)"
            inputDataArray = [String]()
            outputData = [String]()
        } else if operation == .AClean {
            inputData = ""
            inputDataArray = [String]()
            outputData = [String]()
        } else if operation == .Clean {
            inputData.remove(at: inputData.index(before: inputData.endIndex))
            inputDataArray = [String]()
            outputData = [String]()
        } else {
            inputData += operation.rawValue
        }
    }
    var result: ((Double?, Error?)->())?

    private func seperateInputData(){ //function seperate inputData into math components
        print(inputData)
        for charachter in inputData.characters {
            if isOperation(at: String(charachter)) {
                inputDataArray.append(String(charachter))
            } else if isValue(at: String(charachter)){ //determine if last charachter is number, 
                if inputDataArray.count == 0 {         // if true add next charachter to the same string
                    inputDataArray.append(String(charachter))
                } else if isValue(at: inputDataArray[inputDataArray.count - 1]) {
                    inputDataArray[inputDataArray.count - 1] += String(charachter)
                } else if (inputDataArray.count == 1 && inputDataArray[inputDataArray.count - 1] == "-"){
                    inputDataArray[inputDataArray.count - 1] += String(charachter)
                } else if (inputDataArray.count > 1) && (isOperationDM(at: inputDataArray[inputDataArray.count - 2]) || isOperation(at: inputDataArray[inputDataArray.count - 2])) && inputDataArray[inputDataArray.count - 1] == "-" {
                    inputDataArray[inputDataArray.count - 1] += String(charachter)
                }else {
                    inputDataArray.append(String(charachter)) //
                }
            } else if charachter == "." {
                inputDataArray[inputDataArray.count - 1] += String(charachter)
            } else if inputDataArray.count != 0 && !isTrigonomenry(at: inputDataArray[inputDataArray.count - 1]) && !isOperation(at: inputDataArray[inputDataArray.count - 1]) {
                    inputDataArray[inputDataArray.count - 1] += String(charachter) // if element of array is not fully written trigonometry func
            } else {
                inputDataArray.append(String(charachter))
            }
        }
        print(inputDataArray)
    }
    
    private func calculateData(){  //calculate reverse polish notation
        var stack = [String]() //stack for operators
        for symbol in inputDataArray{
            if !isOperation(at: symbol){ //if symbol is number
                outputData.append(String(symbol))
            } else if isOperationDM(at: String(symbol)){ //if symbol is math operation
                if stack.count == 0 || symbol == "(" { //if stack empty or symbol = (, add symbol
                    stack.append(String(symbol))
                } else if priorityBetweenOperators(first: stack.last!, second: symbol) &&  stack.last! != "(" {
                //if last operator has higher or same precedence, pop element from stack to outputdata and push symbol
                    var i = 0
                    for element in stack.reversed() {
                        if priorityBetweenOperators(first: element, second: symbol) &&  element != "(" {
                            i+=1
                            outputData.append(String(element))
                        } else {
                            break
                        }
                    }
                    stack = Array(stack.dropLast(i))
                    stack.append(String(symbol))
                } else {
                    stack.append(String(symbol))
                }
            } else if symbol == ")" { //pop all elements until (
                var i = 0
                for element in stack.reversed() {
                    if element != "(" {
                        i += 1
                        outputData.append(String(element))
                    } else {
                        break
                    }
                }
                stack = Array(stack.dropLast(i+1))
            } else {
                stack.append(String(symbol))
            }
            print(outputData)
            print(stack)
                
        }
        for element in stack.reversed() {
            outputData.append(String(element))
        }
        print(outputData)
        
    }
    private func priorityFor(char:String) -> Int{ //determine priority
        if char == "+" || char == "-" {
            return 1
        } else if (char == "^") {
            return 3
        } else if isTrigonomenry(at: char) {
            return 4
        }
        return 2
    }
    
    private func priorityBetweenOperators(first:String, second:String) -> Bool { //priority between operators
        if priorityFor(char: first) >= priorityFor(char: second) {
            return true
        }
        return false
    }
    
    private func isValue(at char: String) -> Bool{// determine if number
        if !isOperationDM(at: char) && !isOperation(at: char) {
             return true
        }
        return false
    }
    
    private func isOperation(at char: String) -> Bool{ //determine if math symbol
        
        if isOperationDM(at: char) || char == "(" || char == ")" {
            return true
        }
        return false
    }
    
    private func isTrigonomenry(at char: String) -> Bool{ //determine if trigonometry func
        if char=="sin" || char=="cos" || char=="tg" || char=="ctg" || char=="sqrt" {
            return true
        }
        return false
    }
    
    private func isOperationDM(at char: String) -> Bool{ //determine if math operator
        
        if char=="+" || char=="/" || char=="*" || char=="-" || char == "^" || char=="%" || char == "sin" || char == "cos" || char == "tg" || char == "ctg" || char=="sqrt" {
            return true
        }
        return false
    }
    private func CalculateRPN() -> Double { //calculate RPN and return result of expression
        self.seperateInputData()
        self.calculateData()
        var stack =  [Double]()
        for value in outputData {
            switch value {
            case "+":
                let rightValue = stack.removeLast()
                let leftValue = stack.removeLast()
                stack.append(leftValue + rightValue)
            case "-":
                let rightValue = stack.removeLast()
                let leftValue = stack.removeLast()
                stack.append(leftValue - rightValue)
            case "*":
                let rightValue = stack.removeLast()
                let leftValue = stack.removeLast()
                stack.append(leftValue * rightValue)
            case "/":
                let rightValue = stack.removeLast()
                let leftValue = stack.removeLast()
                stack.append(leftValue / rightValue)//
            case "%":
                let rightValue = stack.removeLast()
                let leftValue = stack.removeLast()
                stack.append(leftValue.truncatingRemainder(dividingBy:rightValue))
            case "^":
                let rightValue = stack.removeLast()
                let leftValue = stack.removeLast()
                stack.append(pow(leftValue, rightValue))
            case "sin":
                let value = stack.removeLast()
                stack.append(sin(value))
            case "cos":
                let value = stack.removeLast()
                stack.append(cos(value))
            case "tg":
                let value = stack.removeLast()
                stack.append(tan(value))
            case "ctg":
                let value = stack.removeLast()
                stack.append(1/tan(value))
            case "sqrt":
                let value = stack.removeLast()
                stack.append(sqrt(value))
            default:
                stack.append(Double(value)!)
            }
             print(stack)
        }
        return stack[stack.count-1]	
    }
}
