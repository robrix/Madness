//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class AlternationTests: XCTestCase {

	// MARK: Alternation

	func testAlternationParsesEitherAlternative() {
		assertAdvancedBy(alternation, input: "xy".characters, lineOffset: 0, columnOffset: 1, offset: 1)
		assertAdvancedBy(alternation, input: "yx".characters, lineOffset: 0, columnOffset: 1, offset: 1)
	}

	func testAlternationOfASingleTypeCoalescesTheParsedValue() {
		assertTree(alternation, "xy".characters, ==, "x")

	}


	// MARK: Optional

	func testOptionalProducesWhenPresent() {
		assertTree(optional, "y".characters, ==, "y")
		assertTree(prefixed, "xy".characters, ==, "xy")
		assertTree(suffixed, "yzsandwiched".characters, ==, "yz")
	}

	func testOptionalProducesWhenAbsent() {
		assertTree(optional, "".characters, ==, "")
		assertTree(prefixed, "x".characters, ==, "x")
		assertTree(suffixed, "z".characters, ==, "z")
		assertTree(sandwiched, "xz".characters, ==, "xz")
	}


	// MARK: One-of

	func testOneOfParsesFirstMatch() {
		assertTree(one, "xyz".characters, ==, "x")
		assertTree(one, "yzx".characters, ==, "y")
		assertTree(one, "zxy".characters, ==, "z")
	}

	// MARK: Any-of

	func testAnyOfParsesAnArrayOfMatchesPreservingOrder() {
		assertTree(any, "xy".characters, ==, ["x", "y"])
		assertTree(any, "yx".characters, ==, ["y", "x"])
		assertTree(any, "zxy".characters, ==, ["z", "x", "y"])
	}

	func testAnyOfRejectsWhenNoneMatch() {
		
		assertUnmatched(anyOf(Set("x")), Set("y".characters))
	}

	func testAnyOfOnlyParsesFirstMatch() {
		assertTree(any, "xyy".characters, ==, ["x", "y"])
	}


	// MARK: All-of

	func testAllOfParsesAnArrayOfMatchesPreservingOrder() {
		assertTree(all, "xy".characters, ==, ["x", "y"])
		assertTree(all, "yx".characters, ==, ["y", "x"])
		assertTree(all, "zxy".characters, ==, ["z", "x", "y"])
	}

	func testAllOfRejectsWhenNoneMatch() {
		assertUnmatched(allOf(Set("x")), Set(["y"]))
	}
}

// MARK: - Fixtures

private let alternation = %"x" <|> %"y"

private let optional = map({ $0 ?? "" })((%"y")|?)
private let prefixed = { x in { y in x + y } } <^> %"x" <*> optional
private let suffixed = { x in { y in x + y } } <^> optional <*> %"z"
private let sandwiched = { x in { y in x + y } } <^> prefixed <*> %"z"

private let arrayOfChars: Set<Character> = ["x", "y", "z"]
private let chars: String = "xyz"
private let one = oneOf(chars)
private let any: Parser<String.CharacterView, [Character]>.Function  = anyOf(arrayOfChars)
private let all: Parser<String.CharacterView, [Character]>.Function  = allOf(arrayOfChars)

// MARK: - Imports

import Madness
import Result
import XCTest
