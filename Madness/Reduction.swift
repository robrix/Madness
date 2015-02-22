//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Returns a parser which maps parse trees into another type.
public func --> <C: CollectionType, T, U>(parser: Parser<C, T>.Function, f: T -> U) -> Parser<C, U>.Function {
	return {
		parser($0).map { (f($0), $1) }
	}
}

/// Returns a parser which maps parse trees into another type.
///
/// This overload also receives the index that parsing ended at.
public func --> <C: CollectionType, T, U>(parser: Parser<C, T>.Function, f: (C, Range<C.Index>, T) -> U) -> Parser<C, U>.Function {
	return { input, index in
		parser(input, index).map { (f(input, index..<$1, $0), $1) }
	}
}
