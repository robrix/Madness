//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class RepetitionTests: XCTestCase {
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


	// MARK: Repetition shorthand
	let zeroOrMoreSimple = "x"*

	func testZeroOrMoreSimpleRepetitionAcceptsTheEmptyString() {
		assertNotNil(zeroOrMoreSimple(""))
	}

	func testZeroOrMoreSimpleRepetitionAcceptsUnmatchedStrings() {
		assertNotNil(zeroOrMoreSimple("y"))
	}

	func testZeroOrMoreSimpleRepetitionDoesNotAdvanceWithUnmatchedStrings() {
		assertEqual(zeroOrMoreSimple("y")?.1, "y")
	}

	func testZeroOrMoreSimpleRepetitionParsesUnmatchedStringsAsEmptyArrays() {
		assertEqual(zeroOrMoreSimple("y")?.0, [])
	}

	func testZeroOrMoreSimpleRepetitionParsesAMatchedString() {
		assertEqual(zeroOrMoreSimple("x")?.0, ["x"])
	}

	func testZeroOrMoreSimpleRepetitionParsesMatchedStrings() {
		assertEqual(zeroOrMoreSimple("xx")?.0, ["x", "x"])
	}


	let oneOrMoreSimple = "x"+

	func testOneOrMoreSimpleRepetitionRejectsTheEmptyString() {
		assertNil(oneOrMoreSimple(""))
	}

	func testOneOrMoreSimpleRepetitionParsesASingleMatchedString() {
		assertEqual(oneOrMoreSimple("x")?.0, ["x"])
	}

	func testOneOrMoreSimpleRepetitonParsesMultipleMatchedStrings() {
		assertEqual(oneOrMoreSimple("xxy")?.0, ["x", "x"])
	}
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
