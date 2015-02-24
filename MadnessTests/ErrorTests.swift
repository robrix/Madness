//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ErrorTests: XCTestCase {
	func testError() {
		["xy": "expected rest of sequence, or term"]
		parse(term, "x")
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

import Madness
import Prelude
import XCTest
