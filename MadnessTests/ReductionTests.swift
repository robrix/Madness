//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ReductionTests: XCTestCase {
	let reduction = %"x" --> { $4.uppercased() }

	func testMapsParseTreesWithAFunction() {
		assertTree(reduction, "x".characters, ==, "X")
	}

	func testRejectsInputRejectedByItsParser() {
		assertUnmatched(reduction, "y".characters)
	}


	enum Value { case null }

	let constReduction = %"null" --> { _, _, _, _, _ in Value.null }

	func testMapsConstFunctionOverInput() {
		assertTree(constReduction, "null".characters, ==, Value.null)
	}


	let reductionWithIndex = %"x" --> { "\($4.uppercased()):\($0.distance(from: $0.startIndex, to: $3.lowerBound))..<\($0.distance(from: $0.startIndex, to: $3.upperBound))" }

	func testMapsParseTreesWithAFunctionWhichTakesTheSourceIndex() {
		assertTree(reductionWithIndex, "x".characters, ==, "X:0..<1")
	}
}


// MARK: - Imports

import Madness
import XCTest
