//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Returns a parser which maps parse trees into another type.
public func --> <C: Collection, T, U>(parser: @escaping Parser<C, T>.Function, f: @escaping (C, CountableClosedRange<Line>, CountableClosedRange<Column>, Range<C.Index>, T) -> U) -> Parser<C, U>.Function {
	return { input, inputPos in
		return parser(input, inputPos).map { output, outputPos in
			(f(input, inputPos.line...outputPos.line, outputPos.column...outputPos.column, inputPos.index..<outputPos.index, output), outputPos)
		}
	}
}

/// Returns a parser which maps parse results.
///
/// This enables e.g. adding identifiers for error handling.
public func --> <C: Collection, T, U> (parser: @escaping Parser<C, T>.Function, transform: @escaping (Parser<C, T>.Result) -> Parser<C, U>.Result) -> Parser<C, U>.Function {
	return {  transform(parser($0, $1)) }
}
