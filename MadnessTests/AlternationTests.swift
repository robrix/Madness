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
		assertTree(%"x" | %"y", "xy", ==, "x")
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
		let xyz = oneOf(["x", "y", "z"])
		assertTree(xyz, "xyz", ==, "x")
		assertTree(xyz, "yzx", ==, "y")
		assertTree(xyz, "zxy", ==, "z")
	}

}

// MARK: - Fixtures

let alternation = %"x" | (%"y" --> { _, _, _ in 1 })

let optional = (%"y")|? --> { $0 ?? "" }
let prefixed = %"x" ++ optional --> { $0 + $1 }
let suffixed = optional ++ %"z" --> { $0 + $1 }
let sandwiched = prefixed ++ %"z" --> { $0 + $1 }


// MARK: - Imports

import Assertions
import Either
import Madness
import Prelude
import XCTest
