//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ErrorTests: XCTestCase {
	func testLiftedParsersDoNotReportErrorsWhenTheyMatch() {
		let parser = %"x"
		let input = "x"
		assert(parser(input, input.startIndex).right, !=, nil)
		assert(parser(input, input.startIndex).left, ==, nil)
	}

	func testLiftedParsersReportErrorsWhenTheyDoNotMatch() {
		let parser = %"x"
		let input = "y"
		assert(parser(input, input.startIndex).right, ==, nil)
		assert(parser(input, input.startIndex).left, !=, nil)
	}

	func testParseError() {
		assert(parse(lambda, "λx.").left?.depth, ==, 5)
	}

	func testParseNaming() {
		assert(parse(lambda |> describeAs("lambda"), "λx.").left, !=, nil)
	}
}


// MARK: - Imports

import Assertions
import Madness
import Prelude
import XCTest
