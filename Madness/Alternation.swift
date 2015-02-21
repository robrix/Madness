//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses either `left` or `right`.
public func | <S: Sliceable, T, U> (left: Parser<S, T>.Function, right: Parser<S, U>.Function) -> Parser<S, Either<T, U>>.Function {
	return alternate(left, right)
}

/// Parses either `left` or `right` and coalesces their trees.
public func | <S: Sliceable, T> (left: Parser<S, T>.Function, right: Parser<S, T>.Function) -> Parser<S, T>.Function {
	return alternate(left, right) --> { $0.either(id, id) }
}

/// Parses either `left` or `right`, dropping `right`’s parse tree.
public func | <S: Sliceable, T> (left: Parser<S, T>.Function, right: Parser<S, ()>.Function) -> Parser<S, T?>.Function {
	return alternate(left, right) --> { $0.either(id, const(nil)) }
}

/// Parses either `left` or `right`, dropping `left`’s parse tree.
public func | <S: Sliceable, T> (left: Parser<S, ()>.Function, right: Parser<S, T>.Function) -> Parser<S, T?>.Function {
	return alternate(left, right) --> { $0.either(const(nil), id) }
}

/// Parses either `left` or `right`, dropping both parse trees.
public func | <S: Sliceable> (left: Parser<S, ()>.Function, right: Parser<S, ()>.Function) -> Parser<S, ()>.Function {
	return alternate(left, right) --> { $0.either(id, id) }
}


// MARK: - Private

/// Defines alternation for use in the `|` operator definitions above.
private func alternate<S: Sliceable, T, U>(left: Parser<S, T>.Function, right: Parser<S, U>.Function)(input: S) -> Parser<S, Either<T, U>>.Result {
	return left(input).map { (.left($0), $1) } ?? right(input).map { (.right($0), $1) }
}


// MARK: - Imports

import Either
import Prelude
