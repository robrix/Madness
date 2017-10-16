//  Copyright © 2015 Rob Rix. All rights reserved.

/// Parses `open`, followed by `parser` and `close`. Returns the value returned by `parser`.
public func between<C: Collection, T, U, V>(_ open: @escaping Parser<C, T>.Function, _ close: @escaping Parser<C, U>.Function) -> (@escaping Parser<C, V>.Function) -> Parser<C, V>.Function {
	return { open *> $0 <* close }
}

/// Parses 0 or more `parser` until `end`. Returns the list of values returned by `parser`.
public func manyTill<C: Collection, T, U>(_ parser: @escaping Parser<C, T>.Function, _ end: @escaping Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return many(parser) <* end
}
