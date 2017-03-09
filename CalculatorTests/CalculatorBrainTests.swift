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
    
    func test_Description_DisplaysCorrectData() {
        // touching 7 + would show “7 + ...” (with 7 still in the display)
        sut.setOperand(7)
        sut.performOperation("+")
        XCTAssertEqual(sut.description, "7 + ...")
        // 7 + 9 would show “7 + ...” (9 in the display)
        XCTAssertEqual(sut.description, "7 + ...")
        // 7 + 9 = would show “7 + 9 =” (16 in the display)
        sut.setOperand(9)
        sut.performOperation("=")
        XCTAssertEqual(sut.description, "7 + 9 =")
        // 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
        sut.performOperation("√")
        XCTAssertEqual(sut.description, "√(7 + 9) =")
    }
    
}
