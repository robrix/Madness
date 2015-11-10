//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ErrorTests: XCTestCase {
	func testLiftedParsersDoNotReportErrorsWhenTheyMatch() {
		let parser = %"x"
		let input = "x".characters
		let sourcePos = SourcePos(index: input.startIndex)
		assert(parser(input, sourcePos).right, !=, nil)
		assert(parser(input, sourcePos).left, ==, nil)
	}

	func testLiftedParsersReportErrorsWhenTheyDoNotMatch() {
		let parser = %"x"
		let input = "y"
		let sourcePos = SourcePos(index: input.startIndex)
		assert(parser(input.characters, sourcePos).right, ==, nil)
		assert(parser(input.characters, sourcePos).left, !=, nil)
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
