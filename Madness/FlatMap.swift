//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Returns a parser which requires `parser` to parse, passes its parsed trees to a function `f`, and then requires the result of `f` to parse.
///
/// This can be used to conveniently make a parser which depends on earlier parsed input, for example to parse exactly the same number of characters, or to parse structurally significant indentation.
public func >>- <T, U> (parser: Parser<T>.Function, f: T -> Parser<U>.Function) -> Parser<U>.Function {
	return {
		parser($0).map { f($0)($1) } ?? nil
	}
}


// MARK: - Operators

/// Flat map operator.
infix operator >>- {
	associativity left
	precedence 150
}
