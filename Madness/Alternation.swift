//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses `parser` 0 or one time.
public postfix func |? <C: CollectionType, T> (parser: Parser<C, T>.Function) -> Parser<C, T?>.Function {
    return first <^> parser * (0...1)
}

/// Parses `parser` 0 or one time dropping the parse tree.
public postfix func |? <C: CollectionType, T> (parser: Parser<C, Ignore>.Function) -> Parser<C, Ignore>.Function {
    return ignore(parser * (0...1))
}


/// Parses either `left` or `right`.
public func <||> <C: CollectionType, T, U> (left: Parser<C, T>.Function, right: Parser<C, U>.Function) -> Parser<C, Either<T, U>>.Function {
	return alternate(left, right)
}

/// Parses either `left` or `right` and coalesces their trees.
public func <||> <C: CollectionType, T> (left: Parser<C, T>.Function, right: Parser<C, T>.Function) -> Parser<C, T>.Function {
	return alternate(left, right) |> map { $0.either(ifLeft: id, ifRight: id) }
}

/// Parses either `left` or `right`, dropping `right`’s parse tree.
public func <|| <C: CollectionType, T, U> (left: Parser<C, T>.Function, right: Parser<C, U>.Function) -> Parser<C, T?>.Function {
	return alternate(left, right) |> map { $0.either(ifLeft: unit, ifRight: const(nil)) }
}

/// Parses either `left` or `right`, dropping `left`’s parse tree.
public func ||> <C: CollectionType, T, U> (left: Parser<C, T>.Function, right: Parser<C, U>.Function) -> Parser<C, U?>.Function {
	return alternate(left, right) |> map { $0.either(ifLeft: const(nil), ifRight: unit) }
}


// MARK: - n-ary alternation

/// Alternates over a sequence of literals, coalescing their parse trees.
public func oneOf<C: CollectionType, S: SequenceType where C.Generator.Element: Equatable, S.Generator.Element == C>(input: S) -> Parser<C, C>.Function {
	return reduce(input, none()) { $0 <||> %$1 }
}

/// Given a set of literals, parses an array of any matches in the order they were found.
///
/// Each literal will only match the first time.
public func anyOf<C: CollectionType where C.Generator.Element: Equatable>(set: Set<C>) -> Parser<C, [C]>.Function {
	return oneOf(set) >>- { match in
		var rest = set
		rest.remove(match)
		return prepend(match) <^> anyOf(rest) <||> pure([match])
	}
}

/// Given a set of literals, parses an array of all matches in the order they were found.
///
/// Each literal will be matched as many times as it is found.
public func allOf<C: CollectionType where C.Generator.Element: Equatable>(input: Set<C>) -> Parser<C, [C]>.Function {
	return oneOf(input) >>- { match in
		prepend(match) <^> allOf(input) <||> pure([match])
	}
}


// MARK: - Private

/// Defines alternation for use in the `|` operator definitions above.
private func alternate<C: CollectionType, T, U>(left: Parser<C, T>.Function, right: Parser<C, U>.Function)(input: C, index: C.Index) -> Parser<C, Either<T, U>>.Result {
	let a = left(input, index).map { (Either<T, U>.left($0), $1) }
	let b = right(input, index).map { (Either<T, U>.right($0), $1) }
	return (a ||| b).either(ifLeft: Error.withReason("no alternative matched:", index) >>> Either.left, ifRight: Either.right)
}

/// Disjunction of two `Either`s.
private func ||| <A, B> (a: Either<A, B>, b: Either<A, B>) -> Either<(A, A), B> {
	return (a.right ?? b.right).map(Either<(A, A), B>.right) ?? (a.left &&& b.left).map(Either<(A, A), B>.left)!
}

/// Curried function that prepends a value to an array.
private func prepend<T>(value: T) -> [T] -> [T] {
	return { [value] + $0 }
}


// MARK: - Operators

/// Optional alternation operator.
postfix operator |? {}


infix operator <||> {
	associativity left
	precedence 95
}

infix operator ||> {
	associativity left
	precedence 95
}

infix operator <|| {
	associativity left
	precedence 95
}


// MARK: - Imports

import Either
import Prelude
