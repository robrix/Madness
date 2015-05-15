//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class IgnoreTests: XCTestCase {
	let ignored = %"x"

	func testIgnoredInputDoesNotGetConcatenatedAtLeft() {
		assertTree(ignored *> %"y", "xy", ==, "y")
	}

	func testIgnoredInputDoesNotGetConcatenatedAtRight() {
		assertTree(%"y" <* ignored, "yx", ==, "y")
	}

	func testRepeatedIgnoredEmptyParsesAreDropped() {
		assertTree(ignored* *> %"y", "y", ==, "y")
	}

	func testRepeatedIgnoredParsesAreDropped() {
		assertTree(ignored* *> %"y", "xxy", ==, "y")
	}
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
