//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class AlternationTests: XCTestCase {

	// MARK: Alternation

	func testAlternationParsesEitherAlternative() {
		assertAdvancedBy(alternation, input: "xy".characters, lineOffset: 0, columnOffset: 1, offset: 1)
		assertAdvancedBy(alternation, input: "yx".characters, lineOffset: 0, columnOffset: 1, offset: 1)
	}

	func testAlternationProducesTheParsedAlternative() {
		assertTree(alternation, "xy".characters, ==, Either.left("x"))
	}

	func testAlternationOfASingleTypeCoalescesTheParsedValue() {
		assertTree(%"x" <|> %"y", "xy", ==, "x")

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

private let alternation = %"x" <|> (%"y" --> { _, _, _, _, _ in 1 })

private let optional = (%"y")|? |> map { $0 ?? "" }
private let prefixed = curry { $0 + $1 } <^> %"x" <*> optional
private let suffixed = curry { $0 + $1 } <^> optional <*> %"z"
private let sandwiched = curry { $0 + $1 } <^> prefixed <*> %"z"

private let arrayOfChars: Set<Character> = ["x", "y", "z"]
private let chars: String = "xyz"
private let one = oneOf(chars)
private let any: Parser<String.CharacterView, [Character]>.Function  = anyOf(arrayOfChars)
private let all: Parser<String.CharacterView, [Character]>.Function  = allOf(arrayOfChars)

// MARK: - Imports

import Assertions
import Either
import Madness
import Prelude
import XCTest
