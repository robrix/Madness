//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses either `left` or `right`.
public func | <T, U> (left: Parser<T>.Function, right: Parser<U>.Function) -> Parser<Either<T, U>>.Function {
	return alternate(left, right)
}

/// Parses either `left` or `right` and coalesces their trees.
public func | <T> (left: Parser<T>.Function, right: Parser<T>.Function) -> Parser<T>.Function {
	return alternate(left, right) --> { $0.either(id, id) }
}

/// Parses either `left` or `right`, dropping `right`’s parse tree.
public func | <T> (left: Parser<T>.Function, right: Parser<()>.Function) -> Parser<T?>.Function {
	return alternate(left, right) --> { $0.either(id, const(nil)) }
}

/// Parses either `left` or `right`, dropping `left`’s parse tree.
public func | <T> (left: Parser<()>.Function, right: Parser<T>.Function) -> Parser<T?>.Function {
	return alternate(left, right) --> { $0.either(const(nil), id) }
}

/// Parses either `left` or `right`, dropping both parse trees.
public func | (left: Parser<()>.Function, right: Parser<()>.Function) -> Parser<()>.Function {
	return alternate(left, right) --> { $0.either(id, id) }
}


// MARK: - Private

/// Defines alternation for use in the `|` operator definitions above.
private func alternate<T, U>(left: Parser<T>.Function, right: Parser<U>.Function)(input: String) -> Parser<Either<T, U>>.Result {
	return left(input).map { (.left($0), $1) } ?? right(input).map { (.right($0), $1) }
}


// MARK: - Imports

import Either
import Prelude
