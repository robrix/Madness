//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension String {
	func fromOffset(offset: Int) -> String {
		return self[advance(startIndex, offset, endIndex)..<endIndex]
	}

	func toOffset(offset: Int) -> String {
		return self[startIndex..<advance(startIndex, offset, endIndex)]
	}
}
