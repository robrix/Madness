//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class IgnoreTests: XCTestCase {
	let ignored = ignore("x")

	func testIgnoredInputDoesNotGetConcatenatedAtLeft() {
		assertTree(ignored ++ %"y", "xy".characters, ==, "y")
	}

	func testIgnoredInputDoesNotGetConcatenatedAtRight() {
		assertTree(%"y" ++ ignored, "yx".characters, ==, "y")
	}

	func testIgnoringDistributesOverConcatenation() {
		assertAdvancedBy(ignored ++ ignored, input: "xx".characters, offset: 2)
	}

	func testIgnoredInputIsDroppedFromAlternationsAtLeft() {
		assertTree(ignored | %"y", "y".characters, ==, "y")
	}

	func testIgnoredInputIsDroppedFromAlternationsAtRight() {
		assertTree(%"y" | ignored, "y".characters, ==, "y")
	}

	func testIgnoringDistributesOverAlternation() {
		assertMatched(ignored | ignored, input: "x".characters)
	}

	func testRepeatedIgnoredEmptyParsesAreDropped() {
		assertTree(ignored* ++ %"y", "y".characters, ==, "y")
	}

	func testRepeatedIgnoredParsesAreDropped() {
		assertTree(ignored* ++ %"y", "xxy".characters, ==, "y")
	}
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
