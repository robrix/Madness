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
		assertTree(many(ignored) *> %"y", "y".characters, ==, "y")
	}

	func testRepeatedIgnoredParsesAreDropped() {
		assertTree(many(ignored) *> %"y", "xxy".characters, ==, "y")
	}
}


// MARK: - Imports

import Madness
import XCTest
