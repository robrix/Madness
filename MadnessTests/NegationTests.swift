//  Copyright (c) 2015 Rob Rix. All rights reserved.

class NegationTests: XCTestCase {
	let notA: CharacterParser = not(%"a") *> any

	func testNegativeLookaheadRejectsMatches() {
		assertUnmatched(notA, "a".characters)
	}

	func testNegativeLookaheadAcceptsNonMatches() {
		assertTree(notA, "b".characters, ==, "b")
	}


	let upToBang: CharacterArrayParser = many(not(%"!") *> any) <* many(any)

	func testNegativeLooaheadAccumulation() {
		assertTree(upToBang, "xy!z".characters, ==, ["x", "y"])
	}

	func testNegativeLooaheadAccumulationWithoutMatch() {
		assertTree(upToBang, "xyz".characters, ==, ["x", "y", "z"])
    }
}

// MARK: - Imports

import Madness
import XCTest
