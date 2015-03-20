//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ErrorTests: XCTestCase {
	func testLiteralErrorReporting() {
		let parser = lift(%"x")
	}

	func testError() {
		["xy": "expected rest of sequence, or term"]
		parse(term, "x")
	}
}


private func lift<C: CollectionType, Tree>(parser: Parser<C, Tree>.Function) -> (C, C.Index) -> Either<Error<C.Index>, (Tree, C.Index)> {
	return { input, index in
		parser(input, index).map { tree, rest in Either.right(tree, rest) }
			??	Either.left(Error.leaf("expected to parse with \(parser)", index))
	}
}


// MARK: - Fixtures

private enum Tree {
	case Leaf
	case Branch([Tree])
}

private let group: Parser<String, Tree>.Function = ignore("(") ++ sequence ++ ignore(")")
private let sequence: Parser<String, Tree>.Function = (term ++ (ignore(",") ++ term)+) --> { Tree.Branch([$0] + $1) }
private let term: Parser<String, Tree>.Function = delay { (%"x" --> { _, _, _ in Tree.Leaf }) | group }


// MARK: - Imports

import Either
import Madness
import Prelude
import XCTest
