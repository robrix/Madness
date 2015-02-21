//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ConcatenationTests: XCTestCase {
	let concatenation = %"x" ++ %"y"

	func testConcatenationRejectsPartialParses() {
		assertNil(concatenation("x"))
	}

	func testConcatenationParsesBothOperands() {
		assertEqual(concatenation("xyz")?.1, "z")
	}

	func testConcatenationProducesPairsOfTerms() {
		let parsed = concatenation("xy")
		assertEqual(parsed?.0.0, "x")
		assertEqual(parsed?.0.1, "y")
	}
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
