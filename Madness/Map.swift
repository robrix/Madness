//  Copyright (c) 2015 Rob Rix. All rights reserved.

// MARK: - flatMap

/// Returns a parser which requires `parser` to parse, passes its parsed trees to a function `f`, and then requires the result of `f` to parse.
///
/// This can be used to conveniently make a parser which depends on earlier parsed input, for example to parse exactly the same number of characters, or to parse structurally significant indentation.
public func >>- <C: Collection, T, U> (parser: @escaping Parser<C, T>.Function, f: @escaping (T) -> Parser<C, U>.Function) -> Parser<C, U>.Function {
	return { input, index in parser(input, index).flatMap { f($0)(input, $1) } }
}


// MARK: - map

/// Returns a parser which applies `f` to transform the output of `parser`.
public func <^> <C: Collection, T, U> (f: @escaping (T) -> U, parser: @escaping Parser<C, T>.Function) -> Parser<C, U>.Function {
	return parser >>- { pure(f($0)) }
}

/// Returns a parser which first parses `right`, replacing successful parses with `left`.
public func <^ <C: Collection, T, U> (left: T, right: @escaping Parser<C, U>.Function) -> Parser<C, T>.Function {
	return { (_: U) -> T in left } <^> right
}

/// Curried `<^>`. Returns a parser which applies `f` to transform the output of `parser`.
public func map<C: Collection, T, U>(_ f: @escaping (T) -> U) -> (@escaping Parser<C, T>.Function) -> Parser<C, U>.Function {
	return { f <^> $0 }
}


// MARK: - pure

/// Returns a parser which always ignores its input and produces a constant value.
///
/// When combining parsers with `>>-`, allows constant values to be injected into the parser chain.
public func pure<C: Collection, T>(_ value: T) -> Parser<C, T>.Function {
	return { _, index in .success((value, index)) }
}


// MARK: - lift

public func lift<C: Collection, T, U, V>(_ f: @escaping (T, U) -> V) -> Parser<C, (T) -> (U) -> V>.Function {
	return pure({ t in { u in f(t, u) } })
}

public func lift<C: Collection, T, U, V, W>(_ f: @escaping (T, U, V) -> W) -> Parser<C, (T) -> (U) -> (V) -> W>.Function {
	return pure({ t in { u in { v in f(t, u, v) } } })
}


// MARK: - pair

public func pair<A, B>(_ a: A, b: B) -> (A, B) {
	return (a, b)
}


// MARK: - Operators

/// Flat map operator.
infix operator >>- : ChainingPrecedence

/// Map operator.
infix operator <^> : ConcatenationPrecedence

/// Replace operator.
infix operator <^ : ConcatenationPrecedence


import Result
