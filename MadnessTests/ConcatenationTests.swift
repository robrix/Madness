//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ConcatenationTests: XCTestCase {
	let concatenation = lift(pair) <*> %"x" <*> %"y"

	func testConcatenationRejectsPartialParses() {
		assertUnmatched(concatenation, "x".characters)
	}

	func testConcatenationParsesBothOperands() {
		assertAdvancedBy(concatenation, input: "xyz".characters, offset: 2)
	}

	func testConcatenationProducesPairsOfTerms() {
		let input = "xy".characters
		let parsed = concatenation(input, input.startIndex)
		assertEqual(parsed.right?.0.0, "x")
		assertEqual(parsed.right?.0.1, "y")
	}
}



func matches<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C) -> Bool {
	return parser(input, input.startIndex).right != nil
}

func doesNotMatch<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C) -> Bool {
	return parser(input, input.startIndex).right == nil
}

func assertUnmatched<C: CollectionType, T>(parser: Parser<C, T>.Function, _ input: C, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return assertNil(parser(input, input.startIndex).right, "should not have matched \(input). " + message, file: file, line: line)
}

func assertMatched<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return assertNotNil(parser(input, input.startIndex).right, "should have matched \(input). " + message, file: file, line: line) != nil
}

func assertTree<C: CollectionType, T>(parser: Parser<C, T>.Function, _ input: C, _ match: (T, T) -> Bool, _ tree: T, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	let parsed: Parser<C, T>.Result = parser(input, input.startIndex)
	return Assertions.assert(parsed.right?.0, match, tree, message: "should have parsed \(input) as \(tree). " + message, file: file, line: line)
}

func assertAdvancedBy<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, offset: C.Index.Distance, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> C.Index? {
	return assertEqual(assertNotNil(parser(input, input.startIndex).right, "should have parsed \(input) and advanced by \(offset). " + message, file: file, line: line)?.1, input.startIndex.advancedBy(offset), "should have parsed \(input) and advanced by \(offset). " + message, file, line)
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
