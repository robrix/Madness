//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Madness
import XCTest

final class MadnessTests: XCTestCase {
	func testLiteralParsersParseAPrefixOfTheInput() {
		XCTAssertEqual(literal("foo")("foot")?.1 ?? "💀", "t")
	}
}
