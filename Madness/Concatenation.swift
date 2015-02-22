//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses the concatenation of `left` and `right`, pairing their parse trees.
public func ++ <C: CollectionType, T, U> (left: Parser<C, T>.Function, right: Parser<C, U>.Function) -> Parser<C, (T, U)>.Function {
	return concatenate(left, right)
}

/// Parses the concatenation of `left` and `right`, dropping `right`’s parse tree.
public func ++ <C: CollectionType, T> (left: Parser<C, T>.Function, right: Parser<C, Ignore>.Function) -> Parser<C, T>.Function {
	return concatenate(left, right) --> { x, _ in x }
}

/// Parses the concatenation of `left` and `right`, dropping `left`’s parse tree.
public func ++ <C: CollectionType, T> (left: Parser<C, Ignore>.Function, right: Parser<C, T>.Function) -> Parser<C, T>.Function {
	return concatenate(left, right) --> { $1 }
}

/// Parses the concatenation of `left` and `right, dropping both parse trees.
public func ++ <C: CollectionType> (left: Parser<C, Ignore>.Function, right: Parser<C, Ignore>.Function) -> Parser<C, Ignore>.Function {
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
private func concatenate<C: CollectionType, T, U>(left: Parser<C, T>.Function, right: Parser<C, U>.Function)(input: C, index: C.Index) -> Parser<C, (T, U)>.Result {
	return left(input, index).map { x, rest in
		right(input, rest).map { y, rest in
			((x, y), rest)
		}
	} ?? nil
}
