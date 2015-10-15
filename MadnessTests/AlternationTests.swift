//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class AlternationTests: XCTestCase {

	// MARK: Alternation

	func testAlternationParsesEitherAlternative() {
		assertAdvancedBy(alternation, input: "xy".characters, offset: 1)
		assertAdvancedBy(alternation, input: "yx".characters, offset: 1)
	}

	func testAlternationProducesTheParsedAlternative() {
		assertTree(alternation, "xy".characters, ==, Either.left("x"))
	}

	func testAlternationOfASingleTypeCoalescesTheParsedValue() {
		assertTree(%"x" | %"y", "xy".characters, ==, "x")
	}


	// MARK: Optional

	func testOptionalProducesWhenPresent() {
		assertTree(optional, "y".characters, ==, "y")
		assertTree(prefixed, "xy".characters, ==, "xy")
		assertTree(suffixed, "yzsandwiched".characters, ==, "yz")
	}

	func testOptionalProducesWhenAbsent() {
		assertTree(optional, "".characters, ==, "")
		assertTree(prefixed, "x".characters, ==, "x")
		assertTree(suffixed, "z".characters, ==, "z")
		assertTree(sandwiched, "xz".characters, ==, "xz")
	}


	// MARK: One-of

	func testOneOfParsesFirstMatch() {
		let string = "xyz"
		let eqs: (String, String) -> Bool = (==)
		assertTree(one, string, eqs, "x")
		assertTree(one, "yzx", ==, "y")
		assertTree(one, "zxy", ==, "z")
	}


	// MARK: Any-of

	func testAnyOfParsesAnArrayOfMatchesPreservingOrder() {
		assertTree(any, Set(["xy"]), ==, [Set(["x", "y"])])
		assertTree(any, Set(["yx"]), ==, [Set(["y", "x"])])
		assertTree(any, Set(["zxy"]), ==, [Set(["z", "x", "y"])])
	}

	func testAnyOfRejectsWhenNoneMatch() {
		
		assertUnmatched(anyOf([Set("x".characters)]), Set("y".characters))
	}

	func testAnyOfOnlyParsesFirstMatch() {
		assertTree(any, Set(["xyy"]), ==, [Set(["x", "y"])])
	}


	// MARK: All-of

	func testAllOfParsesAnArrayOfMatchesPreservingOrder() {
		assertTree(all, Set(["xy"]), ==, [Set(["x", "y"])])
		assertTree(all, Set(["yx"]), ==, [Set(["y", "x"])])
		assertTree(all, Set(["zxy"]), ==, [Set(["z", "x", "y"])])
	}

	func testAllOfRejectsWhenNoneMatch() {
		assertUnmatched(allOf([Set(["x"])]), Set(["y"]))
	}

	func testAllOfParsesAllMatches() {
		assertTree(all, Set(["xyyxz"]), ==, [Set(["x", "y", "y", "x", "z"])])
	}
}

// MARK: - Fixtures

private let alternation = %"x" | (%"y" --> { _, _, _ in 1 })

private let optional = (%"y")|? |> map { $0 ?? "" }
private let prefixed = %"x" ++ optional |> map { $0 + $1 }
private let suffixed = optional ++ %"z" |> map { $0 + $1 }
private let sandwiched = prefixed ++ %"z" |> map { $0 + $1 }

private let one = oneOf(["x", "y", "z"])
private let any = anyOf(["x", "y", "z"])
private let all = allOf(["x", "y", "z"])


// MARK: - Imports

import Assertions
import Either
import Madness
import Prelude
import XCTest
