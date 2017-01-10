//
//  CalcModel.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

class CalcModel: NSObject, CalcBrainInterface {
    ///singleton
    static let sharedModel = CalcModel()
    var inputData : String = (UserDefaults.standard.value(forKey: "last_result") ?? "") as! String
    private var plotInput = ""
    ///seperated string into math components
    private var inputDataArray = [String]()
    ///reverse polish notation in array
    private var outputData = [String]()
    private var openBracesCount = 0
    private var closedBracesCount = 0
    private var dotToken = true
    
    //MARK:- CalcBrainInterface
    func digit(value: Double){
        if inputData == "NaN" || inputData == "+∞" {
            result?(nil,nil)
        } else {
            if String(inputData.characters.last ?? " ") == "0" {
                let temp = inputData.remove(at: inputData.index(before: inputData.endIndex))
                if (String(inputData.characters.last ?? " ") == "." || isValue(String(inputData.characters.last ?? "-"))) && inputData != "0" {
                    inputData += String(temp)
                }
            }
            if value.truncatingRemainder(dividingBy: 1) != 0 {
                dotToken = false
                if isValue(String(inputData.characters.last ?? "-")) {
                    result?(nil,nil)
                } else {
                    inputData += String(format:"%.5f", value)
                }
            } else {
                if String(inputData.characters.last ?? "-") == "x" {
                    result?(nil,nil)
                } else {
                    inputData += String(Int(value))
                }
            }
            result?(inputData, nil)
        }
    }
    
    func binary(operation: BinaryOperation) {
        dotToken = true
        if inputData == "NaN" || inputData == "+∞" {
            result?(nil,nil)
        } else if operation == .Minus {
            if String(inputData.characters.last ?? " ") == "+" {
                inputData.remove(at: inputData.index(before: inputData.endIndex))
                inputData += "-"
                result?(inputData, nil)
            } else if ["n","s","g","h","√"].contains(String(inputData.characters.last ?? " ")) {
                inputData += "("
                openBracesCount += 1
                inputData += "-"
                result?(inputData, nil)
            } else if String(inputData.characters.last ?? " ") == ")" || Int(String(inputData.characters.last ?? " ")) != nil {
                if inputData == "0" {
                    inputData = operation.rawValue + "0"
                } else {
                    inputData += operation.rawValue
                }
                result?(inputData, nil)
            } else if String(inputData.characters.last ?? " ") == "-" || String(inputData.characters.last ?? " ") == "." {
                result?(nil, nil)
            } else {
                inputData += "-"
                result?(inputData, nil)

            }
        } else if Int(String(inputData.characters.last ?? " ")) != nil || String(inputData.characters.last ?? " ") == ")" {
            inputData += operation.rawValue
            result?(inputData, nil)
        } else {
            if isOperation(String(inputData.characters.last ?? " ")) && !isTrigonomenry(String(inputData.characters.last ?? " ")) {
                let deletedElement = inputData.remove(at: inputData.index(before: inputData.endIndex))
                if String(inputData.characters.last ?? " ") == "(" ||
                    String(deletedElement) == operation.rawValue ||
                    inputData == "" ||
                   (isOperation(String(inputData.characters.last ?? " ")) &&
                   !isTrigonomenry(String(inputData.characters.last ?? " "))) {
                    inputData += String(deletedElement)
                    result?(nil, nil)
                } else {
                    inputData += operation.rawValue
                    result?(inputData, nil)
                }
            } else {
                if String(inputData.characters.last ?? " ") == "x" {
                    inputData += operation.rawValue
                    result?(inputData, nil)
                } else {
                    result?(nil, nil)

                }
            }
        }
    }
    
    func unary(operation: UnaryOperation){
        dotToken = true
        if inputData == "NaN" || inputData == "+∞" {
            result?(nil,nil)
        } else if String(inputData.characters.last ?? " ") == "." ||
           String(inputData.characters.last ?? " ") == "x" ||
           String(inputData.characters.last ?? " ") == ")" ||
           Int(String(inputData.characters.last ?? " ")) != nil && inputData != "0" && inputData != "-0" {
            result?(nil, nil)
        } else {
            if ["n","s","g","h","√"].contains(String(inputData.characters.last ?? " ")) {
                inputData += "("
                openBracesCount += 1
                inputData += operation.rawValue
                result?(inputData, nil)
            } else if inputData == "0" || inputData == "-0" {
                inputData.remove(at: inputData.index(before: inputData.endIndex))
                if inputData == "-" {
                    inputData += "("
                    openBracesCount += 1
                }
                inputData += operation.rawValue
                result?(inputData, nil)
            } else {
                let removedSymbol = inputData.remove(at: inputData.index(before: inputData.endIndex))
                if inputData == "" && removedSymbol == "-" {
                    inputData += String(removedSymbol)
                    inputData += "("
                    openBracesCount += 1
                    inputData += operation.rawValue
                    result?(inputData, nil)
                } else if ["/","*","%","("," ̂"].contains(String(inputData.characters.last ?? " ")) && removedSymbol == "-" {
                    inputData += String(removedSymbol)
                    inputData += "("
                    openBracesCount += 1
                    inputData += operation.rawValue
                    result?(inputData, nil)
                } else {
                    inputData += String(removedSymbol)
                    inputData += operation.rawValue
                    result?(inputData, nil)
                }
            }
        }
    }
    
    func utility(operation: UtilityOperation){
         if operation == .Equal {
            if (Int(String(inputData.characters.last ?? " ")) != nil ||
                String(inputData.characters.last ?? " ") == ")" ) && openBracesCount == closedBracesCount {
                if Double(inputData)?.truncatingRemainder(dividingBy: 1) == 0 {
                    dotToken = true
                }
                let result1 = CalculateRPN()
                print(result1)
                if result1.truncatingRemainder(dividingBy:1) == 0 {
                    if result1 > Double(Int.max) || result1 < Double(Int.min) {
                        inputData = "\(result1)"
                    } else {
                        inputData = "\(Int(result1))"
                    }
                } else {
                    let formatter = NumberFormatter()
                    formatter.minimumIntegerDigits = 1
                    formatter.minimumFractionDigits = 0
                    formatter.maximumFractionDigits = 5
                    //let truncatedResult = String(format: "%.6g", result1)
                    inputData = formatter.string(from: NSNumber(value: result1))!
                }
                inputDataArray = [String]()
                outputData = [String]()
                if result1.isNaN || result1.isInfinite {
                    result?("Error",nil)
                } else {
                    result?(inputData,nil)
                }
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
                if removedSymbol == "s" || removedSymbol == "N" {
                    inputData.remove(at: inputData.index(before: inputData.endIndex))
                    inputData.remove(at: inputData.index(before: inputData.endIndex))
                } else if removedSymbol == "h" {
                    if inputData.remove(at: inputData.index(before: inputData.endIndex)) == "g" {
                        inputData.remove(at: inputData.index(before: inputData.endIndex))
                    } else {
                        inputData.remove(at: inputData.index(before: inputData.endIndex))
                        inputData.remove(at: inputData.index(before: inputData.endIndex))
                    }
                } else if removedSymbol == "n" {
                    if inputData.remove(at: inputData.index(before: inputData.endIndex)) == "i" {
                        inputData.remove(at: inputData.index(before: inputData.endIndex))
                    }
                } else if removedSymbol == "g" || removedSymbol == "∞"{
                    inputData.remove(at: inputData.index(before: inputData.endIndex))
                }
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
        } else if inputData == "NaN" || inputData == "+∞" {
            result?(nil,nil)
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
                if closedBracesCount != openBracesCount && (closedBracesCount != 0 || Int(String(inputData.characters.last ?? " ")) != nil || String(inputData.characters.last ?? " ") == "x") {
                    closedBracesCount += 1
                    inputData += operation.rawValue
                    result?(inputData, nil)
                } else {
                    result?(nil,nil)
                }
            } else if operation == .LeftBracket {
                if ( ["n","s","g","h"].contains(String(inputData.characters.last ?? " ")) || isMathSymbol(String(inputData.characters.last ?? " ")) || inputData == "0" || inputData == "-0") && String(inputData.characters.last ?? " ") != ")" {
                    if String(inputData.characters.last ?? " ") == "0" {
                        inputData.remove(at: inputData.index(before: inputData.endIndex))
                    }
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
    /// return true if inputdata is validate data for drawing plot, otherwise return false
    func functionTest() -> Bool {
        if (Int(String(inputData.characters.last ?? " ")) != nil ||
            String(inputData.characters.last ?? " ") == "x" ||
            String(inputData.characters.last ?? " ") == ")" ) && openBracesCount == closedBracesCount {
            if Double(inputData)?.truncatingRemainder(dividingBy: 1) == 0 {
                dotToken = true
            }
            return true
        } else {
            return false
        }
    }
    
    func XInput() {
        dotToken = false
        if inputData == "NaN" || inputData == "+∞" {
            result?(nil,nil)
        } else if (Int(String(inputData.characters.last ?? " ")) != nil  && inputData != "0" ) ||  String(inputData.characters.last ?? " ") == ")" || String(inputData.characters.last ?? " ") == "x" || String(inputData.characters.last ?? " ") == "." {
            result?(nil,nil)
        } else {
            if inputData == "0" {
                inputData = "x"
            } else {
                inputData += "x"
            }
            result?(inputData, nil)
        }
    }
    
    /// return function in current x
    func plotFunctionIn(_ x:Double) -> Double {
        let regex = try! NSRegularExpression(pattern: "x", options: .useUnixLineSeparators)
        let modInput = regex.stringByReplacingMatches(in: inputData, options: [], range: NSMakeRange(0, inputData.utf16.count), withTemplate: String(format:"%.10f", x))
        print("input |")
        print(inputData)
        print("modinput |")
        print(modInput)
        plotInput = inputData
        inputData = modInput
        let temp = CalculateRPN()
        inputDataArray = [String]()
        outputData = [String]()
        inputData = plotInput
        print("input |")
        print(inputData)
        return temp
    }
    
    ///seperate inputData into math components
    private func seperateInputData() {
        for charachter in inputData.characters {
            if isMathSymbol(String(charachter)) {
                if inputDataArray.count > 0 && inputDataArray[inputDataArray.count  - 1].characters.last == "e" {
                    inputDataArray[inputDataArray.count - 1] += String(charachter)
                }  else if inputDataArray.count > 0 && inputDataArray[inputDataArray.count - 1] == "-" && charachter == "-" {
                    if inputDataArray.count > 1 {
                        if isValue(inputDataArray[inputDataArray.count - 2]) || inputDataArray[inputDataArray.count - 2] == ")" {
                            inputDataArray.removeLast()
                            inputDataArray.append("+")
                        } else {
                            inputDataArray.removeLast()
                        }
                    } else {
                        inputDataArray.removeLast()
                    }
                } else if inputDataArray.count > 0 && inputDataArray[inputDataArray.count  - 1] == "-" {
                    inputDataArray[inputDataArray.count  - 1] = "+/-"
                    inputDataArray.append(String(charachter))
                } else {
                    inputDataArray.append(String(charachter))
                }
            } else if isValue(String(charachter)) {//determine if last charachter is number,
                if inputDataArray.count == 0 {// if true add next charachter to the same string
                    inputDataArray.append(String(charachter))
                } else if isValue(inputDataArray[inputDataArray.count - 1]) {
                    inputDataArray[inputDataArray.count - 1] += String(charachter)
                } else if (inputDataArray.count == 1 && inputDataArray[inputDataArray.count - 1] == "-"){
                    if ["s","c","t","l"].contains(charachter) {
                        inputDataArray[inputDataArray.count - 1] = "+/-"
                        inputDataArray.append(String(charachter))
                    } else {
                        inputDataArray[inputDataArray.count - 1] += String(charachter)
                    }
                } else if (inputDataArray.count > 1) && (isOperation(inputDataArray[inputDataArray.count - 2]) || isMathSymbol(inputDataArray[inputDataArray.count - 2])) && inputDataArray[inputDataArray.count - 1] == "-" {
                    if ["(","/","*","%"," ̂"].contains(inputDataArray[inputDataArray.count - 2]) && ["s","c","t","l"].contains(charachter) {
                        inputDataArray[inputDataArray.count - 1] = "+/-"
                        inputDataArray.append(String(charachter))
                    } else {
                        inputDataArray[inputDataArray.count - 1] += String(charachter)
                    }
                }else {
                    if charachter == "h" {
                        inputDataArray[inputDataArray.count - 1] += String(charachter)
                    } else {
                        if inputDataArray.count > 3 {
                            if inputDataArray[inputDataArray.count - 1].characters.last == "+" && inputDataArray[inputDataArray.count - 1].characters.count > 3 {
                                inputDataArray[inputDataArray.count - 1] += String(charachter)
                            }
                        }
                        inputDataArray.append(String(charachter))
                    }
                }
            } else if charachter == "." {
                inputDataArray[inputDataArray.count - 1] += String(charachter)
            } else if inputDataArray.count != 0 && !isTrigonomenry(inputDataArray[inputDataArray.count - 1]) && !isMathSymbol(inputDataArray[inputDataArray.count - 1]) {
                if inputDataArray[inputDataArray.count - 2] == "-" {
                    if inputDataArray.count == 2 {
                        inputDataArray[inputDataArray.count - 2] = "+/-"
                    } else if ["(","/","*","%"," ̂"].contains(inputDataArray[inputDataArray.count - 3]) && inputDataArray.count > 1 {
                        inputDataArray[inputDataArray.count - 2] = "+/-"
                    }
                }
                inputDataArray[inputDataArray.count - 1] += String(charachter)
                //if element of array is not fully written trigonometry func
            } else if charachter == "e" {
                inputDataArray[inputDataArray.count - 1] += String(charachter)
            } else {
                inputDataArray.append(String(charachter))
            }
        }
        print(inputDataArray)
    }
    
    ///calculate reverse polish notation
    private func calculateData(){
        ///stack for operators
        var stack = [String]()
        for symbol in inputDataArray{
            if !isMathSymbol(symbol){//if symbol is number
                outputData.append(String(symbol))
            } else if isOperation(String(symbol)){//if symbol is math operation
                if stack.count == 0 || symbol == "(" {//if stack empty or symbol = (, add symbol
                    stack.append(String(symbol))
                } else if precedenceBetweenOperators(first: stack.last!, second: symbol) &&  stack.last! != "(" {
                //if last operator has higher or same precedence, pop element from stack to outputdata and push symbol
                    var i = 0
                    for element in stack.reversed() {
                        if precedenceBetweenOperators(first: element, second: symbol) &&  element != "(" {
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
            } else if symbol == ")" {//pop all elements until (
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
    
    ///return priority of operator
    private func priorityFor(char:String) -> Int{
        if char == "+" || char == "-" {
            return 1
        } else if (char == " ̂") {
            return 3
        } else if isTrigonomenry(char) {
            return 4
        }
        return 2
    }
    
    ///return true if first operator precedence is higher or equal than precedence of second operator
    private func precedenceBetweenOperators(first:String, second:String) -> Bool {
        if priorityFor(char: first) >= priorityFor(char: second) {
            return true
        }
        return false
    }
    
    ///return true if string is value
    private func isValue(_ str: String) -> Bool{
        if !isOperation(str) && !isMathSymbol(str) {
             return true
        }
        return false
    }
    
    ///return true if string is math symbol
    private func isMathSymbol(_ str: String) -> Bool{
        
        if isOperation(str) || str == "(" || str == ")" {
            return true
        }
        return false
    }
    
    ///return true if string is trigonometry operation
    private func isTrigonomenry(_ str: String) -> Bool{
        if str=="sin" || str=="cos" || str=="tg" || str=="ln" || str=="√" || str=="sinh" || str=="cosh" || str=="tgh" || str=="+/-" {
            return true
        }
        return false
    }
    
    ///return true if string is operation
    private func isOperation(_ str: String) -> Bool{
        if str=="+" || str=="/" || str=="*" || str=="-" || str == " ̂" || str=="%" || str == "sin" || str == "cos" || str == "tg" || str=="ln" || str=="√" || str=="sinh" || str=="cosh" || str=="tgh" || str=="+/-" {
            return true
        }
        return false
    }
    
    /// calculate ReversePolishNotation and return result of expression
    private func CalculateRPN() -> Double {
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
            case "%":
                let rightValue = stack.removeLast()
                let leftValue = stack.removeLast()
                stack.append(leftValue.truncatingRemainder(dividingBy:rightValue))
            case " ̂":
                let rightValue = stack.removeLast()
                let leftValue = stack.removeLast()
                stack.append(pow(leftValue, rightValue))
            case "sin":
                let value = stack.removeLast()
                stack.append(sin(value))
            case "+/-":
                let value = stack.removeLast()
                stack.append(0-value)
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
        print(Double(stack[stack.count-1]))
        return stack[stack.count-1]	
    }
}
