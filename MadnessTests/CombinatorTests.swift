//  Copyright © 2015 Rob Rix. All rights reserved.

final class CombinatorTests: XCTestCase {
	
	// MARK: - between
	
	let braces: StringParser -> StringParser = between(%"{", %"}")
	
	func testBetweenCombinatorParsesSandwichedString(){
		assertTree(braces(%"a"), "{a}".characters, ==, "a")
	}
	
	func testBetweenCombinatorAcceptsEmptyString(){
		assertTree(braces(%""), "{}".characters, ==, "")
	}
	
}


// MARK: - Imports

import Assertions
import Madness
import XCTest