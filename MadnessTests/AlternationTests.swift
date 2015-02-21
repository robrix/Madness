//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class AlternationTests: XCTestCase {
	let alternation = %"x" | (%"y" --> const(1))

	func testAlternationParsesEitherAlternative() {
		assertEqual(alternation("xy")?.1, "y")
		assertEqual(alternation("yx")?.1, "x")
	}

	func testAlternationProducesTheParsedAlternative() {
		assert(alternation("xy")?.0, ==, Either.left("x"))
	}

	func testAlternationOfASingleTypeCoalescesTheParsedValue() {
		let parsed = (%"x" | %"y")("xy")
		assertEqual(parsed?.0, "x")
	}
}


// MARK: - Imports

import Assertions
import Either
import Madness
import Prelude
import XCTest
