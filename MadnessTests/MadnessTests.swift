//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Either
import Madness
import Prelude
import XCTest

final class MadnessTests: XCTestCase {

	// MARK: - Terminals

	func testLiteralParsersParseAPrefixOfTheInput() {
		assertEqual(literal("foo")("foot")?.1, "t")
		assertNil(literal("foo")("fo"))
		assertNil(literal("foo")("fo"))
	}

	func testLiteralParsersProduceTheirArgument() {
		assertEqual(literal("foo")("foot")?.0, "foo")
	}


	let digits = range("0"..."9")

	func testRangeParsersParseAnyCharacterInTheirRange() {
		assertEqual(digits("0")?.0, "0")
		assertEqual(digits("5")?.0, "5")
		assertEqual(digits("9")?.0, "9")
	}

	func testRangeParsersRejectCharactersOutsideTheRange() {
		assertNil(digits("a"))
	}


	// MARK: - Nonterminals

	// MARK: Concatenation

	let concatenation = literal("x") ++ literal("y")

	func testConcatenationRejectsPartialParses() {
		assertNil(concatenation("x"))
	}

	func testConcatenationParsesBothOperands() {
		assertEqual(concatenation("xyz")?.1, "z")
	}

	func testConcatenationProducesPairsOfTerms() {
		let parsed = concatenation("xy")
		assertEqual(parsed?.0.0, "x")
		assertEqual(parsed?.0.1, "y")
	}


	// MARK: Alternation

	let alternation = literal("x") | (literal("y") --> const(1))

	func testAlternationParsesEitherAlternative() {
		assertEqual(alternation("xy")?.1, "y")
		assertEqual(alternation("yx")?.1, "x")
	}

	func testAlternationProducesTheParsedAlternative() {
		assertEqual(alternation("xy")?.0, Either.left("x"))
	}

	func testAlternationOfASingleTypeCoalescesTheParsedValue() {
		assertEqual((literal("x") | literal("y"))("xy")?.0, "x")
	}


	// MARK: Repetition

	let zeroOrMore = literal("x")*

	func testZeroOrMoreRepetitionAcceptsTheEmptyString() {
		assertNotNil(zeroOrMore(""))
	}

	func testZeroOrMoreRepetitionAcceptsUnmatchedStrings() {
		assertNotNil(zeroOrMore("y"))
	}

	func testZeroOrMoreRepetitionDoesNotAdvanceWithUnmatchedStrings() {
		assertEqual(zeroOrMore("y")?.1, "y")
	}

	func testZeroOrMoreRepetitionParsesUnmatchedStringsAsEmptyArrays() {
		assertEqual(zeroOrMore("y")?.0, [])
	}

	func testZeroOrMoreRepetitionParsesAMatchedString() {
		assertEqual(zeroOrMore("x")?.0, ["x"])
	}

	func testZeroOrMoreRepetitionParsesMatchedStrings() {
		assertEqual(zeroOrMore("xx")?.0, ["x", "x"])
	}


	let oneOrMore = literal("x")+

	func testOneOrMoreRepetitionRejectsTheEmptyString() {
		assertNil(oneOrMore(""))
	}

	func testOneOrMoreRepetitionParsesASingleMatchedString() {
		assertEqual(oneOrMore("x")?.0, ["x"])
	}

	func testOneOrMoreRepetitonParsesMultipleMatchedStrings() {
		assertEqual(oneOrMore("xxy")?.0, ["x", "x"])
	}


	let exactlyN = literal("x") * 3

	func testExactlyNRepetitionParsesNTrees() {
		assertEqual(exactlyN("xxx")?.0, ["x", "x", "x"])
	}

	func testExactlyNRepetitionParsesRejectsFewerMatches() {
		assertNil(exactlyN("xx"))
	}

	func testExactlyNRepetitionParsesStopsAtN() {
		assertEqual(exactlyN("xxxx")?.1, "x")
	}


	let zeroToN = literal("x") * (0..<2)

	func testZeroToNRepetitionParsesZeroTrees() {
		assertEqual(zeroToN("y")?.0, [])
	}

	func testZeroToNRepetitionParsesUpToNTrees() {
		assertEqual(zeroToN("xxx")?.0, ["x", "x"])
		assertEqual(zeroToN("xxx")?.1, "x")
	}


	let atLeastN = literal("x") * (2..<Int.max)

	func testAtLeastNRepetitionRejectsZeroTrees() {
		assertNil(atLeastN("y"))
	}

	func testAtLeastNRepetitionParsesNTrees() {
		assertEqual(atLeastN("xx")?.0, ["x", "x"])
	}

	func testAtLeastNRepetitionParsesMoreThanNTrees() {
		assertEqual(atLeastN("xxxx")?.0, ["x", "x", "x", "x"])
	}


	let mToN = literal("x") * (2..<3)

	func testMToNRepetitionRejectsLessThanM() {
		assertNil(mToN("x"))
	}

	func testMToNRepetitionMatchesUpToN() {
		assertEqual(mToN("xxxx")?.1, "x")
	}


	// MARK: Ignoring

	let ignored = ignore(literal("x"))

	func testIgnoredInputDoesNotGetConcatenatedAtLeft() {
		assertEqual((ignored ++ literal("y"))("xy")?.0, "y")
	}

	func testIgnoredInputDoesNotGetConcatenatedAtRight() {
		assertEqual((literal("y") ++ ignored)("yx")?.0, "y")
	}

	func testIgnoredInputIsDroppedFromAltenationsAtLeft() {
		assertEqual((ignored | literal("y"))("y")?.0, "y")
	}

	func testIgnoredInputIsDroppedFromAltenationsAtRight() {
		assertEqual((literal("y") | ignored)("y")?.0, "y")
	}

	func testRepeatedIgnoredEmptyParsesAreDropped() {
		assertEqual((ignored* ++ literal("y"))("y")?.0, "y")
	}

	func testRepeatedIgnoredParsesAreDropped() {
		assertEqual((ignored* ++ literal("y"))("xxy")?.0, "y")
	}


	// MARK: - Assertions

	func assertEqual<T: Equatable>(expression1: @autoclosure () -> T?, _ expression2: @autoclosure () -> T?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) {
		let (actual, expected) = (expression1(), expression2())
		if actual != expected { XCTFail("\(actual) is not equal to \(expected). " + message, file: file, line: line) }
	}

	func assertEqual<T: Equatable, U: Equatable>(expression1: @autoclosure () -> Either<T, U>?, _ expression2: @autoclosure () -> Either<T, U>?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) {
		let (actual, expected) = (expression1(), expression2())
		switch (actual, expected) {
		case (.None, .None):
			break
		case let (.Some(x), .Some(y)) where x == y:
			break
		default:
			XCTFail("\(actual) is not equal to \(expected). " + message, file: file, line: line)
		}
	}

	func assertEqual<T: Equatable>(expression1: @autoclosure () -> [T]?, _ expression2: @autoclosure () -> [T]?, _ message: String = "", _ file: String = __FILE__, _ line: UInt = __LINE__) {
		let (actual, expected) = (expression1(), expression2())
		switch (actual, expected) {
		case (.None, .None):
			break
		case let (.Some(x), .Some(y)) where x == y:
			break
		default:
			XCTFail("\(actual) is not equal to \(expected). " + message, file: file, line: line)
		}
	}

	func assertNil<T>(expression: @autoclosure () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
		let actual = expression()
		if actual != nil { XCTFail("\(actual) is not nil. " + message, file: file, line: line) }
	}

	func assertNotNil<T>(expression: @autoclosure () -> T?, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
		let actual = expression()
		if actual == nil { XCTFail("\(actual) is nil. " + message, file: file, line: line) }
	}
}
