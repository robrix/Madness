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
		XCTAssertEqual(parsed.value?.0.0, "x")
		XCTAssertEqual(parsed.value?.0.1, "y")
	}
}



func matches<C: Collection, T>(_ parser: Parser<C, T>.Function, input: C) -> Bool {
	return parser(input, SourcePos(index: input.startIndex)).value != nil
}

func doesNotMatch<C: Collection, T>(_ parser: Parser<C, T>.Function, input: C) -> Bool {
	return parser(input, SourcePos(index: input.startIndex)).value == nil
}

func assertUnmatched<C: Collection, T>(_ parser: Parser<C, T>.Function, _ input: C, message: String = "", file: StaticString = #file, line: UInt = #line) {
	XCTAssertNil(parser(input, SourcePos(index: input.startIndex)).value, "should not have matched \(input). " + message, file: file, line: line)
}

func assertMatched<C: Collection, T>(_ parser: Parser<C, T>.Function, input: C, message: String = "", file: StaticString = #file, line: UInt = #line) {
	XCTAssertNotNil(parser(input, SourcePos(index: input.startIndex)).value, "should have matched \(input). " + message, file: file, line: line)
}

func assertTree<C: Collection, T>(_ parser: Parser<C, T>.Function, _ input: C, _ match: @escaping (T, T) -> Bool, _ tree: T, message: String = "", file: StaticString = #file, line: UInt = #line) {
	let parsed: Parser<C, T>.Result = parser(input, SourcePos(index: input.startIndex))
	let value = parsed.value?.0
	XCTAssert(value.map { match($0, tree) } ?? false, "should have parsed \(input) as \(tree). " + message, file: file, line: line)
}

func assertAdvancedBy<C: Collection, T>(_ parser: Parser<C, T>.Function, input: C, offset: C.IndexDistance, message: String = "", file: StaticString = #file, line: UInt = #line) {
	let pos = SourcePos(index: input.startIndex)
	let newSourcePos: SourcePos<C.Index>? = SourcePos(line: pos.line, column: pos.column, index: input.index(pos.index, offsetBy: offset))

	let value = parser(input, pos).value
	XCTAssertNotNil(value, "should have parsed \(input) and advanced by \(offset). " + message, file: file, line: line)
	XCTAssertEqual(value?.1, newSourcePos, "should have parsed \(input) and advanced by \(offset). " + message, file: file, line: line)
}

func assertAdvancedBy<C: Collection, T>(_ parser: Parser<C, T>.Function, input: C, lineOffset: Line, columnOffset: Column, offset: C.IndexDistance, message: String = "", file: StaticString = #file, line: UInt = #line) {
	let pos = SourcePos(index: input.startIndex)
	let newSourcePos: SourcePos<C.Index>? = SourcePos(line: pos.line + lineOffset, column: pos.column + columnOffset, index: input.index(pos.index, offsetBy: offset))

	let value = parser(input, pos).value
	XCTAssertNotNil(value, "should have parsed \(String(describing: input)) and advanced by \(offset). " + message, file: file, line: line)
	XCTAssertEqual(value?.1, newSourcePos, "should have parsed \(String(describing: input)) and advanced by \(offset). " + message, file: file, line: line)
}


// MARK: - Imports

import Madness
import XCTest
