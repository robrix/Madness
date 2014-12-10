//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension String {
	func fromOffset(offset: Int) -> String {
		return self[advance(startIndex, offset, endIndex)..<endIndex]
	}
}
