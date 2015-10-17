//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ErrorTests: XCTestCase {
	func testLiftedParsersDoNotReportErrorsWhenTheyMatch() {
		let parser = %"x"
		let input = "x".characters
		assert(parser(input, input.startIndex).right, !=, nil)
		assert(parser(input, input.startIndex).left, ==, nil)
	}

	func testLiftedParsersReportErrorsWhenTheyDoNotMatch() {
		let parser = %"x"
		let input = "y"
		assert(parser(input.characters, input.startIndex).right, ==, nil)
		assert(parser(input.characters, input.startIndex).left, !=, nil)
	}

	func testParseError() {
		assert(parse(lambda, input: "λx.").left?.depth, ==, 5)
	}

	func testParseNaming() {
		assert(parse(lambda |> describeAs("lambda"), input: "λx.").left, !=, nil)
	}
}


// MARK: - Imports

import Assertions
import Madness
import Prelude
import XCTest
