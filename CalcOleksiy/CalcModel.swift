//
//  CalcModel.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class CalcModel: NSObject {
    
    private var inputData :  String
    private var inputDataArray = [String]() //seperate string into math components
    private var outputData = [String]() //reverse polish notation in array
    
    init(withData data : String) { //intialize with string
        inputData = data
    }

    private func seperateInputData(){ //function seperate inputData into math components
        for charachter in inputData.characters {
            if isOperation(at: String(charachter)) {
                inputDataArray.append(String(charachter))
            } else if isValue(at: String(charachter)){ //determine if last charachter is number, 
                if inputDataArray.count == 0 {         // if true add next charachter to the same string
                    inputDataArray.append(String(charachter))
                } else if isValue(at: inputDataArray[inputDataArray.count - 1])  {
                    inputDataArray[inputDataArray.count - 1] += String(charachter)
                } else {
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
        
    }
    private func priorityFor(char:String) -> Int{ //determine priority
        if char == "+" || char == "-" {
            return 1
        } else if (char == "^") {
            return 3
        } else if char == "s" {
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
        if char >= "0" && char <= "9" {
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
        if char=="sin" || char=="cos" || char=="tg" || char=="ctg" {
            return true
        }
        return false
    }
    
    private func isOperationDM(at char: String) -> Bool{ //determine if math operator
        
        if char=="+" || char=="/" || char=="*" || char=="-" || char == "^" || char == "sin" || char == "cos" || char == "tg" || char == "ctg" {
            return true
        }
        return false
    }
    func CalculateRPN() -> Double { //calculate RPN and return result of expression
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
                stack.append(leftValue / rightValue)
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
            default:
                stack.append(Double(value)!)
            }
             print(stack)
        }
        return stack[stack.count-1]
    }
}
