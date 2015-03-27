//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses `parser` 0 or one time.
public postfix func |? <C: CollectionType, T> (parser: Parser<C, T>.Function) -> Parser<C, T?>.Function {
	return (parser --> unit) | { .right(nil, $1) }
}


/// Parses either `left` or `right`.
public func | <C: CollectionType, T, U> (left: Parser<C, T>.Function, right: Parser<C, U>.Function) -> Parser<C, Either<T, U>>.Function {
	return alternate(left, right)
}

/// Parses either `left` or `right` and coalesces their trees.
public func | <C: CollectionType, T> (left: Parser<C, T>.Function, right: Parser<C, T>.Function) -> Parser<C, T>.Function {
	return alternate(left, right) --> { $0.either(ifLeft: id, ifRight: id) }
}

/// Parses either `left` or `right`, dropping `right`’s parse tree.
public func | <C: CollectionType, T> (left: Parser<C, T>.Function, right: Parser<C, Ignore>.Function) -> Parser<C, T?>.Function {
	return alternate(left, right) --> { $0.either(ifLeft: unit, ifRight: const(nil)) }
}

/// Parses either `left` or `right`, dropping `left`’s parse tree.
public func | <C: CollectionType, T> (left: Parser<C, Ignore>.Function, right: Parser<C, T>.Function) -> Parser<C, T?>.Function {
	return alternate(left, right) --> { $0.either(ifLeft: const(nil), ifRight: unit) }
}

/// Parses either `left` or `right`, dropping both parse trees.
public func | <C: CollectionType> (left: Parser<C, Ignore>.Function, right: Parser<C, Ignore>.Function) -> Parser<C, Ignore>.Function {
	return alternate(left, right) --> { $0.either(ifLeft: id, ifRight: id) }
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


// MARK: - Operators

/// Optional alternation operator.
postfix operator |? {}


// MARK: - Imports

import Either
import Prelude
