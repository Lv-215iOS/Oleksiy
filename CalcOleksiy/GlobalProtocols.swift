//
//  GlobalProtocols.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/27/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

enum BinaryOperation : String{
    case Plus = "+"
    case Minus = "-"
    case Mul = "*"
    case Div = "/"
    case Power = " ̂"
    case Mod = "%"
}

enum UtilityOperation : String{
    case RightBracket = ")"
    case LeftBracket = "("
    case Dot = "."
    case Equal = "="
    case Clean = "C"
    case AClean = "AC"
    case MPlus = "M+"
    case MMinus = "M-"
    case MClear = "MC"
    case MRead = "MR"
}

enum UnaryOperation : String{
    case Percent = "%"
    case Sin = "sin"
    case Cos = "cos"
    case Tg = "tg"
    case Sinh = "sinh"
    case Cosh = "cosh"
    case Tgh = "tgh"
    case Ln = "ln"
    case Sqrt = "√"
    case PlusMinus = "+/-"
    case Ctg = "ctg"
    case Log = "log"
    case Ctgh = "ctgh"
    case Fact = "!"
}

protocol CalcBrainInterface {
    
    
    /** 
     inputs digit
     
     - Parameter value: digit
    */
    func digit(value: Double)
    
    
    /** 
     inputs binary operation
     
     - Parameter operation: binary operation
     */
    func binary(operation: BinaryOperation)
    
    
    /** 
     inputs unary operation
     
     - Parameter operation: unary operation
     */
    func unary(operation: UnaryOperation)
    
    
    /** 
     inputs utility operation
     
     - Parameter operation: utility operation
     */
    func utility(operation: UtilityOperation)
    
    
    /// callBack for result
    var result: ((Double?, Error?)->())? {get set}
}

protocol CalcBrainFunctionInterface {
    
    
    /** 
     Determines if expression is valid function
     
     - Returns: true if expression is valid function
     */
    func functionTest() -> Bool
    
    
    /// inputs x
    func xInput()
    
    
    /**
     Determines function result in variable
     
     - Parameter x: input value
     - Returns: function result in senders value
     */
    func functionIn(_ x:Double) -> Double
}

protocol OutputInterface {
    
    /**
     Outputs expression in appropriate label
     
     - Parameter info: expression
     */
    func outputInfo(info: String)
}

protocol AdvancedOutputInterface {
    
    
    /// Shakes main label with animation
    func shakeInfo()
    
    
    /**
     Outputs calculated expression in auxiliary label
     
     - Parameter info: calculated expression
     */
    func fillSecondLabel(str: String)
    
    
    /// Returns expression from main label
    func mainLabel () -> String
}

protocol InputInterface {
    
    /// CallBack, executes when input button is pressed
    var buttonDidPress: ((String, UIButton) -> ())? {get set}
}





