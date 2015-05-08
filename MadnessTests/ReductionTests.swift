//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ReductionTests: XCTestCase {
	let reduction = %"x" --> { $2.uppercaseString }

	func testMapsParseTreesWithAFunction() {
		assertTree(reduction, "x", ==, "X")
	}

	func testRejectsInputRejectedByItsParser() {
		assertUnmatched(reduction, "y")
	}


	enum Value { case Null }

	let constReduction = %"null" --> { _ in Value.Null }

	func testMapsConstFunctionOverInput() {
		assertTree(constReduction, "null", ==, Value.Null)
	}


	let reductionWithIndex = %"x" --> { "\($2.uppercaseString):\(distance($0.startIndex, $1.startIndex))..<\(distance($0.startIndex, $1.endIndex))" }

	func testMapsParseTreesWithAFunctionWhichTakesTheSourceIndex() {
		assertTree(reductionWithIndex, "x", ==, "X:0..<1")
	}
}


// MARK: - Imports

import Madness
import XCTest
