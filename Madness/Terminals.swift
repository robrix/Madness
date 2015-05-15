//  Copyright (c) 2015 Rob Rix. All rights reserved.

func literal<T: Equatable>(element: T) -> Prism<Stream<T>, T> {
	return Prism(
		forward: { $0.first == element ? $0.first : nil },
		backward: Stream.pure)
}


import Stream
