//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ReductionTests: XCTestCase {
	let reduction = %"x" --> { $3.uppercaseString }

	func testMapsParseTreesWithAFunction() {
		assertTree(reduction, "x".characters, ==, "X")
	}

	func testRejectsInputRejectedByItsParser() {
		assertUnmatched(reduction, "y".characters)
	}


	enum Value { case Null }

	let constReduction = %"null" --> { _, _, _, _ in Value.Null }

	func testMapsConstFunctionOverInput() {
		assertTree(constReduction, "null".characters, ==, Value.Null)
	}


	let reductionWithIndex = %"x" --> { "\($4.uppercaseString):\($0.startIndex.distanceTo($3.startIndex))..<\($0.startIndex.distanceTo($3.endIndex))" }

	func testMapsParseTreesWithAFunctionWhichTakesTheSourceIndex() {
		assertTree(reductionWithIndex, "x".characters, ==, "X:0..<1")
	}
}


// MARK: - Imports

import Madness
import XCTest
