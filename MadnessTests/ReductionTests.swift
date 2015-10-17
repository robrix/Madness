//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ReductionTests: XCTestCase {
	let reduction = %"x" --> { $2.uppercaseString }

	func testMapsParseTreesWithAFunction() {
		assertTree(reduction, "x".characters, ==, "X")
	}

	func testRejectsInputRejectedByItsParser() {
		assertUnmatched(reduction, "y".characters)
	}


	enum Value { case Null }

	let constReduction = %"null" --> { _ in Value.Null }

	func testMapsConstFunctionOverInput() {
		assertTree(constReduction, "null".characters, ==, Value.Null)
	}


	let reductionWithIndex = %"x" --> { "\($2.uppercaseString):\($0.startIndex.distanceTo($1.startIndex))..<\($0.startIndex.distanceTo($1.endIndex))" }

	func testMapsParseTreesWithAFunctionWhichTakesTheSourceIndex() {
		assertTree(reductionWithIndex, "x".characters, ==, "X:0..<1")
	}
}


// MARK: - Imports

import Madness
import XCTest
