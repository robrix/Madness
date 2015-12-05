//  Copyright © 2015 Rob Rix. All rights reserved.

/// Parses `open`, followed by `parser` and `close`. Returns the value returned by `parser`.
public func between<C: CollectionType, T, U, V>(open: Parser<C, T>.Function, _ close: Parser<C, U>.Function) -> Parser<C, V>.Function -> Parser<C, V>.Function {
	return { open *> $0 <* close }
}

/// Parses 0 or more `parser` until `end`. Returns the list of values returned by `parser`.
public func manyTill<C: CollectionType, T, U>(parser: Parser<C, T>.Function, _ end: Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return many(parser) <* end
}