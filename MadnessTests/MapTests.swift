//  Copyright (c) 2015 Rob Rix. All rights reserved.

private struct Tree<T: Equatable>: Equatable, CustomStringConvertible {
	init(_ value: T, _ children: [Tree] = []) {
		self.values = [ value ]
		self.children = children
	}

	let values: [T]
	let children: [Tree]


	// MARK: Printable

	var description: String {
		let space = " "
		let valueString = values.map({ String($0) }).joinWithSeparator(space)
		return children.count > 0 ?
			"(\(valueString) \(children.map({ String($0) }).joinWithSeparator(space)))"
		:	"(\(valueString))"
	}
}

private func == <T: Equatable> (left: Tree<T>, right: Tree<T>) -> Bool {
	return left.values == right.values && left.children == right.children
}

private func == <T: Equatable, U: Equatable> (l: (T, U), r: (T, U)) -> Bool {
	return l.0 == r.0 && l.1 == r.1
}

final class MapTests: XCTestCase {

	// MARK: flatMap

	func testFlatMap() {
		let item: Parser<String, String>.Function = %"-" *> String.lift(%("a"..."z")) <* %"\n"
		let tree: Int -> Parser<String, Tree<String>>.Function = fix { tree in
			{ n in
				let line: Parser<String, String>.Function = (%"\t" * n) *> item
				return line >>- { itemContent in
					(tree(n + 1)* |> map { children in Tree(itemContent, children) })
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
			if let parsed = parse(tree(0), input: input).right {
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
			XCTAssert(parse(tree(0), input: input).right == nil)
		}

	}


	// MARK: map

	func testMapTransformsParserOutput() {
		assertTree(String.init <^> %123, [123], ==, "123")
	}

	func testMapHasHigherPrecedenceThanFlatMap() {
		let addTwo = { $0 + 2 }
		let triple = { $0 * 3 }

		let parser: Parser<[Int], Int>.Function = addTwo <^> %2 >>- { i in triple <^> pure(i) }

		assertTree(parser, [2], ==, 12)
	}

	func testReplaceConsumesItsInput() {
		assertTree(("abc" <^ %123) <*> %0, [123, 0], ==, ("abc", 0))
	}

	func testCurriedMap() {
		assertTree(%123 |> map({ String($0) }), [123], ==, "123")
	}


	// MARK: pure

	func testPureIgnoresItsInput() {
		assertTree(pure("a"), "b".characters, ==, "a")
	}
}


// MARK: - Imports

import Madness
import Prelude
import XCTest
