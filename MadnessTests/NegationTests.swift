//  Copyright (c) 2015 Rob Rix. All rights reserved.

class NegationTests: XCTestCase {
	let notA: CharacterParser = notFollowedBy(%"a") *> any

	func testNegativeLookaheadRejectsMatches() {
		assertUnmatched(notA, "a".characters)
	}

	func testNegativeLookaheadAcceptsNonMatches() {
		assertTree(notA, "b".characters, ==, "b")
	}


	let upToBang: CharacterArrayParser = many(notFollowedBy(%"!") *> any) <* many(any)

	func testNegativeLooaheadAccumulation() {
		assertTree(upToBang, "x y! z".characters, ==, ["x", " ", "y"])
	}

	func testNegativeLooaheadAccumulationWithoutMatch() {
		assertTree(upToBang, "x y z".characters, ==, ["x", " ", "y", " ", "z"])
    }
}

// MARK: - Imports

import Assertions
import Madness
import XCTest
