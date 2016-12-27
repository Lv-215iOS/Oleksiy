//
//  CalcModel.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class CalcModel: NSObject, CalcBrainInterface {
    static let sharedCalcModel = CalcModel() //sigleton
    private var inputData = "0"
    private var inputDataArray = [String]() //seperate string into math components
    private var outputData = [String]() //reverse polish notation in array
    private var openBracesCount = 0
    private var closedBracesCount = 0
    private var dotToken = true
    
    //MARK:- CalcBrainInterface
    func digit(value: Double){
        if String(inputData.characters.last ?? " ") == "0" {
            let temp = inputData.remove(at: inputData.index(before: inputData.endIndex))
            if (String(inputData.characters.last ?? " ") == "." || isValue(at: String(inputData.characters.last ?? "-"))) && inputData != "0" {
                inputData += String(temp)
            }
        }
        inputData += String(Int(value))
        result?(inputData, nil)
    }
    func binary(operation: BinaryOperation){
        dotToken = true
        if operation == .Minus {
            if String(inputData.characters.last ?? " ") == "+" {
                inputData.remove(at: inputData.index(before: inputData.endIndex))
                inputData += "-"
                result?(inputData, nil)
            } else if String(inputData.characters.last ?? " ") == "-" {
                inputData.remove(at: inputData.index(before: inputData.endIndex))
                inputData += "+"
                result?(inputData, nil)
            } else if String(inputData.characters.last ?? " ") == ")" || Int(String(inputData.characters.last ?? " ")) != nil {
                inputData += operation.rawValue
                result?(inputData, nil)
            } else {
                inputData += "-0"
                result?(inputData, nil)

            }
        } else if Int(String(inputData.characters.last ?? " ")) != nil || String(inputData.characters.last ?? " ") == ")" {
            inputData += operation.rawValue
            result?(inputData, nil)
        } else {
            if isOperationDM(at: String(inputData.characters.last ?? " ")){
                inputData.remove(at: inputData.index(before: inputData.endIndex))
                inputData += operation.rawValue
                result?(inputData, nil)
            } else {
                result?(nil, nil)
            }
        }
    }
    func unary(operation: UnaryOperation){
        dotToken = true
        if String(inputData.characters.last ?? " ") == "." || String(inputData.characters.last ?? " ") == ")" || Int(String(inputData.characters.last ?? " ")) != nil && inputData != "0"{
            result?(nil, nil)
        } else {
            if ["n","s","g","h"].contains(String(inputData.characters.last ?? " ")) {
                inputData += "("
                openBracesCount += 1
                inputData += operation.rawValue
                result?(inputData, nil)
            } else if inputData == "0" {
                inputData = operation.rawValue
                result?(inputData, nil)
            } else {
                inputData += operation.rawValue
                result?(inputData, nil)
            }
        }
    }
    func utility(operation: UtilityOperation){
        if operation == .Equal {
            if (Int(String(inputData.characters.last ?? " ")) != nil || String(inputData.characters.last ?? " ") == ")" ) && openBracesCount == closedBracesCount {
                dotToken = true
                let result1 : Double = CalculateRPN()
                if result1.truncatingRemainder(dividingBy:1) == 0 {
                    inputData = "\(Int(result1))"
                } else {
                    inputData = "\(result1)"
                }
                inputDataArray = [String]()
                outputData = [String]()
                result?(inputData,nil)
            } else {
                result?(nil, nil)
            }
        } else if operation == .AClean {
            dotToken = true
            inputData = "0"
            openBracesCount = 0
            closedBracesCount = 0
            inputDataArray = [String]()
            outputData = [String]()
            result?(inputData, nil)
        } else if operation == .Clean {
            if String(inputData.characters.last ?? " ") == "." {
                dotToken = true
            }
            if inputData != "" {
                let removedSymbol = inputData.remove(at: inputData.index(before: inputData.endIndex))
                if removedSymbol == "(" { openBracesCount -= 1 }
                if removedSymbol == ")" { closedBracesCount -= 1 }
                inputDataArray = [String]()
                outputData = [String]()
                if String(inputData.characters.last ?? " ") == " " {
                    inputData = "0"
                }
                result?(inputData, nil)
            } else {
                inputData = "0"
                result?(inputData, nil)
            }
        } else if operation == .Dot {
            if dotToken {
                if Int(String(inputData.characters.last ?? " ")) == nil {
                    inputData += "0"
                }
                inputData += operation.rawValue
                result?(inputData, nil)
                dotToken = false
            } else  {
                result?(nil,nil)
            }
        } else {
            dotToken = true
            if operation == .RightBracket {
                if closedBracesCount != openBracesCount && (closedBracesCount != 0 || Int(String(inputData.characters.last ?? " ")) != nil) {
                    closedBracesCount += 1
                    inputData += operation.rawValue
                    result?(inputData, nil)
                } else {
                    result?(nil,nil)
                }
            } else if operation == .LeftBracket {
                if ( ["n","s","g","h"].contains(String(inputData.characters.last ?? " ")) || isOperation(at: String(inputData.characters.last ?? " "))) && String(inputData.characters.last ?? " ") != ")" {
                    openBracesCount += 1
                    inputData += operation.rawValue
                    result?(inputData, nil)
                } else {
                    result?(nil,nil)
                }
            } else {
                inputData += operation.rawValue
                result?(inputData, nil)
            }
        }
    }
    var result: ((String?, Error?)->())?

    //MARK:- CalcModel
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
                    if charachter == "h" {
                        inputDataArray[inputDataArray.count - 1] += String(charachter)
                    } else {
                        inputDataArray.append(String(charachter))
                    }
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
        if char=="sin" || char=="cos" || char=="tg" || char=="ctg" || char=="ln" || char=="√" || char=="sinh" || char=="cosh" || char=="tgh" {
            return true
        }
        return false
    }
    
    private func isOperationDM(at char: String) -> Bool{ //determine if math operator
        
        if char=="+" || char=="/" || char=="*" || char=="-" || char == "^" || char=="%" || char == "sin" || char == "cos" || char == "tg" || char == "ctg" || char=="ln" || char=="√" || char=="sinh" || char=="cosh" || char=="tgh" {
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
            case "sinh":
                let value = stack.removeLast()
                stack.append(sinh(value))
            case "cosh":
                let value = stack.removeLast()
                stack.append(cosh(value))
            case "tgh":
                let value = stack.removeLast()
                stack.append(tanh(value))
            case "ln":
                let value = stack.removeLast()
                stack.append(log(value))
            case "√":
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
