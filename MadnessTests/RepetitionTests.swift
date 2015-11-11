//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class RepetitionTests: XCTestCase {
	let zeroOrMore: Parser<String.CharacterView, [String]>.Function = many(%"x")

	func testZeroOrMoreRepetitionAcceptsTheEmptyString() {
		assertMatched(zeroOrMore, input: "".characters)
	}

	func testZeroOrMoreRepetitionAcceptsUnmatchedStrings() {
		assertMatched(zeroOrMore, input: "y".characters)
	}

	func testZeroOrMoreRepetitionDoesNotAdvanceWithUnmatchedStrings() {
		assertAdvancedBy(zeroOrMore, input: "y".characters, offset: 0)
	}

	func testZeroOrMoreRepetitionParsesUnmatchedStringsAsEmptyArrays() {
		assertTree(zeroOrMore, "y".characters, ==, [])
	}

	func testZeroOrMoreRepetitionParsesAMatchedString() {
		assertTree(zeroOrMore, "x".characters, ==, ["x"])
	}

	func testZeroOrMoreRepetitionParsesMatchedStrings() {
		assertTree(zeroOrMore, "xx".characters, ==, ["x", "x"])
	}


	let oneOrMore = some(%"x")

	func testOneOrMoreRepetitionRejectsTheEmptyString() {
		assertUnmatched(oneOrMore, "".characters)
	}

	func testOneOrMoreRepetitionParsesASingleMatchedString() {
		assertTree(oneOrMore, "x".characters, ==, ["x"])
	}

	func testOneOrMoreRepetitonParsesMultipleMatchedStrings() {
		assertTree(oneOrMore, "xxy".characters, ==, ["x", "x"])
	}


	let exactlyN = %"x" * 3

	func testExactlyNRepetitionParsesNTrees() {
		assertTree(exactlyN, "xxx".characters, ==, ["x", "x", "x"])
	}

	func testExactlyNRepetitionParsesRejectsFewerMatches() {
		assertUnmatched(exactlyN, "xx".characters)
	}

	func testExactlyNRepetitionParsesStopsAtN() {
		assertAdvancedBy(exactlyN, input: "xxxx".characters, lineOffset: 0, columnOffset: 3, offset: 3)
	}


	let zeroToN = %"x" * (0..<2)

	func testZeroToNRepetitionParsesZeroTrees() {
		assertTree(zeroToN, "y".characters, ==, [])
	}

	func testZeroToNRepetitionParsesUpToButNotIncludingNTrees() {
		assertTree(zeroToN, "xxx".characters, ==, ["x"])
		assertAdvancedBy(zeroToN, input: "xxx".characters, lineOffset: 0, columnOffset: 1, offset: 1)
	}


	let atLeastN = %"x" * (2..<Int.max)

	func testAtLeastNRepetitionRejectsZeroTrees() {
		assertUnmatched(atLeastN, "y".characters)
	}

	func testAtLeastNRepetitionParsesNTrees() {
		assertTree(atLeastN, "xx".characters, ==, ["x", "x"])
	}

	func testAtLeastNRepetitionParsesMoreThanNTrees() {
		assertTree(atLeastN, "xxxx".characters, ==, ["x", "x", "x", "x"])
	}


	let mToN = %"x" * (2..<3)

	func testMToNRepetitionRejectsLessThanM() {
		assertUnmatched(mToN, "x".characters)
	}

	func testMToNRepetitionMatchesUpToButNotIncludingN() {
		assertAdvancedBy(mToN, input: "xxxx".characters, lineOffset: 0, columnOffset: 2, offset: 2)
	}


	let nToN = %"x" * (2..<2)

	func testOpenNToNRepetitionRejectsN() {
		assertUnmatched(nToN, "xx".characters)
	}



	let zeroToNClosed = %"x" * (0...2)

	func testZeroToNClosedRepetitionParsesZeroTrees() {
		assertTree(zeroToNClosed, "y".characters, ==, [])
	}

	func testZeroToNClosedRepetitionParsesUpToNTrees() {
		assertTree(zeroToNClosed, "xxx".characters, ==, ["x", "x"])
		assertAdvancedBy(zeroToNClosed, input: "xxx".characters, lineOffset: 0, columnOffset: 2, offset: 2)
	}


	let atLeastNClosed = %"x" * (2...Int.max)

	func testAtLeastNClosedRepetitionRejectsZeroTrees() {
		assertUnmatched(atLeastNClosed, "y".characters)
	}

	func testAtLeastNClosedRepetitionParsesNTrees() {
		assertTree(atLeastNClosed, "xx".characters, ==, ["x", "x"])
	}

	func testAtLeastNClosedRepetitionParsesMoreThanNTrees() {
		assertTree(atLeastNClosed, "xxxx".characters, ==, ["x", "x", "x", "x"])
	}


	let mToNClosed = %"x" * (2...3)

	func testMToNClosedRepetitionRejectsLessThanM() {
		assertUnmatched(mToNClosed, "x".characters)
	}

	func testMToNClosedRepetitionMatchesUpToN() {
		assertAdvancedBy(mToNClosed, input: "xxxx".characters, lineOffset: 0, columnOffset: 3, offset: 3)
	}


	let closedNToN = %"x" * (2...2)

	func testClosedNToNRepetitionMatchesUpToN() {
		assertAdvancedBy(closedNToN, input: "xxx".characters, lineOffset: 0, columnOffset: 2, offset: 2)
	}


	// MARK: Repetition shorthand

	let zeroOrMoreSimple = many(%"x")

	func testZeroOrMoreSimpleRepetitionAcceptsTheEmptyString() {
		assertMatched(zeroOrMoreSimple, input: "".characters)
	}

	func testZeroOrMoreSimpleRepetitionAcceptsUnmatchedStrings() {
		assertMatched(zeroOrMoreSimple, input: "y".characters)
	}

	func testZeroOrMoreSimpleRepetitionDoesNotAdvanceWithUnmatchedStrings() {
		assertAdvancedBy(zeroOrMoreSimple, input: "y".characters, offset: 0)
	}

	func testZeroOrMoreSimpleRepetitionParsesUnmatchedStringsAsEmptyArrays() {
		assertTree(zeroOrMoreSimple, "y".characters, ==, [])
	}

	func testZeroOrMoreSimpleRepetitionParsesAMatchedString() {
		assertTree(zeroOrMoreSimple, "x".characters, ==, ["x"])
	}

	func testZeroOrMoreSimpleRepetitionParsesMatchedStrings() {
		assertTree(zeroOrMoreSimple, "xx".characters, ==, ["x", "x"])
	}


	let oneOrMoreSimple = some(%"x")

	func testOneOrMoreSimpleRepetitionRejectsTheEmptyString() {
		assertUnmatched(oneOrMoreSimple, "".characters)
	}

	func testOneOrMoreSimpleRepetitionParsesASingleMatchedString() {
		assertTree(oneOrMoreSimple, "x".characters, ==, ["x"])
	}

	func testOneOrMoreSimpleRepetitonParsesMultipleMatchedStrings() {
		assertTree(oneOrMoreSimple, "xxy".characters, ==, ["x", "x"])
	}
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
