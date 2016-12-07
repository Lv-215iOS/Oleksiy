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
    var outputData :String = ""
    
    init(withData data : String) {
        inputData = data
    }

    func calculateData(){
        var stack : String = ""
        for symbol in inputData.characters {
            if !isOperation(at: symbol){
                outputData += String(symbol)
            } else if isOperationDM(at: symbol){
                outputData += ","
                if (stack.characters.last ==  "(") {
                    stack += String(symbol)
                } else if stack == "" {
                    stack += String(symbol)
                } else if priority(for: stack.characters.last!) < priority(for: symbol) {
                    stack += String(symbol)
                } else {
                    outputData += String(stack.characters.last!)
                    stack  = stack.substring(to: stack.index(before: stack.endIndex))
                    stack  += String(symbol)
                }
            } else if symbol == "(" {
                stack += String(symbol)
            } else if symbol == ")" {
                var temp : String = ""
                for ch in stack.characters {
                    if ch != "(" {
                        outputData += ","
                        temp += String(ch)
                    } else {
                        break
                    }
                }
                for lc in stack.characters.reversed() {
                    if lc != "(" {
                        outputData += ","
                        outputData += String(lc)
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
            outputData += ","
            outputData += String(lb)
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

}
