//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Assertions
import Either
import Madness
import Prelude
import XCTest

final class ParserTests: XCTestCase {
	// MARK: - Operations

	func testParseRejectsPartialParses() {
		assertNil(parse(%("x".characters), input: "xy".characters).right)
	}

	func testParseProducesParseTreesForFullParses() {
		assertEqual(parse(%"x", input: "x").right, "x")
	}


	// MARK: - Terminals

	// MARK: Literals

	func testLiteralParsersParseAPrefixOfTheInput() {
		let parser = %"foo"
		assertAdvancedBy(parser, input: "foot".characters, offset: 3)
		assertUnmatched(parser, "fo".characters)
	}

	func testLiteralParsersProduceTheirArgument() {
		assertTree(%"foo", "foot".characters, ==, "foo")
	}


	// MARK: Ranges

	let digits = %("0"..."9")

	func testRangeParsersParseAnyCharacterInTheirRange() {
		assertTree(digits, "0".characters, ==, "0")
		assertTree(digits, "5".characters, ==, "5")
		assertTree(digits, "9".characters, ==, "9")
	}

	func testRangeParsersRejectCharactersOutsideTheRange() {
		assertUnmatched(digits, "a".characters)
	}


	// MARK: None

	func testNoneDoesNotConsumeItsInput() {
		assertTree(none() <|> %"a", "a", ==, "a")
	}

	func testNoneIsIdentityForAlternation() {
		typealias Parser = Madness.Parser<String, String>.Function
		let alternate: (Parser, Parser) -> Parser = { $0 <|> $1 }
		let parser = [%"a", %"b", %"c"].reduce(none(), combine: alternate)
		assertTree(parser, "a", ==, "a")
		assertTree(parser, "b", ==, "b")
		assertTree(parser, "c", ==, "c")
	}


	// MARK: Any

	func testAnyRejectsTheEmptyString() {
		assertUnmatched(any, "".characters)
	}

	func testAnyParsesAnySingleCharacter() {
		assertTree(any, "🔥".characters, ==, "🔥")
	}
}
