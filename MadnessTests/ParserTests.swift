//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Assertions
import Either
import Madness
import Prelude
import XCTest

final class ParserTests: XCTestCase {
	// MARK: - Operations

	func testParseRejectsPartialParses() {
		assertNil(parse(%"x", "xy"))
	}

	func testParseProducesParseTreesForFullParses() {
		assertEqual(parse(%"x", "x").right, "x")
	}


	// MARK: - Terminals

	// MARK: Literals

	func testLiteralParsersParseAPrefixOfTheInput() {
		let parser = %"foo"
		assertAdvancedBy(parser, "foot", 3)
		assertUnmatched(parser, "fo")
	}

	func testLiteralParsersProduceTheirArgument() {
		assertTree(%"foo", "foot", ==, "foo")
	}


	// MARK: Ranges

	let digits = %("0"..."9")

	func testRangeParsersParseAnyCharacterInTheirRange() {
		assertTree(digits, "0", ==, "0")
		assertTree(digits, "5", ==, "5")
		assertTree(digits, "9", ==, "9")
	}

	func testRangeParsersRejectCharactersOutsideTheRange() {
		assertUnmatched(digits, "a")
	}


	// MARK: Any

	func testAnyRejectsTheEmptyString() {
		assertUnmatched(any, "")
	}

	func testAnyParsesAnySingleCharacter() {
		assertTree(any, "🔥", ==, "🔥")
	}
}
