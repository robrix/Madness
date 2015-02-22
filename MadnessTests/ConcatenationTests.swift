//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ConcatenationTests: XCTestCase {
	let concatenation = %"x" ++ %"y"

	func testConcatenationRejectsPartialParses() {
		assertUnmatched(concatenation, "x")
	}

	func testConcatenationParsesBothOperands() {
		assertAdvancedBy(concatenation, "xyz", 2)
	}

	func testConcatenationProducesPairsOfTerms() {
		let input = "xy"
		let parsed = concatenation(input, input.startIndex)
		assertEqual(parsed?.0.0, "x")
		assertEqual(parsed?.0.1, "y")
	}
}



func matches<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C) -> Bool {
	return parser(input, input.startIndex) != nil
}

func doesNotMatch<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C) -> Bool {
	return parser(input, input.startIndex) == nil
}

func assertUnmatched<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return assertNil(parser(input, input.startIndex), "should not have matched \(input). " + message, file: file, line: line)
}

func assertMatched<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return assertNotNil(parser(input, input.startIndex), "should have matched \(input). " + message, file: file, line: line) != nil
}

func assertTree<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, match: (T, T) -> Bool, tree: T, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	let parsed: Parser<C, T>.Result = parser(input, input.startIndex)
	return Assertions.assert(parsed?.0, match, tree, message: "should have parsed \(input) as \(tree). " + message, file: file, line: line)
}

func assertTree<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, match: ((T, C.Index), T) -> Bool, tree: T, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> (T, C.Index)? {
	let parsed: Parser<C, T>.Result = parser(input, input.startIndex)
	return Assertions.assert(parsed, match, tree, message: "should have parsed \(input) as \(tree). " + message, file: file, line: line)
}

func assertAdvancedBy<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, offset: C.Index.Distance, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> C.Index? {
	return assertEqual(assertNotNil(parser(input, input.startIndex), "should have parsed \(input) and advanced by \(offset). " + message, file: file, line: line)?.1, advance(input.startIndex, offset), "should have parsed \(input) and advanced by \(offset). " + message, file, line)
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
