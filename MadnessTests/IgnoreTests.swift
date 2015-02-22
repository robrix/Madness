//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class IgnoreTests: XCTestCase {
	let ignored = ignore("x")

	func testIgnoredInputDoesNotGetConcatenatedAtLeft() {
		assertTree(ignored ++ %"y", "xy", ==, "y")
	}

	func testIgnoredInputDoesNotGetConcatenatedAtRight() {
		assertTree(%"y" ++ ignored, "yx", ==, "y")
	}

	func testIgnoringDistributesOverConcatenation() {
		assertAdvancedBy(ignored ++ ignored, "xx", 2)
	}

	func testIgnoredInputIsDroppedFromAlternationsAtLeft() {
		assertTree(ignored | %"y", "y", ==, "y")
	}

	func testIgnoredInputIsDroppedFromAlternationsAtRight() {
		assertTree(%"y" | ignored, "y", ==, "y")
	}

	func testIgnoringDistributesOverAlternation() {
		assertMatched(ignored | ignored, "x")
	}

	func testRepeatedIgnoredEmptyParsesAreDropped() {
		assertTree(ignored* ++ %"y", "y", ==, "y")
	}

	func testRepeatedIgnoredParsesAreDropped() {
		assertTree(ignored* ++ %"y", "xxy", ==, "y")
	}
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
