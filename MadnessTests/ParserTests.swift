//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Madness
import Result
import XCTest

final class ParserTests: XCTestCase {
	// MARK: - Operations

	func testParseRejectsPartialParses() {
		XCTAssertNil(parse(%("x".characters), input: "xy".characters).value)
	}

	func testParseProducesParseTreesForFullParses() {
		XCTAssertEqual(parse(%"x", input: "x").value, "x")
	}


	// MARK: - Terminals

	// MARK: Literals

	func testLiteralParsersParseAPrefixOfTheInput() {
		let parser = %"foo"
		assertAdvancedBy(parser, input: "foot".characters, lineOffset: 0, columnOffset: 3, offset: 3)
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
	
	// MARK: satisfy
	
	func testSatisfyIncrementsLinesOverNewlineCharacters() {
		let parser = any *> %"foo"
		assertAdvancedBy(parser, input: "\nfoot".characters, lineOffset: 1, columnOffset: 2, offset: 4)
	}
}
