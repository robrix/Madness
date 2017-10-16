//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses `parser` 0 or one time.
public postfix func |? <C: Collection, T> (parser: @escaping Parser<C, T>.Function) -> Parser<C, T?>.Function {
    return { $0.first } <^> parser * (0...1)
}

/// Parses either `left` or `right` and coalesces their trees.
public func <|> <C: Collection, T> (left: @escaping Parser<C, T>.Function, right: @escaping Parser<C, T>.Function) -> Parser<C, T>.Function {
	return alternate(left, right)
}


// MARK: - n-ary alternation

/// Alternates over a sequence of literals, coalescing their parse trees.
public func oneOf<C: Collection, S: Sequence>(_ input: S) -> Parser<C, C.Iterator.Element>.Function where C.Iterator.Element: Equatable, S.Iterator.Element == C.Iterator.Element {
	return satisfy { c in input.contains(c) }
}

/// Given a set of literals, parses an array of any matches in the order they were found.
///
/// Each literal will only match the first time.
public func anyOf<C: Collection>(_ set: Set<C.Iterator.Element>) -> Parser<C, [C.Iterator.Element]>.Function where C.Iterator.Element: Equatable {
	return oneOf(set) >>- { match in
		var rest = set
		rest.remove(match)
		return prepend(match) <^> anyOf(rest) <|> pure([match])
	}
}

/// Given a set of literals, parses an array of all matches in the order they were found.
///
/// Each literal will be matched as many times as it is found.
public func allOf<C: Collection>(_ input: Set<C.Iterator.Element>) -> Parser<C, [C.Iterator.Element]>.Function where C.Iterator.Element: Equatable {
	return oneOf(input) >>- { match in
		prepend(match) <^> allOf(input) <|> pure([match])
	}
}


// MARK: - Private

/// Defines alternation for use in the `<|>` operator definitions above.
private func alternate<C: Collection, T>(_ left: @escaping Parser<C, T>.Function, _ right: @escaping Parser<C, T>.Function) -> Parser<C, T>.Function {
	return { input, sourcePos in
		switch left(input, sourcePos) {
		case let .success(tree, sourcePos):
			return .success(tree, sourcePos)
		case let .failure(left):
			switch right(input, sourcePos) {
			case let .success(tree, sourcePos):
				return .success(tree, sourcePos)
			case let .failure(right):
				return .failure(Error.withReason("no alternative matched:", sourcePos)(left, right))
			}
		}
	}
}


/// Curried function that prepends a value to an array.
func prepend<T>(_ value: T) -> ([T]) -> [T] {
	return { [value] + $0 }
}


// MARK: - Operators

/// Optional alternation operator.
postfix operator |?

precedencegroup AlternationPrecedence {
	associativity: left
	higherThan: ChainingPrecedence
	lowerThan: MultiplicationPrecedence
}

infix operator <|> : AlternationPrecedence


// MARK: - Imports

import Result
