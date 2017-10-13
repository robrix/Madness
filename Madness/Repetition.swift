//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parser `parser` 1 or more times.
public func some<C: CollectionType, T> (parser: Parser<C, T>.Function) -> Parser<C, [T]>.Function {
	return prepend <^> require(parser) <*> many(parser)
}

/// Parses 1 or more `parser` separated by `separator`.
public func sepBy1<C: CollectionType, T, U>(parser: Parser<C, T>.Function, _ separator: Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return prepend <^> parser <*> many(separator *> parser)
}

/// Parses 0 or more `parser` separated by `separator`.
public func sepBy<C: CollectionType, T, U>(parser: Parser<C, T>.Function, _ separator: Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return sepBy1(parser, separator) <|> pure([])
}

/// Parses 1 or more `parser` ended by `terminator`.
public func endBy1<C: CollectionType, T, U>(parser: Parser<C, T>.Function, _ terminator: Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return some(parser <* terminator)
}

/// Parses 0 or more `parser` ended by `terminator`.
public func endBy<C: CollectionType, T, U>(parser: Parser<C, T>.Function, _ terminator: Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return many(parser <* terminator)
}

/// Parses `parser` the number of times specified in `interval`.
///
/// \param interval  An interval specifying the number of repetitions to perform. `0...n` means at most `n` repetitions; `m...Int.max` means at least `m` repetitions; and `m...n` means between `m` and `n` repetitions (inclusive).
public func * <C: CollectionType, T> (parser: Parser<C, T>.Function, interval: ClosedInterval<Int>) -> Parser<C, [T]>.Function {
	if interval.end <= 0 { return { .Success(([], $1)) } }

	return (parser >>- { x in { [x] + $0 } <^> (parser * decrement(interval)) })
		<|> { interval.start <= 0 ? .Success(([], $1)) : .Failure(.leaf("expected at least \(interval.start) matches", $1)) }
}

/// Parses `parser` exactly `n` times.		
///
/// `n` must be > 0 to make any sense.
public func * <C: CollectionType, T> (parser: Parser<C, T>.Function, n: Int) -> Parser<C, [T]>.Function {
	return ntimes(parser, n)
}

/// Parses `parser` the number of times specified in `interval`.
///
/// \param interval  An interval specifying the number of repetitions to perform. `0..<n` means at most `n-1` repetitions; `m..<Int.max` means at least `m` repetitions; and `m..<n` means at least `m` and fewer than `n` repetitions; `n..<n` is an error.
public func * <C: CollectionType, T> (parser: Parser<C, T>.Function, interval: HalfOpenInterval<Int>) -> Parser<C, [T]>.Function {
	if interval.isEmpty { return { .Failure(.leaf("cannot parse an empty interval of repetitions", $1)) } }
	return parser * (interval.start...decrement(interval.end))
}

/// Parses `parser` 0 or more times.
public func many<C: CollectionType, T> (p: Parser<C, T>.Function) -> Parser<C, [T]>.Function {
	return prepend <^> require(p) <*> delay { many(p) } <|> pure([])
}

/// Parses `parser` `n` number of times.
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

/// Fails iff `parser` does not consume input, otherwise pass through its results
private func require<C: CollectionType, T> (parser: Parser<C,T>.Function) -> Parser<C, T>.Function {
	return { (input, sourcePos) in
		return parser(input, sourcePos).flatMap { resultInput, resultPos in
			if sourcePos.index == resultPos.index {
				return Result.Failure(Error.leaf("parser did not consume input when required", sourcePos))
			}
			return Result.Success((resultInput, resultPos))
		}
	}
}


// MARK: - Imports

import Result
