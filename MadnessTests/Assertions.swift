//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Either
import Prelude
import XCTest

extension XCTestCase {
	func assertEqual<T: Equatable>(expression1: @autoclosure () -> T?, _ expression2: @autoclosure () -> T?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> Bool {
		let (actual, expected) = (expression1(), expression2())
		return actual == expected || failure("\(actual) is not equal to \(expected). " + message, file: file, line: line)
	}

	func assertEqual<T: Equatable, U: Equatable>(expression1: @autoclosure () -> Either<T, U>?, _ expression2: @autoclosure () -> Either<T, U>?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> Bool {
		let (actual, expected) = (expression1(), expression2())
		switch (actual, expected) {
		case (.None, .None):
			return true
		case let (.Some(x), .Some(y)) where x == y:
			return true
		default:
			return failure("\(actual) is not equal to \(expected). " + message, file: file, line: line)
		}
	}

	func assertEqual<T: Equatable>(expression1: @autoclosure () -> [T]?, _ expression2: @autoclosure () -> [T]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> Bool {
		let (actual, expected) = (expression1(), expression2())
		switch (actual, expected) {
		case (.None, .None):
			return true
		case let (.Some(x), .Some(y)) where x == y:
			return true
		default:
			return failure("\(actual) is not equal to \(expected). " + message, file: file, line: line)
		}
	}

	func assertEqual(expression1: @autoclosure () -> ()?, _ expected: ()?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) -> Bool {
		let actual: ()? = expression1()
		switch (actual, expected) {
		case (.None, .None), (.Some, .Some):
			return true
		default:
			return failure("\(actual) is not equal to \(expected). " + message, file: file, line: line)
		}
	}

	func assertNil<T>(expression: @autoclosure () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
		return expression().map { self.failure("\($0) is not nil. " + message, file: file, line: line) } ?? true
	}

	func assertNotNil<T>(expression: @autoclosure () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
		return expression().map(const(true)) ?? failure("is nil. " + message, file: file, line: line)
	}

	func failure(message: String, file: String = __FILE__, line: UInt = __LINE__) -> Bool {
		XCTFail(message, file: file, line: line)
		return false
	}
}
