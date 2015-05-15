//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class AlternationTests: XCTestCase {

	// MARK: Alternation

	func testAlternationParsesEitherAlternative() {
		assertAdvancedBy(alternation, "xy", 1)
		assertAdvancedBy(alternation, "yx", 1)
	}

	func testAlternationProducesTheParsedAlternative() {
		assertTree(alternation, "xy", ==, Either.left("x"))
	}

	func testAlternationOfASingleTypeCoalescesTheParsedValue() {
		assertTree(%"x" <||> %"y", "xy", ==, "x")
	}


	// MARK: Optional

	func testOptionalProducesWhenPresent() {
		assertTree(optional, "y", ==, "y")
		assertTree(prefixed, "xy", ==, "xy")
		assertTree(suffixed, "yz", ==, "yz")
		assertTree(sandwiched, "xyz", ==, "xyz")
	}

	func testOptionalProducesWhenAbsent() {
		assertTree(optional, "", ==, "")
		assertTree(prefixed, "x", ==, "x")
		assertTree(suffixed, "z", ==, "z")
		assertTree(sandwiched, "xz", ==, "xz")
	}


	// MARK: One-of

	func testOneOfParsesFirstMatch() {
		assertTree(one, "xyz", ==, "x")
		assertTree(one, "yzx", ==, "y")
		assertTree(one, "zxy", ==, "z")
	}


	// MARK: Any-of

	func testAnyOfParsesAnArrayOfMatchesPreservingOrder() {
		assertTree(any, "xy", ==, ["x", "y"])
		assertTree(any, "yx", ==, ["y", "x"])
		assertTree(any, "zxy", ==, ["z", "x", "y"])
	}

	func testAnyOfRejectsWhenNoneMatch() {
		assertUnmatched(anyOf(["x"]), "y")
	}

	func testAnyOfOnlyParsesFirstMatch() {
		assertTree(any, "xyy", ==, ["x", "y"])
	}


	// MARK: All-of

	func testAllOfParsesAnArrayOfMatchesPreservingOrder() {
		assertTree(all, "xy", ==, ["x", "y"])
		assertTree(all, "yx", ==, ["y", "x"])
		assertTree(all, "zxy", ==, ["z", "x", "y"])
	}

	func testAllOfRejectsWhenNoneMatch() {
		assertUnmatched(allOf(["x"]), "y")
	}

	func testAllOfParsesAllMatches() {
		assertTree(all, "xyyxz", ==, ["x", "y", "y", "x", "z"])
	}

}

// MARK: - Fixtures

private let alternation = %"x" <||> (%"y" --> { _, _, _ in 1 })

private let optional = (%"y")|? |> map { $0 ?? "" }
private let prefixed = %"x" <*> optional |> map { $0 + $1 }
private let suffixed = optional <*> %"z" |> map { $0 + $1 }
private let sandwiched = prefixed <*> %"z" |> map { $0 + $1 }

private let one = oneOf(["x", "y", "z"])
private let any = anyOf(["x", "y", "z"])
private let all = allOf(["x", "y", "z"])


// MARK: - Imports

import Assertions
import Either
import Madness
import Prelude
import XCTest
