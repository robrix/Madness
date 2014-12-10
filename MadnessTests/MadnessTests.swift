//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Either
import Madness
import XCTest

final class MadnessTests: XCTestCase {
	// MARK: Assertions

	func assertEqual<T: Equatable>(expression1: @autoclosure () -> T?, _ expression2: @autoclosure () -> T?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) {
		let (actual, expected) = (expression1(), expression2())
		if actual != expected { XCTFail("\(actual) is not equal to \(expected). " + message, file: file, line: line) }
	}

	func assertEqual<T: Equatable, U: Equatable>(expression1: @autoclosure () -> Either<T, U>?, _ expression2: @autoclosure () -> Either<T, U>?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) {
		let (actual, expected) = (expression1(), expression2())
		switch (actual, expected) {
		case (.None, .None):
			break
		case let (.Some(x), .Some(y)) where x == y:
			break
		default:
			XCTFail("\(actual) is not equal to \(expected). " + message, file: file, line: line)
		}
	}

	func assertNil<T>(expression: @autoclosure () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
		let actual = expression()
		if actual != nil { XCTFail("\(actual) is not nil. " + message, file: file, line: line) }
	}

	func assertNotNil<T>(expression: @autoclosure () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
		let actual = expression()
		if actual == nil { XCTFail("\(actual) is nil. " + message, file: file, line: line) }
	}


	// MARK: Terminals

	func testLiteralParsersParseAPrefixOfTheInput() {
		assertEqual(literal("foo")("foot")?.1, "t")
		assertNil(literal("foo")("fo"))
		assertNil(literal("foo")("fo"))
	}

	func testLiteralParsersProduceTheirArgument() {
		assertEqual(literal("foo")("foot")?.0, "foo")
	}


	// MARK: Nonterminals

	let concatenation = literal("x") ++ literal("y")

	func testConcatenationRejectsPartialParses() {
		assertNil(concatenation("x"))
	}

	func testConcatenationParsesBothOperands() {
		assertEqual(concatenation("xyz")?.1, "z")
	}

	func testConcatenationProducesPairsOfTerms() {
		let parsed = concatenation("xy")
		assertEqual(parsed?.0.0, "x")
		assertEqual(parsed?.0.1, "y")
	}
}
