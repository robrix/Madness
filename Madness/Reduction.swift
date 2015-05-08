//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Returns a parser which maps parse trees into another type.
public func --> <C: CollectionType, T, U>(parser: Parser<C, T>.Function, f: (C, Range<C.Index>, T) -> U) -> Parser<C, U>.Function {
	return { input, index in
		parser(input, index).map { (f(input, index..<$1, $0), $1) }
	}
}
