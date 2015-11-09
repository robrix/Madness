//  Copyright © 2015 Rob Rix. All rights reserved.

public final class Measurements {
	public init() {
		measurements = [:]
	}

	public typealias Measurement = (total: NSTimeInterval, count: Int)
	public typealias Label = String

	public var measurements: [Label: Measurement]

	public func benchmark<C: CollectionType, T>(label: Label)(_ parser: Parser<C, T>.Function)(_ input: C, _ index: C.Index) -> Parser<C, T>.Result {
		let start = NSDate.timeIntervalSinceReferenceDate()
		let result = parser(input, index)
		if let (total, count) = measurements[label] {
			measurements[label] = Measurement(total: total + (NSDate.timeIntervalSinceReferenceDate() - start), count: count + 1)
		} else {
			measurements[label] = Measurement(total: NSDate.timeIntervalSinceReferenceDate() - start, count: 1)
		}
		return result
	}
}


import Foundation
