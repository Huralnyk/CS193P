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
        XCTAssertEqual(sut.description, "7 +")
        XCTAssertTrue(sut.resultIsPending)
        
        // 7 + 9 = would show “7 + 9 =” (16 in the display)
        sut.setOperand(9)
        sut.performOperation("=")
        XCTAssertEqual(sut.description, "7 + 9")
        XCTAssertFalse(sut.resultIsPending)
        
        // 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
        sut.performOperation("√")
        XCTAssertEqual(sut.description, "√(7 + 9)")
        XCTAssertFalse(sut.resultIsPending)
        
        // 7 + 9 = √ + 2 = would show “√(7 + 9) + 2 =” (6 in the display)
        sut.performOperation("+")
        sut.setOperand(2)
        sut.performOperation("=")
        XCTAssertEqual(sut.description, "√(7 + 9) + 2")
        XCTAssertFalse(sut.resultIsPending)
    }
    
    func test_Description_DisplaysCorrectData2() {
        // 7 + 9 √ would show “7 + √(9) ...” (3 in the display)
        sut.setOperand(7)
        sut.performOperation("+")
        sut.setOperand(9)
        sut.performOperation("√")
        XCTAssertEqual(sut.description, "7 + √(9)")
        XCTAssertTrue(sut.resultIsPending)
        
        // 7 + 9 √ = would show “7 + √(9) =“ (10 in the display)
        sut.performOperation("=")
        XCTAssertEqual(sut.description, "7 + √(9)")
        XCTAssertFalse(sut.resultIsPending)
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
        XCTAssertEqual(sut.description, "7 + 9 + 6 + 3")
        XCTAssertFalse(sut.resultIsPending)
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
        XCTAssertEqual(sut.description, "6 + 3")
        XCTAssertFalse(sut.resultIsPending)
    }
    
    func test_Description_DisplaysCorrectData5() {
        // 4 × π = would show “4 × π =“ (12.5663706143592 in the display)
        sut.setOperand(4)
        sut.performOperation("×")
        sut.performOperation("π")
        sut.performOperation("=")
        XCTAssertEqual(sut.description, "4 × π")
        XCTAssertFalse(sut.resultIsPending)
    }
    
}
