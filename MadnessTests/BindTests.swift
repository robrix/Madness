//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Madness
import Prelude
import XCTest

infix operator >>= { associativity left }

struct Tree<T: Equatable>: Equatable, Printable {
	init(_ value: T, _ children: [Tree] = []) {
		self.values = [ value ]
		self.children = children
	}

	let values: [T]
	let children: [Tree]


	// MARK: Printable

	var description: String {
		let space = " "
		let valueString = space.join(map(values, toString))
		return children.count > 0 ?
			"(\(valueString) \(space.join(map(children, toString))))"
		:	"(\(valueString))"
	}
}

func == <T: Equatable> (left: Tree<T>, right: Tree<T>) -> Bool {
	return left.values == right.values && left.children == right.children
}

final class BindTests: XCTestCase {
	func testBind() {
		let item = %"-\n"
		let tree: Int -> Parser<Tree<Int>>.Function = fix { tree in
			{ n in
				let line: Parser<String>.Function = ignore(%"\t" * n) ++ item
				return line >>= { _ in
					(tree(n + 1)* --> { children in Tree(n, children) })
				}
			}
		}

		let fixtures: [String: Tree<Int>] = [
			"-\n": Tree(0),
			"-\n\t-\n": Tree(0, [ Tree(1) ]),
			"-\n\t-\n\t-\n": Tree(0, [ Tree(1), Tree(1) ]),
			"-\n\t-\n\t\t-\n\t-\n": Tree(0, [ Tree(1, [ Tree(2) ]), Tree(1) ]),
		]

		for (input, actual) in fixtures {
			if let parsed = parse(tree(0), input) {
				XCTAssertEqual(parsed, actual)
			} else {
				XCTFail("expected to parse \(input) as \(actual) but failed to parse")
			}
		}

		let failures: [String] = [
			"-\n-\n",
			"-\n\t\t-\n",
			"-\n\t-\n-\n"
		]

		for input in failures {
			XCTAssert(parse(tree(0), input) == nil)
		}
	}
}
