//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class RepetitionTests: XCTestCase {
	let zeroOrMore: Parser<String, [String]>.Function = (%"x")*

	func testZeroOrMoreRepetitionAcceptsTheEmptyString() {
		assertMatched(zeroOrMore, "")
	}

	func testZeroOrMoreRepetitionAcceptsUnmatchedStrings() {
		assertMatched(zeroOrMore, "y")
	}

	func testZeroOrMoreRepetitionDoesNotAdvanceWithUnmatchedStrings() {
		assertAdvancedBy(zeroOrMore, "y", 0)
	}

	func testZeroOrMoreRepetitionParsesUnmatchedStringsAsEmptyArrays() {
		assertTree(zeroOrMore, "y", ==, [])
	}

	func testZeroOrMoreRepetitionParsesAMatchedString() {
		assertTree(zeroOrMore, "x", ==, ["x"])
	}

	func testZeroOrMoreRepetitionParsesMatchedStrings() {
		assertTree(zeroOrMore, "xx", ==, ["x", "x"])
	}


	let oneOrMore = (%"x")+

	func testOneOrMoreRepetitionRejectsTheEmptyString() {
		assertUnmatched(oneOrMore, "")
	}

	func testOneOrMoreRepetitionParsesASingleMatchedString() {
		assertTree(oneOrMore, "x", ==, ["x"])
	}

	func testOneOrMoreRepetitonParsesMultipleMatchedStrings() {
		assertTree(oneOrMore, "xxy", ==, ["x", "x"])
	}


	let exactlyN = %"x" * 3

	func testExactlyNRepetitionParsesNTrees() {
		assertTree(exactlyN, "xxx", ==, ["x", "x", "x"])
	}

	func testExactlyNRepetitionParsesRejectsFewerMatches() {
		assertUnmatched(exactlyN, "xx")
	}

	func testExactlyNRepetitionParsesStopsAtN() {
		assertAdvancedBy(exactlyN, "xxxx", 3)
	}


	let zeroToN = %"x" * (0..<2)

	func testZeroToNRepetitionParsesZeroTrees() {
		assertTree(zeroToN, "y", ==, [])
	}

	func testZeroToNRepetitionParsesUpToButNotIncludingNTrees() {
		assertTree(zeroToN, "xxx", ==, ["x"])
		assertAdvancedBy(zeroToN, "xxx", 1)
	}


	let atLeastN = %"x" * (2..<Int.max)

	func testAtLeastNRepetitionRejectsZeroTrees() {
		assertUnmatched(atLeastN, "y")
	}

	func testAtLeastNRepetitionParsesNTrees() {
		assertTree(atLeastN, "xx", ==, ["x", "x"])
	}

	func testAtLeastNRepetitionParsesMoreThanNTrees() {
		assertTree(atLeastN, "xxxx", ==, ["x", "x", "x", "x"])
	}


	let mToN = %"x" * (2..<3)

	func testMToNRepetitionRejectsLessThanM() {
		assertUnmatched(mToN, "x")
	}

	func testMToNRepetitionMatchesUpToButNotIncludingN() {
		assertAdvancedBy(mToN, "xxxx", 2)
	}


	let nToN = %"x" * (2..<2)

	func testOpenNToNRepetitionRejectsN() {
		assertUnmatched(nToN, "xx")
	}



	let zeroToNClosed = %"x" * (0...2)

	func testZeroToNClosedRepetitionParsesZeroTrees() {
		assertTree(zeroToNClosed, "y", ==, [])
	}

	func testZeroToNClosedRepetitionParsesUpToNTrees() {
		assertTree(zeroToNClosed, "xxx", ==, ["x", "x"])
		assertAdvancedBy(zeroToNClosed, "xxx", 2)
	}


	let atLeastNClosed = %"x" * (2...Int.max)

	func testAtLeastNClosedRepetitionRejectsZeroTrees() {
		assertUnmatched(atLeastNClosed, "y")
	}

	func testAtLeastNClosedRepetitionParsesNTrees() {
		assertTree(atLeastNClosed, "xx", ==, ["x", "x"])
	}

	func testAtLeastNClosedRepetitionParsesMoreThanNTrees() {
		assertTree(atLeastNClosed, "xxxx", ==, ["x", "x", "x", "x"])
	}


	let mToNClosed = %"x" * (2...3)

	func testMToNClosedRepetitionRejectsLessThanM() {
		assertUnmatched(mToNClosed, "x")
	}

	func testMToNClosedRepetitionMatchesUpToN() {
		assertAdvancedBy(mToNClosed, "xxxx", 3)
	}


	let closedNToN = %"x" * (2...2)

	func testClosedNToNRepetitionMatchesUpToN() {
		assertAdvancedBy(closedNToN, "xxx", 2)
	}


	// MARK: Repetition shorthand

	let zeroOrMoreSimple = "x"*

	func testZeroOrMoreSimpleRepetitionAcceptsTheEmptyString() {
		assertMatched(zeroOrMoreSimple, "")
	}

	func testZeroOrMoreSimpleRepetitionAcceptsUnmatchedStrings() {
		assertMatched(zeroOrMoreSimple, "y")
	}

	func testZeroOrMoreSimpleRepetitionDoesNotAdvanceWithUnmatchedStrings() {
		assertAdvancedBy(zeroOrMoreSimple, "y", 0)
	}

	func testZeroOrMoreSimpleRepetitionParsesUnmatchedStringsAsEmptyArrays() {
		assertTree(zeroOrMoreSimple, "y", ==, [])
	}

	func testZeroOrMoreSimpleRepetitionParsesAMatchedString() {
		assertTree(zeroOrMoreSimple, "x", ==, ["x"])
	}

	func testZeroOrMoreSimpleRepetitionParsesMatchedStrings() {
		assertTree(zeroOrMoreSimple, "xx", ==, ["x", "x"])
	}


	let oneOrMoreSimple = "x"+

	func testOneOrMoreSimpleRepetitionRejectsTheEmptyString() {
		assertUnmatched(oneOrMoreSimple, "")
	}

	func testOneOrMoreSimpleRepetitionParsesASingleMatchedString() {
		assertTree(oneOrMoreSimple, "x", ==, ["x"])
	}

	func testOneOrMoreSimpleRepetitonParsesMultipleMatchedStrings() {
		assertTree(oneOrMoreSimple, "xxy", ==, ["x", "x"])
	}
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
