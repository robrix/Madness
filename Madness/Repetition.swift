//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parser `parser` 1 or more times.
public func some<C: Collection, T> (_ parser: @escaping Parser<C, T>.Function) -> Parser<C, [T]>.Function {
	return prepend <^> require(parser) <*> many(parser)
}

/// Parses 1 or more `parser` separated by `separator`.
public func sepBy1<C: Collection, T, U>(_ parser: @escaping Parser<C, T>.Function, _ separator: @escaping Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return prepend <^> parser <*> many(separator *> parser)
}

/// Parses 0 or more `parser` separated by `separator`.
public func sepBy<C: Collection, T, U>(_ parser: @escaping Parser<C, T>.Function, _ separator: @escaping Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return sepBy1(parser, separator) <|> pure([])
}

/// Parses 1 or more `parser` ended by `terminator`.
public func endBy1<C: Collection, T, U>(_ parser: @escaping Parser<C, T>.Function, _ terminator: @escaping Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return some(parser <* terminator)
}

/// Parses 0 or more `parser` ended by `terminator`.
public func endBy<C: Collection, T, U>(_ parser: @escaping Parser<C, T>.Function, _ terminator: @escaping Parser<C, U>.Function) -> Parser<C, [T]>.Function {
	return many(parser <* terminator)
}

/// Parses `parser` the number of times specified in `interval`.
///
/// \param interval  An interval specifying the number of repetitions to perform. `0...n` means at most `n` repetitions; `m...Int.max` means at least `m` repetitions; and `m...n` means between `m` and `n` repetitions (inclusive).
public func * <C: Collection, T> (parser: @escaping Parser<C, T>.Function, interval: CountableClosedRange<Int>) -> Parser<C, [T]>.Function {
	if interval.upperBound <= 0 { return { .success(([], $1)) } }

	return (parser >>- { x in { [x] + $0 } <^> (parser * decrement(interval)) })
		<|> { interval.lowerBound <= 0 ? .success(([], $1)) : .failure(.leaf("expected at least \(interval.lowerBound) matches", $1)) }
}

/// Parses `parser` exactly `n` times.		
///
/// `n` must be > 0 to make any sense.
public func * <C: Collection, T> (parser: @escaping Parser<C, T>.Function, n: Int) -> Parser<C, [T]>.Function {
	return ntimes(parser, n)
}

/// Parses `parser` the number of times specified in `interval`.
///
/// \param interval  An interval specifying the number of repetitions to perform. `0..<n` means at most `n-1` repetitions; `m..<Int.max` means at least `m` repetitions; and `m..<n` means at least `m` and fewer than `n` repetitions; `n..<n` is an error.
public func * <C: Collection, T> (parser: @escaping Parser<C, T>.Function, interval: Range<Int>) -> Parser<C, [T]>.Function {
	if interval.isEmpty { return { .failure(.leaf("cannot parse an empty interval of repetitions", $1)) } }
	return parser * (interval.lowerBound...decrement(interval.upperBound))
}

/// Parses `parser` 0 or more times.
public func many<C: Collection, T> (_ p: @escaping Parser<C, T>.Function) -> Parser<C, [T]>.Function {
	return prepend <^> require(p) <*> delay { many(p) } <|> pure([])
}

/// Parses `parser` `n` number of times.
public func ntimes<C: Collection, T> (_ p: @escaping Parser<C, T>.Function, _ n: Int) -> Parser<C, [T]>.Function {
	guard n > 0 else { return pure([]) }
	return prepend <^> p <*> delay { ntimes(p, n - 1) }
}


// MARK: - Private

/// Decrements `x` iff it is not equal to `Int.max`.
private func decrement(_ x: Int) -> Int {
	return (x == Int.max ? Int.max : x - 1)
}

private func decrement(_ x: CountableClosedRange<Int>) -> CountableClosedRange<Int> {
	return decrement(x.lowerBound)...decrement(x.upperBound)
}

/// Fails iff `parser` does not consume input, otherwise pass through its results
private func require<C: Collection, T> (_ parser: @escaping Parser<C,T>.Function) -> Parser<C, T>.Function {
	return { (input, sourcePos) in
		return parser(input, sourcePos).flatMap { resultInput, resultPos in
			if sourcePos.index == resultPos.index {
				return Result.failure(Error.leaf("parser did not consume input when required", sourcePos))
			}
			return Result.success((resultInput, resultPos))
		}
	}
}


// MARK: - Imports

import Result
