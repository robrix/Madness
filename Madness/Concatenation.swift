//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses the concatenation of `left` and `right`, pairing their parse trees.
public func ++ <T, U> (left: Parser<T>.Function, right: Parser<U>.Function) -> Parser<(T, U)>.Function {
	return concatenate(left, right)
}

/// Parses the concatenation of `left` and `right`, dropping `right`’s parse tree.
public func ++ <T> (left: Parser<T>.Function, right: Parser<()>.Function) -> Parser<T>.Function {
	return concatenate(left, right) --> { x, _ in x }
}

/// Parses the concatenation of `left` and `right`, dropping `left`’s parse tree.
public func ++ <T> (left: Parser<()>.Function, right: Parser<T>.Function) -> Parser<T>.Function {
	return concatenate(left, right) --> { $1 }
}

/// Parses the concatenation of `left` and `right, dropping both parse trees.
public func ++ (left: Parser<()>.Function, right: Parser<()>.Function) -> Parser<()>.Function {
	return ignore(concatenate(left, right))
}


// MARK: - Operators

/// Concatenation operator.
infix operator ++ {
	/// Associates to the right, linked-list style.
	associativity right

	/// Higher precedence than |.
	precedence 160
}


// MARK: - Private

/// Defines concatenation for use in the `++` operator definitions above.
private func concatenate<T, U>(left: Parser<T>.Function, right: Parser<U>.Function)(input: String) -> ((T, U), String)? {
	return left(input).map { x, rest in
		right(rest).map { y, rest in
			((x, y), rest)
		}
	} ?? nil
}
