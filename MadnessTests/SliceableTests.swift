//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class SliceableTests: XCTestCase {
	func testParsingSliceable() {
		let input = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]

		typealias Fibonacci = Parser<Slice<Int>, [Int]>.Function

		let fibonacci: (Int, Int) -> Fibonacci = fix { fibonacci in
			{ x, y -> Fibonacci in
				%(x + y) >>- { xy -> Fibonacci in
					fibonacci(y, xy) --> { [ xy ] + $0 }
				} | { ([], $0) }
			}
		}

		assert(parse(fibonacci(0, 1), Slice(input)), ==, input)
	}
}


// MARK: - Imports

import Assertions
import Madness
import Prelude
import XCTest
