//  Copyright © 2015 Rob Rix. All rights reserved.

final class CombinatorTests: XCTestCase {
	
	// MARK: - between
	
	let braces: (@escaping StringParser) -> StringParser = between(%"{", %"}")
	
	func testBetweenCombinatorParsesSandwichedString(){
		assertTree(braces(%"a"), "{a}".characters, ==, "a")
	}
	
	func testBetweenCombinatorAcceptsEmptyString(){
		assertTree(braces(%""), "{}".characters, ==, "")
	}
	
	// MARK: - manyTill
	
	let digits = manyTill(digit, %",")
	
	func testManyTillCombinatorParsesElementsUntilEndParser(){
		assertTree(digits, "123,".characters, ==, ["1", "2", "3"])
	}
	
	func testManyTillCombinatorAcceptsEmptyString(){
		assertTree(digits, ",".characters, ==, [])
	}
	
}


// MARK: - Imports

import Madness
import XCTest
