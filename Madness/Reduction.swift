//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Returns a parser which maps parse trees into another type.
public func --> <C: CollectionType, T, U>(parser: Parser<C, T>.Function, f: (C, Range<Line>, Range<Column>, Range<C.Index>, T) -> U) -> Parser<C, U>.Function {
	return { input, inputPos in
		parser(input, inputPos).map { output, outputPos in
			(f(input, inputPos.line...outputPos.line, inputPos.column...outputPos.column, inputPos.index..<outputPos.index, output), outputPos)
		}
	}
}

public func --> <C: CollectionType, T, U>(parser: Parser<C, T>.Function, f: (Range<Line>, Range<Column>, Range<C.Index>, T) -> U) -> Parser<C, U>.Function {
	return parser --> { f($1, $2, $3, $4) }
}



/// Returns a parser which maps parse results.
///
/// This enables e.g. adding identifiers for error handling.
public func --> <C: CollectionType, T, U> (parser: Parser<C, T>.Function, transform: Parser<C, T>.Result -> Parser<C, U>.Result) -> Parser<C, U>.Function {
	return parser >>> transform
}


import Prelude
