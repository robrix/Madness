//  Copyright (c) 2015 Rob Rix. All rights reserved.

// MARK: - flatMap

/// Returns a parser which requires `parser` to parse, passes its parsed trees to a function `f`, and then requires the result of `f` to parse.
///
/// This can be used to conveniently make a parser which depends on earlier parsed input, for example to parse exactly the same number of characters, or to parse structurally significant indentation.
public func >>- <C: CollectionType, T, U> (parser: Parser<C, T>.Function, f: T -> Parser<C, U>.Function) -> Parser<C, U>.Function {
	return { input, index in
		parser(input, index).map { f($0)(input, $1) } ?? nil
	}
}


// MARK: - map

/// Returns a parser which applies `f` to transform the output of `parser`.
public func <^> <C: CollectionType, T, U> (f: T -> U, parser: Parser<C, T>.Function) -> Parser<C, U>.Function {
	return parser >>- { pure(f($0)) }
}


// MARK: - pure

/// Returns a parser which always ignores its input and produces a constant value.
///
/// When combining parsers with `>>-`, allows constant values to be injected into the parser chain.
public func pure<C: CollectionType, T>(value: T) -> Parser<C, T>.Function {
	return { _, index in (value, index) }
}


// MARK: - Operators

/// Flat map operator.
infix operator >>- {
	associativity left
	precedence 150
}

/// Map operator.
infix operator <^> {
	associativity left

	// Higher precedence than `>>-`.
	precedence 155
}
