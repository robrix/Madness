//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ReductionTests: XCTestCase {
	let reduction = %"x" --> { $0.uppercaseString }

	func testMapsParseTreesWithAFunction() {
		assertTree(reduction, "x", ==, "X")
	}

	func testRejectsInputRejectedByItsParser() {
		assertUnmatched(reduction, "y")
	}


	let reductionWithIndex = %"x" --> { $2.uppercaseString + String(distance($0.startIndex, $1)) }

	func testMapsParseTreesWithAFunctionWhichTakesTheSourceIndex() {
		assertTree(reductionWithIndex, "x", ==, "X1")
	}
}


// MARK: - Imports

import Madness
import XCTest
