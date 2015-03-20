//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ErrorTests: XCTestCase {
	func testLiftedParsersDoNotReportErrorsWhenTheyMatch() {
		let parser = lift(%"x")
		let input = "x"
		assert(parser(input, input.startIndex).right, !=, nil)
		assert(parser(input, input.startIndex).left, ==, nil)
	}

	func testLiftedParsersReportErrorsWhenTheyDoNotMatch() {
		let parser = lift(%"x")
		let input = "y"
		assert(parser(input, input.startIndex).right, ==, nil)
		assert(parser(input, input.startIndex).left, !=, nil)
	}
}


private func lift<C: CollectionType, Tree>(parser: Parser<C, Tree>.Function) -> (C, C.Index) -> Either<Error<C.Index>, (Tree, C.Index)> {
	return { input, index in
		parser(input, index).map { tree, rest in Either.right(tree, rest) }
			??	Either.left(Error.leaf("expected to parse with \(parser)", index))
	}
}


// MARK: - Imports

import Assertions
import Either
import Madness
import Prelude
import XCTest
