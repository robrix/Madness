//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Result

precedencegroup ConcatenationPrecedence {
	associativity: left
	higherThan: AlternationPrecedence
	lowerThan: MultiplicationPrecedence
}

/// Parses the concatenation of `left` and `right`, pairing their parse trees.
public func <*> <C: Collection, T, U> (left: @escaping Parser<C, (T) -> U>.Function, right: @escaping Parser<C, T>.Function) -> Parser<C, U>.Function {
	return left >>- { $0 <^> right }
}

/// Parses the concatenation of `left` and `right`, dropping `right`’s parse tree.
public func <* <C: Collection, T, U> (left: @escaping Parser<C, T>.Function, right: @escaping Parser<C, U>.Function) -> Parser<C, T>.Function {
	return left >>- { x in { _ in x } <^> right }
}

/// Parses the concatenation of `left` and `right`, dropping `left`’s parse tree.
public func *> <C: Collection, T, U> (left: @escaping Parser<C, T>.Function, right: @escaping Parser<C, U>.Function) -> Parser<C, U>.Function {
	return left >>- { _ in right }
}


infix operator <*> : ConcatenationPrecedence

infix operator *> : ConcatenationPrecedence

infix operator <* : ConcatenationPrecedence
