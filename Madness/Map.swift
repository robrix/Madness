//  Copyright (c) 2015 Rob Rix. All rights reserved.

// MARK: - flatMap

/// Returns a parser which requires `parser` to parse, passes its parsed trees to a function `f`, and then requires the result of `f` to parse.
///
/// This can be used to conveniently make a parser which depends on earlier parsed input, for example to parse exactly the same number of characters, or to parse structurally significant indentation.
public func >>- <C: CollectionType, T, U> (parser: Parser<C, T>.Function, f: T -> Parser<C, U>.Function) -> Parser<C, U>.Function {
	return { input, index in parser(input, index).flatMap { f($0)(input, $1) } }
}


// MARK: - map

/// Returns a parser which applies `f` to transform the output of `parser`.
public func <^> <C: CollectionType, T, U> (f: T -> U, parser: Parser<C, T>.Function) -> Parser<C, U>.Function {
	return parser >>- { pure(f($0)) }
}

/// Returns a parser which first parses `right`, replacing successful parses with `left`.
public func <^ <C: CollectionType, T, U> (left: T, right: Parser<C, U>.Function) -> Parser<C, T>.Function {
	return const(left) <^> right
}

/// Curried `<^>`. Returns a parser which applies `f` to transform the output of `parser`.
public func map<C: CollectionType, T, U>(f: T -> U) -> Parser<C, T>.Function -> Parser<C, U>.Function {
	return { f <^> $0 }
}


// MARK: - pure

/// Returns a parser which always ignores its input and produces a constant value.
///
/// When combining parsers with `>>-`, allows constant values to be injected into the parser chain.
public func pure<C: CollectionType, T>(value: T) -> Parser<C, T>.Function {
	return { _, index in .Right(value, index) }
}


// MARK: - lift

public func lift<C: CollectionType, T, U, V>(f: (T, U) -> V) -> Parser<C, T -> U -> V>.Function {
	return pure(curry(f))
}

public func lift<C: CollectionType, T, U, V, W>(f: (T, U, V) -> W) -> Parser<C, T -> U -> V -> W>.Function {
	return pure(curry(f))
}


// MARK: - pair

public func pair<A, B>(a: A, b: B) -> (A, B) {
	return (a, b)
}


// MARK: - Operators

/// Flat map operator.
infix operator >>- {
	associativity left
	precedence 100
}

/// Map operator.
infix operator <^> {
	associativity left
	precedence 130
}

/// Replace operator.
infix operator <^ {
	associativity left
	precedence 130
}


import Either
import Prelude
