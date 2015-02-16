//  Copyright (c) 2014 Rob Rix. All rights reserved.

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

	// MARK: Concatenation

	let concatenation = %"x" ++ %"y"

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


	// MARK: Alternation

	let alternation = %"x" | (%"y" --> const(1))

	func testAlternationParsesEitherAlternative() {
		assertEqual(alternation("xy")?.1, "y")
		assertEqual(alternation("yx")?.1, "x")
	}

	func testAlternationProducesTheParsedAlternative() {
		assertEqual(alternation("xy")?.0, Either.left("x"))
	}

	func testAlternationOfASingleTypeCoalescesTheParsedValue() {
		assertEqual((%"x" | %"y")("xy")?.0, "x")
	}


	// MARK: Repetition

	let zeroOrMore = (%"x")*

	func testZeroOrMoreRepetitionAcceptsTheEmptyString() {
		assertNotNil(zeroOrMore(""))
	}

	func testZeroOrMoreRepetitionAcceptsUnmatchedStrings() {
		assertNotNil(zeroOrMore("y"))
	}

	func testZeroOrMoreRepetitionDoesNotAdvanceWithUnmatchedStrings() {
		assertEqual(zeroOrMore("y")?.1, "y")
	}

	func testZeroOrMoreRepetitionParsesUnmatchedStringsAsEmptyArrays() {
		assertEqual(zeroOrMore("y")?.0, [])
	}

	func testZeroOrMoreRepetitionParsesAMatchedString() {
		assertEqual(zeroOrMore("x")?.0, ["x"])
	}

	func testZeroOrMoreRepetitionParsesMatchedStrings() {
		assertEqual(zeroOrMore("xx")?.0, ["x", "x"])
	}


	let oneOrMore = (%"x")+

	func testOneOrMoreRepetitionRejectsTheEmptyString() {
		assertNil(oneOrMore(""))
	}

	func testOneOrMoreRepetitionParsesASingleMatchedString() {
		assertEqual(oneOrMore("x")?.0, ["x"])
	}

	func testOneOrMoreRepetitonParsesMultipleMatchedStrings() {
		assertEqual(oneOrMore("xxy")?.0, ["x", "x"])
	}


	let exactlyN = %"x" * 3

	func testExactlyNRepetitionParsesNTrees() {
		assertEqual(exactlyN("xxx")?.0, ["x", "x", "x"])
	}

	func testExactlyNRepetitionParsesRejectsFewerMatches() {
		assertNil(exactlyN("xx"))
	}

	func testExactlyNRepetitionParsesStopsAtN() {
		assertEqual(exactlyN("xxxx")?.1, "x")
	}


	let zeroToN = %"x" * (0..<2)

	func testZeroToNRepetitionParsesZeroTrees() {
		assertEqual(zeroToN("y")?.0, [])
	}

	func testZeroToNRepetitionParsesUpToButNotIncludingNTrees() {
		assertEqual(zeroToN("xxx")?.0, ["x"])
		assertEqual(zeroToN("xxx")?.1, "xx")
	}


	let atLeastN = %"x" * (2..<Int.max)

	func testAtLeastNRepetitionRejectsZeroTrees() {
		assertNil(atLeastN("y"))
	}

	func testAtLeastNRepetitionParsesNTrees() {
		assertEqual(atLeastN("xx")?.0, ["x", "x"])
	}

	func testAtLeastNRepetitionParsesMoreThanNTrees() {
		assertEqual(atLeastN("xxxx")?.0, ["x", "x", "x", "x"])
	}


	let mToN = %"x" * (2..<3)

	func testMToNRepetitionRejectsLessThanM() {
		assertNil(mToN("x"))
	}

	func testMToNRepetitionMatchesUpToButNotIncludingN() {
		assertEqual(mToN("xxxx")?.1, "xx")
	}
	
	
	let nToN = %"x" * (2..<2)
	
	func testOpenNToNRepetitionRejectsN() {
		assertNil(nToN("xx"))
	}

	
	
	let zeroToNClosed = %"x" * (0...2)
	
	func testZeroToNClosedRepetitionParsesZeroTrees() {
		assertEqual(zeroToNClosed("y")?.0, [])
	}
	
	func testZeroToNClosedRepetitionParsesUpToNTrees() {
		assertEqual(zeroToNClosed("xxx")?.0, ["x", "x"])
		assertEqual(zeroToNClosed("xxx")?.1, "x")
	}
	
	
	let atLeastNClosed = %"x" * (2...Int.max)
	
	func testAtLeastNClosedRepetitionRejectsZeroTrees() {
		assertNil(atLeastNClosed("y"))
	}
	
	func testAtLeastNClosedRepetitionParsesNTrees() {
		assertEqual(atLeastNClosed("xx")?.0, ["x", "x"])
	}
	
	func testAtLeastNClosedRepetitionParsesMoreThanNTrees() {
		assertEqual(atLeastNClosed("xxxx")?.0, ["x", "x", "x", "x"])
	}
	
	
	let mToNClosed = %"x" * (2...3)
	
	func testMToNClosedRepetitionRejectsLessThanM() {
		assertNil(mToNClosed("x"))
	}
	
	func testMToNClosedRepetitionMatchesUpToN() {
		assertEqual(mToNClosed("xxxx")?.1, "x")
	}
	
	
	let closedNToN = %"x" * (2...2)
	
	func testClosedNToNRepetitionMatchesUpToN() {
		assertEqual(closedNToN("xxx")?.1, "x")
	}
	

	// MARK: Ignoring

	let ignored = ignore("x")

	func testIgnoredInputDoesNotGetConcatenatedAtLeft() {
		assertEqual((ignored ++ %"y")("xy")?.0, "y")
	}

	func testIgnoredInputDoesNotGetConcatenatedAtRight() {
		assertEqual((%"y" ++ ignored)("yx")?.0, "y")
	}

	func testIgnoringDistributesOverConcatenation() {
		assertEqual((ignored ++ ignored)("xx")?.1, "")
	}

	func testIgnoredInputIsDroppedFromAlternationsAtLeft() {
		assertEqual((ignored | %"y")("y")?.0, "y")
	}

	func testIgnoredInputIsDroppedFromAlternationsAtRight() {
		assertEqual((%"y" | ignored)("y")?.0, "y")
	}

	func testIgnoringDistributesOverAlternation() {
		assertEqual((ignored | ignored)("x")?.0, ())
	}

	func testRepeatedIgnoredEmptyParsesAreDropped() {
		assertEqual((ignored* ++ %"y")("y")?.0, "y")
	}

	func testRepeatedIgnoredParsesAreDropped() {
		assertEqual((ignored* ++ %"y")("xxy")?.0, "y")
	}
}
