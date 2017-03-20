//
//  CalculatorBrainTests.swift
//  Calculator
//
//  Created by Oleksii Huralnyk on 3/9/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorBrainTests: XCTestCase {
    
    var sut: CalculatorBrain!
    
    override func setUp() {
        super.setUp()
        sut = CalculatorBrain()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Description_DisplaysCorrectData1() {
        // touching 7 + would show “7 + ...” (with 7 still in the display)
        sut.setOperand(7)
        sut.performOperation("+")
        XCTAssertEqual(sut.evaluate().description, "7 +")
        XCTAssertTrue(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 7)
        
        // 7 + 9 = would show “7 + 9 =” (16 in the display)
        sut.setOperand(9)
        sut.performOperation("=")
        XCTAssertEqual(sut.evaluate().description, "7 + 9")
        XCTAssertFalse(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 16)
        
        // 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
        sut.performOperation("√")
        XCTAssertEqual(sut.evaluate().description, "√(7 + 9)")
        XCTAssertFalse(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 4)
        
        // 7 + 9 = √ + 2 = would show “√(7 + 9) + 2 =” (6 in the display)
        sut.performOperation("+")
        sut.setOperand(2)
        sut.performOperation("=")
        XCTAssertEqual(sut.evaluate().description, "√(7 + 9) + 2")
        XCTAssertFalse(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 6)
    }
    
    func test_Description_DisplaysCorrectData2() {
        // 7 + 9 √ would show “7 + √(9) ...” (3 in the display)
        sut.setOperand(7)
        sut.performOperation("+")
        sut.setOperand(9)
        sut.performOperation("√")
        XCTAssertEqual(sut.evaluate().description, "7 + √(9)")
        XCTAssertTrue(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 3)
        
        // 7 + 9 √ = would show “7 + √(9) =“ (10 in the display)
        sut.performOperation("=")
        XCTAssertEqual(sut.evaluate().description, "7 + √(9)")
        XCTAssertFalse(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 10)
    }
    
    func test_Description_DisplaysCorrectData3() {
        // 7 + 9 = + 6 = + 3 = would show “7 + 9 + 6 + 3 =” (25 in the display)
        sut.setOperand(7)
        sut.performOperation("+")
        sut.setOperand(9)
        sut.performOperation("=")
        sut.performOperation("+")
        sut.setOperand(6)
        sut.performOperation("=")
        sut.performOperation("+")
        sut.setOperand(3)
        sut.performOperation("=")
        XCTAssertEqual(sut.evaluate().description, "7 + 9 + 6 + 3")
        XCTAssertFalse(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 25)
    }
    
    func test_Description_DisplaysCorrectData4() {
        // 7 + 9 = √ 6 + 3 = would show “6 + 3 =” (9 in the display)
        sut.setOperand(7)
        sut.performOperation("+")
        sut.setOperand(9)
        sut.performOperation("=")
        sut.performOperation("√")
        sut.setOperand(6)
        sut.performOperation("+")
        sut.setOperand(3)
        sut.performOperation("=")
        XCTAssertEqual(sut.evaluate().description, "6 + 3")
        XCTAssertFalse(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 9)
    }
    
    func test_Description_DisplaysCorrectData5() {
        // 4 × π = would show “4 × π =“ (12.566370614359172 in the display)
        sut.setOperand(4)
        sut.performOperation("×")
        sut.performOperation("π")
        sut.performOperation("=")
        XCTAssertEqual(sut.evaluate().description, "4 × π")
        XCTAssertFalse(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 12.566370614359172)
    }
    
    func test_SettingVariables_AreWorking() {
        // 9 + M = √ ⇒ description is √(9 + M), display is 3 because M is not set (thus 0.0)
        sut.setOperand(9)
        sut.performOperation("+")
        sut.setOperand(variable: "M")
        sut.performOperation("=")
        sut.performOperation("√")
        XCTAssertEqual(sut.evaluate().description, "√(9 + M)")
        XCTAssertFalse(sut.evaluate().isPending)
        XCTAssertEqual(sut.evaluate().result, 3)
        // 7 →M ⇒ display now shows 4 (the square root of 16), description is still √(9 + M)
        XCTAssertEqual(sut.evaluate(using: ["M": 7]).description, "√(9 + M)")
        XCTAssertFalse(sut.evaluate(using: ["M": 7]).isPending)
        XCTAssertEqual(sut.evaluate(using: ["M": 7]).result, 4)
        // + 14 = ⇒ display now shows 18, description is now √(9+M)+14
        sut.performOperation("+")
        sut.setOperand(14)
        sut.performOperation("=")
        XCTAssertEqual(sut.evaluate(using: ["M": 7]).description, "√(9 + M) + 14")
        XCTAssertFalse(sut.evaluate(using: ["M": 7]).isPending)
        XCTAssertEqual(sut.evaluate(using: ["M": 7]).result, 18)
    }
}
