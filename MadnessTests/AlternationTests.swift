//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class AlternationTests: XCTestCase {
	let alternation = %"x" | (%"y" --> { _, _ in 1 })

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
}


// MARK: - Imports

import Assertions
import Either
import Madness
import Prelude
import XCTest
