//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Madness
import XCTest

final class MadnessTests: XCTestCase {
	func assertEqual<T: Equatable>(expression1: @autoclosure () -> T?, _ expression2: @autoclosure () -> T?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) {
		let (actual, expected) = (expression1(), expression2())
		if actual != expected { XCTFail("\(actual) is not equal to \(expected). " + message, file: file, line: line) }
	}

	func testLiteralParsersParseAPrefixOfTheInput() {
		assertEqual(literal("foo")("foot")?.1, "t")
	}
}
