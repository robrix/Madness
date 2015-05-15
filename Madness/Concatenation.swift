//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses the concatenation of `left` and `right`, pairing their parse trees.
public func ++ <C: CollectionType, T, U> (left: Parser<C, T>.Function, right: Parser<C, U>.Function) -> Parser<C, (T, U)>.Function {
	return left >>- { x in { y in (x, y) } <^> right }
}

/// Parses the concatenation of `left` and `right`, dropping `right`’s parse tree.
public func ++ <C: CollectionType, T> (left: Parser<C, T>.Function, right: Parser<C, Ignore>.Function) -> Parser<C, T>.Function {
	return left >>- { x in  const(x) <^> right }
}

/// Parses the concatenation of `left` and `right`, dropping `left`’s parse tree.
public func ++ <C: CollectionType, T> (left: Parser<C, Ignore>.Function, right: Parser<C, T>.Function) -> Parser<C, T>.Function {
	return left >>- const(right)
}

/// Parses the concatenation of `left` and `right, dropping both parse trees.
public func ++ <C: CollectionType> (left: Parser<C, Ignore>.Function, right: Parser<C, Ignore>.Function) -> Parser<C, Ignore>.Function {
	return ignore(left >>- const(right))
}


// MARK: - Operators

/// Concatenation operator.
infix operator ++ {
	/// Associates to the right, linked-list style.
	associativity right

	/// Higher precedence than |.
	precedence 160
}


import Prelude
