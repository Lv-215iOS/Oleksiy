//
//  CalcModel.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class CalcModel: NSObject {
    
    var inputData :  String
    var outputData = [String]()
    
    init(withData data : String) {
        inputData = data
    }

    func calculateData(){
        var stack : String = ""
        var token = false
        for symbol in inputData.characters {
            if !isOperation(at: symbol){
                if outputData.count == 0 {
                    token = true
                    outputData.append(String(symbol))
                } else if token {
                    token = true
                    outputData[outputData.count - 1] += String(symbol)
                } else {
                    token = true
                    outputData.append(String(symbol))
                }
            } else if isOperationDM(at: symbol){
                token = false
                if (stack.characters.last ==  "(") {
                    stack += String(symbol)
                } else if stack == "" {
                    stack += String(symbol)
                } else if priority(for: stack.characters.last!) < priority(for: symbol) {
                    stack += String(symbol)
                } else {
                    outputData.append(String(String(stack.characters.last!)))
                    stack  = stack.substring(to: stack.index(before: stack.endIndex))
                    stack  += String(symbol)
                }
            } else if symbol == "(" {
                token = false
                stack += String(symbol)
            } else if symbol == ")" {
                token = false
                var temp : String = ""
                for ch in stack.characters {
                    if ch != "(" {
                        temp += String(ch)
                    } else {
                        break
                    }
                }
                for lc in stack.characters.reversed() {
                    if lc != "(" {
                        outputData.append(String(lc))
                    } else {
                        break
                    }
                }
                stack = temp
            }
            print(outputData)
            print(stack)
                
        }
        for lb in stack.characters.reversed() {
            outputData.append(String(lb))
        }
        //outputData += String(stack.characters.reversed() )
        
    }
    
    func printInputData() {
        print(inputData)
    }
    
    func printOutputData() {
         print(outputData)
    }
    
    func priority (for char:Character) -> Int{
        if char == "+" || char == "-" {
            return 1
        }
        return 2
    }
    
    func isOperation (at char : Character) -> Bool{
        
        if char=="+" || char=="/" || char=="*" || char=="-" || char == "(" || char == ")"{
            return true
        }
        return false
    }
    
    func isOperationDM (at char : Character) -> Bool{
        
        if char=="+" || char=="/" || char=="*" || char=="-" {
            return true
        }
        return false
    }
    func CalculateRPN() -> Float{
        var stack =  [Float]()
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
            default:
                stack.append(Float(value)!)
            }
        }
        print(stack)
        return stack[stack.count-1]
    }
}
