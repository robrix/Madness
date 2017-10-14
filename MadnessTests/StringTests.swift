//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class StringTests: XCTestCase {
	func testSimpleIntegers() {
		assertNumber("1")
		assertNumber("45")
		assertNumber("-13")
	}

	func testSimpleFloats() {
		assertNumber("1.0")
		assertNumber("45.3")
		assertNumber("-2.53")
	}

	func testIntegerUnsignedExponents() {
		assertNumber("2E1")
		assertNumber("1e2")
		assertNumber("0e3")
		assertNumber("-1e4")
		assertNumber("-2E5")
		assertNumber("1e21")
	}

	func testIntegerSignedExponents() {
		assertNumber("8e+1")
		assertNumber("7e-2")
		assertNumber("6E+3")
		assertNumber("5E-4")
		assertNumber("-4e+5")
		assertNumber("-3e-6")
		assertNumber("-2E+7")
		assertNumber("-1E-8")
	}

	func testFloatUnsignedExponents() {
		assertNumber("1.2e1")
		assertNumber("4.567E2")
		assertNumber("1.0e4")
		assertNumber("-6.21e3")
		assertNumber("-1.5E2")
	}

	func testFloatSignedExponents() {
		assertNumber("1.4e+5")
		assertNumber("2.5e-6")
		assertNumber("3.6E+7")
		assertNumber("4.7E-8")
		assertNumber("-5.8E-9")
	}
}

func assertNumber(_ input: String, message: String = "", file: StaticString = #file, line: UInt = #line) {
	return XCTAssertEqual(parse(number, input: input).value, Double(input)!, message, file: file, line: line)
}

// MARK: - Imports

import Madness
import XCTest
