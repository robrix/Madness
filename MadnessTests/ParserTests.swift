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
		assertEqual(parse(%"x", "x"), "x")
	}


	// MARK: - Terminals

	// MARK: Literals

	func testLiteralParsersParseAPrefixOfTheInput() {
		let parser = %"foo"
		assertEqual(parser("foot")?.1, "t")
		assertNil(parser("fo"))
		assertNil(parser("fo"))
	}

	func testLiteralParsersProduceTheirArgument() {
		assertEqual((%"foo")("foot")?.0, "foo")
	}


	// MARK: Ranges

	let digits = %("0"..."9")

	func testRangeParsersParseAnyCharacterInTheirRange() {
		assertEqual(digits("0")?.0, "0")
		assertEqual(digits("5")?.0, "5")
		assertEqual(digits("9")?.0, "9")
	}

	func testRangeParsersRejectCharactersOutsideTheRange() {
		assertNil(digits("a"))
	}


	// MARK: Any

	func testAnyRejectsTheEmptyString() {
		assertNil(any(""))
	}

	func testAnyParsesAnySingleCharacter() {
		assertEqual(any("🔥")?.0, "🔥")
	}


	// MARK: - Nonterminals

	// MARK: Ignoring

	let ignored = ignore("x")

	func testIgnoredInputDoesNotGetConcatenatedAtLeft() {
		assertEqual((ignored ++ %"y")("xy")?.0, "y")
	}

	func testIgnoredInputDoesNotGetConcatenatedAtRight() {
		assertEqual((%"y" ++ ignored)("yx")?.0, "y")
	}

	func testIgnoringDistributesOverConcatenation() {
		let parser = (ignored ++ ignored)("xx")
		assertEqual(parser?.1, "")
	}

	func testIgnoredInputIsDroppedFromAlternationsAtLeft() {
		assertEqual((ignored | %"y")("y")?.0 ?? "", "y")
	}

	func testIgnoredInputIsDroppedFromAlternationsAtRight() {
		assertEqual((%"y" | ignored)("y")?.0 ?? "", "y")
	}

	func testIgnoringDistributesOverAlternation() {
		let parser = (ignored | ignored)
		assertNotNil(parser("x")?.0)
	}

	func testRepeatedIgnoredEmptyParsesAreDropped() {
		assertEqual((ignored* ++ %"y")("y")?.0, "y")
	}

	func testRepeatedIgnoredParsesAreDropped() {
		assertEqual((ignored* ++ %"y")("xxy")?.0, "y")
	}
}
