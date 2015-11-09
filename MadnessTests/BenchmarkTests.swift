//  Copyright © 2015 Rob Rix. All rights reserved.

final class BenchmarkTests: XCTestCase {
	func testBenchmarkingMeasuresStuffIGuess() {
		let input = "λa.λb.a"
		print(parse(lambda, input: input))
		print(measurements.measurements)
	}
}


import Madness
import XCTest
