//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses `parser` 0 or more times.
public postfix func * <C: CollectionType, T> (parser: Parser<C, T>.Function) -> Parser<C, [T]>.Function {
	return many(parser)
}

/// Creates a parser from `string`, and parses it 0 or more times.
public postfix func * (string: String) -> Parser<String.CharacterView, [String]>.Function {
	return { $0.map { String($0) } } <^> many(%(string.characters))
}

public func some<C: CollectionType, T> (parser: Parser<C, T>.Function) -> Parser<C, [T]>.Function {
	return prepend <^> parser <*> many(parser)
}

/// Parses `parser` 1 or more times.
public postfix func + <C: CollectionType, T> (parser: Parser<C, T>.Function) -> Parser<C, [T]>.Function {
	return some(parser)
}

/// Creates a parser from `string`, and parses it 1 or more times.
public postfix func + (string: String) -> Parser<String.CharacterView, [String]>.Function {
	return some({ String($0) } <^> %(string.characters))
}


/// Parses `parser` exactly `n` times.
///
/// `n` must be > 0 to make any sense.
public func * <C: CollectionType, T> (parser: Parser<C, T>.Function, n: Int) -> Parser<C, [T]>.Function {
	return ntimes(parser, n)
}

/// Parses `parser` the number of times specified in `interval`.
///
/// \param interval  An interval specifying the number of repetitions to perform. `0...n` means at most `n` repetitions; `m...Int.max` means at least `m` repetitions; and `m...n` means between `m` and `n` repetitions (inclusive).
public func * <C: CollectionType, T> (parser: Parser<C, T>.Function, interval: ClosedInterval<Int>) -> Parser<C, [T]>.Function {
	if interval.end <= 0 { return { .Right([], $1) } }

	return (parser >>- { x in { [x] + $0 } <^> (parser * decrement(interval)) })
		<|> { interval.start <= 0 ? .Right([], $1) : .left(.leaf("expected at least \(interval.start) matches", $1)) }
}

/// Parses `parser` the number of times specified in `interval`.
///
/// \param interval  An interval specifying the number of repetitions to perform. `0..<n` means at most `n-1` repetitions; `m..<Int.max` means at least `m` repetitions; and `m..<n` means at least `m` and fewer than `n` repetitions; `n..<n` is an error.
public func * <C: CollectionType, T> (parser: Parser<C, T>.Function, interval: HalfOpenInterval<Int>) -> Parser<C, [T]>.Function {
	if interval.isEmpty { return { .left(.leaf("cannot parse an empty interval of repetitions", $1)) } }
	return parser * (interval.start...decrement(interval.end))
}

public func many<C: CollectionType, T> (p: Parser<C, T>.Function) -> Parser<C, [T]>.Function {
	return prepend <^> p <*> delay { many(p) } <|> pure([])
}

public func ntimes<C: CollectionType, T> (p: Parser<C, T>.Function, _ n: Int) -> Parser<C, [T]>.Function {
	guard n > 0 else { return pure([]) }
	return prepend <^> p <*> delay { ntimes(p, n - 1) }
}


// MARK: - Private

/// Decrements `x` iff it is not equal to `Int.max`.
private func decrement(x: Int) -> Int {
	return (x == Int.max ? Int.max : x - 1)
}

private func decrement(x: ClosedInterval<Int>) -> ClosedInterval<Int> {
	return decrement(x.start)...decrement(x.end)
}


// MARK: - Operators

/// Zero-or-more repetition operator.
postfix operator * {}

/// One-or-more repetition operator.
postfix operator + {}


// MARK: - Imports

import Either
import Prelude
