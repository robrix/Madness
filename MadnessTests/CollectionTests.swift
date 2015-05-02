//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class CollectionTests: XCTestCase {
	func testParsingCollections() {
		let input = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]

		typealias Fibonacci = Parser<[Int], [Int]>.Function

		let fibonacci: (Int, Int) -> Fibonacci = fix { fibonacci in
			{ (x: Int, y: Int) -> Fibonacci in
				%(x + y) >>- { (xy: Int) -> Fibonacci in
					fibonacci(y, xy) |> map { [ xy ] + $0 }
				} | { ([], $1) }
			}
		}

		assert(parse(fibonacci(0, 1), input), ==, input)
	}
}


// MARK: - Imports

import Assertions
import Madness
import Prelude
import XCTest
