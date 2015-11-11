//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ConcatenationTests: XCTestCase {
	let concatenation = lift(pair) <*> %"x" <*> %"y"

	func testConcatenationRejectsPartialParses() {
		assertUnmatched(concatenation, "x".characters)
	}

	func testConcatenationParsesBothOperands() {
		assertAdvancedBy(concatenation, input: "xyz".characters, lineOffset: 0, columnOffset: 2, offset: 2)
	}

	func testConcatenationProducesPairsOfTerms() {
		let input = "xy".characters
		let parsed = concatenation(input, SourcePos(index: input.startIndex))
		assertEqual(parsed.right?.0.0, "x")
		assertEqual(parsed.right?.0.1, "y")
	}
}



func matches<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C) -> Bool {
	return parser(input, SourcePos(index: input.startIndex)).right != nil
}

func doesNotMatch<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C) -> Bool {
	return parser(input, SourcePos(index: input.startIndex)).right == nil
}

func assertUnmatched<C: CollectionType, T>(parser: Parser<C, T>.Function, _ input: C, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return assertNil(parser(input, SourcePos(index: input.startIndex)).right, "should not have matched \(input). " + message, file: file, line: line)
}

func assertMatched<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> Bool {
	return assertNotNil(parser(input, SourcePos(index: input.startIndex)).right, "should have matched \(input). " + message, file: file, line: line) != nil
}

func assertTree<C: CollectionType, T>(parser: Parser<C, T>.Function, _ input: C, _ match: (T, T) -> Bool, _ tree: T, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> T? {
	let parsed: Parser<C, T>.Result = parser(input, SourcePos(index: input.startIndex))
	return Assertions.assert(parsed.right?.0, match, tree, message: "should have parsed \(input) as \(tree). " + message, file: file, line: line)
}

func assertAdvancedBy<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, offset: C.Index.Distance, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> SourcePos<C.Index>? {
	let pos = SourcePos(index: input.startIndex)
	let newSourcePos: SourcePos<C.Index>? = SourcePos.init(line: pos.line, column: pos.column, index: pos.index.advancedBy(offset))

	let x = assertNotNil(parser(input, pos).right, "should have parsed \(input) and advanced by \(offset). " + message, file: file, line: line)?.1
	return assertEqual(x, newSourcePos, "should have parsed \(input) and advanced by \(offset). " + message, file, line)
}

func assertAdvancedBy<C: CollectionType, T>(parser: Parser<C, T>.Function, input: C, lineOffset: Line, columnOffset: Column, offset: C.Index.Distance, message: String = "", file: String = __FILE__, line: UInt = __LINE__) -> SourcePos<C.Index>? {
	let pos = SourcePos(index: input.startIndex)
	let newSourcePos: SourcePos<C.Index>? = SourcePos.init(line: pos.line.advancedBy(lineOffset), column: pos.column.advancedBy(columnOffset), index: pos.index.advancedBy(offset))

	let x = assertNotNil(parser(input, pos).right, "should have parsed \(String(input)) and advanced by \(offset). " + message, file: file, line: line)?.1
	return assertEqual(x, newSourcePos, "should have parsed \(String(input)) and advanced by \(offset). " + message, file, line)
}


// MARK: - Imports

import Assertions
import Madness
import XCTest
