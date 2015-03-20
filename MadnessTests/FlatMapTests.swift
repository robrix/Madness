//  Copyright (c) 2015 Rob Rix. All rights reserved.

private struct Tree<T: Equatable>: Equatable, Printable {
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

private func == <T: Equatable> (left: Tree<T>, right: Tree<T>) -> Bool {
	return left.values == right.values && left.children == right.children
}

final class FlatMapTests: XCTestCase {
	func testFlatMap() {
		let item = ignore("-") ++ %("a"..."z") ++ ignore("\n")
		let tree: Int -> Parser<String, Tree<String>>.Function = fix { tree in
			{ n in
				let line: Parser<String, String>.Function = ignore(%"\t" * n) ++ item
				return line >>- { itemContent in
					(tree(n + 1)* --> { children in Tree(itemContent, children) })
				}
			}
		}

		let fixtures: [String: Tree<String>] = [
			"-a\n": Tree("a"),
			"-a\n\t-b\n": Tree("a", [ Tree("b") ]),
			"-a\n\t-b\n\t-c\n": Tree("a", [ Tree("b"), Tree("c") ]),
			"-a\n\t-b\n\t\t-c\n\t-d\n": Tree("a", [ Tree("b", [ Tree("c") ]), Tree("d") ]),
		]

		for (input, actual) in fixtures {
			if let parsed = parse(tree(0), input).right {
				XCTAssertEqual(parsed, actual)
			} else {
				XCTFail("expected to parse \(input) as \(actual) but failed to parse")
			}
		}

		let failures: [String] = [
			"-a\n-a\n",
			"-a\n\t\t-b\n",
			"-a\n\t-b\n-c\n"
		]

		for input in failures {
			XCTAssert(parse(tree(0), input).right == nil)
		}
	}
}


// MARK: - Imports

import Madness
import Prelude
import XCTest
