//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class IgnoreTests: XCTestCase {
	let ignored = %"x"

	func testIgnoredInputDoesNotGetConcatenatedAtLeft() {
		assertTree(ignored *> %"y", "xy".characters, ==, "y")
	}

	func testIgnoredInputDoesNotGetConcatenatedAtRight() {
		assertTree(%"y" <* ignored, "yx".characters, ==, "y")
	}

	func testRepeatedIgnoredEmptyParsesAreDropped() {
		assertTree(ignored* *> %"y", "y".characters, ==, "y")
	}

	func testRepeatedIgnoredParsesAreDropped() {
		assertTree(ignored* *> %"y", "xxy".characters, ==, "y")
	}
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
