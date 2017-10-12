//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ErrorTests: XCTestCase {
	func testLiftedParsersDoNotReportErrorsWhenTheyMatch() {
		let parser = %"x"
		let input = "x".characters
		let sourcePos = SourcePos(index: input.startIndex)
		XCTAssertNotNil(parser(input, sourcePos).value)
		XCTAssertNil(parser(input, sourcePos).error)
	}

	func testLiftedParsersReportErrorsWhenTheyDoNotMatch() {
		let parser = %"x"
		let input = "y"
		let sourcePos = SourcePos(index: input.startIndex)
		XCTAssertNil(parser(input.characters, sourcePos).value)
		XCTAssertNotNil(parser(input.characters, sourcePos).error)
	}

	func testParseError() {
		XCTAssertEqual(parse(lambda, input: "λx.").error?.depth, 5)
	}

	func testParseNaming() {
		XCTAssertNotNil(parse(describeAs("lambda")(lambda), input: "λx.").error)
	}
}


// MARK: - Imports

import Madness
import XCTest
