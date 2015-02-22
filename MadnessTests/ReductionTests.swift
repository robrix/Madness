//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ReductionTests: XCTestCase {
	let reduction = %"x" --> { $0.uppercaseString }

	func testMapsParseTreesWithAFunction() {
		assertTree(reduction, "x", ==, "X")
	}
}


// MARK: - Imports

import Madness
import XCTest
