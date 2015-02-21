//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses the concatenation of `left` and `right`, pairing their parse trees.
public func ++ <S: Sliceable, T, U> (left: Parser<S, T>.Function, right: Parser<S, U>.Function) -> Parser<S, (T, U)>.Function {
	return concatenate(left, right)
}

/// Parses the concatenation of `left` and `right`, dropping `right`’s parse tree.
public func ++ <S: Sliceable, T> (left: Parser<S, T>.Function, right: Parser<S, ()>.Function) -> Parser<S, T>.Function {
	return concatenate(left, right) --> { x, _ in x }
}

/// Parses the concatenation of `left` and `right`, dropping `left`’s parse tree.
public func ++ <S: Sliceable, T> (left: Parser<S, ()>.Function, right: Parser<S, T>.Function) -> Parser<S, T>.Function {
	return concatenate(left, right) --> { $1 }
}

/// Parses the concatenation of `left` and `right, dropping both parse trees.
public func ++ <S: Sliceable> (left: Parser<S, ()>.Function, right: Parser<S, ()>.Function) -> Parser<S, ()>.Function {
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
private func concatenate<S: Sliceable, T, U>(left: Parser<S, T>.Function, right: Parser<S, U>.Function)(input: S) -> Parser<S, (T, U)>.Result {
	return left(input).map { x, rest in
		right(rest).map { y, rest in
			((x, y), rest)
		}
	} ?? nil
}
