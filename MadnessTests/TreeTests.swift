//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Madness
import XCTest

final class TreeTests: XCTestCase {
	func testConcatenationOfTermsFlattensWithAt() {
		let f: Parser<String>.Function = %"f"
		let ef: Parser<(String, String)>.Function = %"e" ++ f
		let def: Parser<(String, (String, String))>.Function = %"d" ++ ef
		let cdef: Parser<(String, (String, (String, String)))>.Function = %"c" ++ def
		let bcdef: Parser<(String, (String, (String, (String, String))))>.Function = %"b" ++ cdef
		let abcdef: Parser<(String, (String, (String, (String, (String, String)))))>.Function = %"a" ++ bcdef
		let parser: Parser<String>.Function = abcdef --> { (tree: (String, (String, (String, (String, (String, String)))))) -> String in
			let f: String = at5(tree)
			let ef: String = at4(tree) + f
			let def: String = at3(tree) + ef
			let cdef: String = at2(tree) + def
			let bcdef: String = at1(tree) + cdef
			let abcdef: String = at0(tree) + bcdef
			return abcdef
		}

		let another = %"a" ++ %"b" ++ %"c" ++ %"d" --> { at0($0) + at1($0) + at2($0) + at3($0) }

		XCTAssertEqual(parse(parser, "abcdef") ?? "", "abcdef")
	}
}
