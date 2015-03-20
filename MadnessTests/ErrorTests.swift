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
		assert(parser(input, input.startIndex).left, !=, nil) // 0: expected to parse with (Function)
	}
}


// MARK: - Imports

import Assertions
import Either
import Madness
import Prelude
import XCTest
