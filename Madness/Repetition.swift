//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses `parser` 0 or more times.
public postfix func * <S: Sliceable, T> (parser: Parser<S, T>.Function) -> Parser<S, [T]>.Function {
	return repeat(parser, 0..<Int.max)
}

/// Creates a parser from `string`, and parses it 0 or more times.
public postfix func * (string: String) -> Parser<String, [String]>.Function {
	return repeat(%(string), 0..<Int.max)
}

/// Parses `parser` 0 or more times and drops its parse trees.
public postfix func * <S: Sliceable> (parser: Parser<S, ()>.Function) -> Parser<S, ()>.Function {
	return repeat(parser, 0..<Int.max) --> const(())
}

/// Parses `parser` 1 or more times.
public postfix func + <S: Sliceable, T> (parser: Parser<S, T>.Function) -> Parser<S, [T]>.Function {
	return repeat(parser, 1..<Int.max)
}

/// Creates a parser from `string`, and parses it 1 or more times.
public postfix func + (string: String) -> Parser<String, [String]>.Function {
	return repeat(%(string), 1..<Int.max)
}

/// Parses `parser` 0 or more times and drops its parse trees.
public postfix func + <S: Sliceable> (parser: Parser<S, ()>.Function) -> Parser<S, ()>.Function {
	return repeat(parser, 1..<Int.max) --> const(())
}

/// Parses `parser` exactly `n` times.
///
/// `n` must be > 0 to make any sense.
public func * <S: Sliceable, T> (parser: Parser<S, T>.Function, n: Int) -> Parser<S, [T]>.Function {
	return repeat(parser, n...n)
}

/// Parses `parser` the number of times specified in `interval`.
///
/// \param interval  An interval specifying the number of repetitions to perform. `0...n` means at most `n+1` repetitions; `m...Int.max` means at least `m` repetitions; and `m...n` means between `m` and `n` repetitions (inclusive).
public func * <S: Sliceable, T> (parser: Parser<S, T>.Function, interval: ClosedInterval<Int>) -> Parser<S, [T]>.Function {
	return repeat(parser, interval)
}

/// Parses `parser` the number of times specified in `interval`.
///
/// \param interval  An interval specifying the number of repetitions to perform. `0..<n` means at most `n` repetitions; `m..<Int.max` means at least `m` repetitions; and `m..<n` means at least `m` and fewer than `n` repetitions.
public func * <S: Sliceable, T> (parser: Parser<S, T>.Function, interval: HalfOpenInterval<Int>) -> Parser<S, [T]>.Function {
	return repeat(parser, interval)
}


// MARK: - Private

/// Defines repetition for use in the postfix `*` and `+` operator definitions above.
private func repeat<S: Sliceable, T>(parser: Parser<S, T>.Function, _ interval: ClosedInterval<Int> = 0...Int.max) -> Parser<S, [T]>.Function {
	if interval.end <= 0 { return { ([], $0) } }
	
	return { input in
		parser(input).map { first, rest in
			repeat(parser, (interval.start - 1)...(interval.end - (interval.end == Int.max ? 0 : 1)))(rest).map {
				([first] + $0, $1)
			}
		} ?? (interval.start <= 0 ? ([], input) : nil)
	}
}

/// Defines repetition for use in the postfix `*` and `+` operator definitions above.
private func repeat<S: Sliceable, T>(parser: Parser<S, T>.Function, _ interval: HalfOpenInterval<Int> = 0..<Int.max) -> Parser<S, [T]>.Function {
	if interval.isEmpty { return { _ -> ([T], S)? in nil } }
	return repeat(parser, ClosedInterval(interval.start, interval.end.predecessor()))
}


// MARK: - Operators

/// Zero-or-more repetition operator.
postfix operator * {}

/// One-or-more repetition operator.
postfix operator + {}


// MARK: - Imports

import Prelude
