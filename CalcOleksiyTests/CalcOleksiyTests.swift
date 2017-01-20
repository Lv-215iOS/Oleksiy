//
//  CalcOleksiyTests.swift
//  CalcOleksiyTests
//
//  Created by adminaccount on 12/7/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import XCTest
@testable import CalcOleksiy

class CalcOleksiyTests: XCTestCase {
    
    var brain : CalcModel? = nil
    
    override func setUp() {
        super.setUp()
        brain = CalcModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        brain = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// 4 * 2 = 8.0
    func test4Mul2() {
        brain?.digit(value: 4)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 2)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = Double(value!)
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 8)
    }
    
    /// 4 * 0.2 = 0.8
    func test4Mul0dot2() {
        brain?.digit(value: 4)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 2)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = Double(value!)
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 0.8)
    }
    
    /// 4.2 * 0.2 = 0.84
    func test4Dot2Mul0dot2() {
        brain?.digit(value: 4)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 2)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 2)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 0.84)
    }
    
    /// 0.4 * 0.2 = 0.08
    func test0dot4Mul0dot2() {
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 4)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 2)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 0.08)
    }
    
    /// 4 * 5 * 5 = 100
    func test4Mul5Mul5() {
        brain?.digit(value: 4)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 5)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 5)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = Double(value!)
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 100)
    }
    
    /// 0.4 * 0.6 * 0.5 = 0.12
    func test0Dot4Mul0Dot6Mul0Dot5() {
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 4)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 6)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 5)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = Double(value!)
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 0.12)
    }
    
    /// nan * 5 = nan
    func testNanMul5() {
        brain?.digit(value: .nan)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 5)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert((result?.isNaN)!)
    }
    
    /// inf * 5 = inf
    func testInfMul5() {
        brain?.digit(value: .infinity)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 5)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert((result?.isInfinite)!)
    }

    /// 4 * 5 * 5 * 5 = 600
    func test4Mul5Mul5Mul5() {
        brain?.digit(value: 4)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 5)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 5)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 6)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = Double(value!)
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 600)
    }
    
    /// 0.4 * 0.6 * 0.7 * 0.8 = 0.1344
    func test0Dot4Mul0Dot6Mul0Dot7Mul0Dot8() {
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 4)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 6)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 7)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 0)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 8)
        
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = Double(value!)
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 0.1344)
    }
    
    /// 1 / (intMax + 10) * intMax = 1
    func test1DivIntMaxMulIntMax() {
        brain?.digit(value: 1)
        brain?.binary(operation: .Div)
        brain?.digit(value: (Double(Int.max) + 10))
        brain?.binary(operation: .Mul)
        brain?.digit(value: Double(Int.max) + 10)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 1)
    }
    
    /// 1 / (intMin + 10) * intMin = 1
    func test1DivIntMinMulIntMin() {
        brain?.digit(value: 1)
         brain?.binary(operation: .Div)
        brain?.digit(value: (Double(Int.min) + 10))
        brain?.binary(operation: .Mul)
        brain?.digit(value: Double(Int.min) + 10)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 1)
    }
    
    /// 10 * * 10 = 100
    func test10MulMul10() {
        brain?.digit(value: 10)
        brain?.binary(operation: .Mul)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 10)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 100)
    }
    
    /// 10 * -10 = -100
    func test10MulMinus10() {
        brain?.digit(value: 10)
        brain?.binary(operation: .Mul)
        brain?.digit(value: -10)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == -100)
    }
    
    /// 10..10 * 10 = 101
    func test10DotDot10Mul10() {
        brain?.digit(value: 10)
        brain?.utility(operation: .Dot)
        brain?.utility(operation: .Dot)
        brain?.digit(value: 1)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 10)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == -101)
    }
    
    /// 10 * 6 = = 60
    func test10Mul6EqualEqual() {
        brain?.digit(value: 10)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 6)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        brain?.utility(operation: .Equal)
        XCTAssert(result == 60)
    }
    
    /// 10 * 6 / 5 + 7 - 3 = 16
    func test10Mul6Div5Plus7Minus3() {
        brain?.digit(value: 10)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 6)
        brain?.binary(operation: .Div)
        brain?.digit(value: 5)
        brain?.binary(operation: .Plus)
        brain?.digit(value: 7)
        brain?.binary(operation: .Minus)
        brain?.digit(value: 3)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == 16)
    }
    
    /// 10 / 2 * 5 + 7 - 35 = -3
    func test10Div2Mul5Plus7Minus30() {
        brain?.digit(value: 10)
        brain?.binary(operation: .Div)
        brain?.digit(value: 2)
        brain?.binary(operation: .Mul)
        brain?.digit(value: 5)
        brain?.binary(operation: .Plus)
        brain?.digit(value: 7)
        brain?.binary(operation: .Minus)
        brain?.digit(value: 35)
        var result: Double? = nil
        brain?.result = { (value,error) ->() in
            result = value
        }
        brain?.utility(operation: .Equal)
        XCTAssert(result == -3)
    }

    //--------------------------------------------------------
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
