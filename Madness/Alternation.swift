//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Parses `parser` 0 or one time.
public postfix func |? <C: CollectionType, T> (parser: Parser<C, T>.Function) -> Parser<C, T?>.Function {
    return { $0.first } <^> parser * (0...1)
}

/// Parses either `left` or `right` and coalesces their trees.
public func <|> <C: CollectionType, T> (left: Parser<C, T>.Function, right: Parser<C, T>.Function) -> Parser<C, T>.Function {
	return alternate(left, right)
}


// MARK: - n-ary alternation

/// Alternates over a sequence of literals, coalescing their parse trees.
public func oneOf<C: CollectionType, S: SequenceType where C.Generator.Element: Equatable, S.Generator.Element == C.Generator.Element>(input: S) -> Parser<C, C.Generator.Element>.Function {
	return satisfy { c in input.contains(c) }
}

/// Given a set of literals, parses an array of any matches in the order they were found.
///
/// Each literal will only match the first time.
public func anyOf<C: CollectionType where C.Generator.Element: Equatable>(set: Set<C.Generator.Element>) -> Parser<C, [C.Generator.Element]>.Function {
	return oneOf(set) >>- { match in
		var rest = set
		rest.remove(match)
		return prepend(match) <^> anyOf(rest) <|> pure([match])
	}
}

/// Given a set of literals, parses an array of all matches in the order they were found.
///
/// Each literal will be matched as many times as it is found.
public func allOf<C: CollectionType where C.Generator.Element: Equatable>(input: Set<C.Generator.Element>) -> Parser<C, [C.Generator.Element]>.Function {
	return oneOf(input) >>- { match in
		prepend(match) <^> allOf(input) <|> pure([match])
	}
}


// MARK: - Private

/// Defines alternation for use in the `<|>` operator definitions above.
private func alternate<C: CollectionType, T>(left: Parser<C, T>.Function, _ right: Parser<C, T>.Function) -> Parser<C, T>.Function {
	return { input, sourcePos in
		switch left(input, sourcePos) {
		case let .Success(tree, sourcePos):
			return .Success(tree, sourcePos)
		case let .Failure(left):
			switch right(input, sourcePos) {
			case let .Success(tree, sourcePos):
				return .Success(tree, sourcePos)
			case let .Failure(right):
				return .Failure(Error.withReason("no alternative matched:", sourcePos)(left, right))
			}
		}
	}
}


/// Curried function that prepends a value to an array.
func prepend<T>(value: T) -> [T] -> [T] {
	return { [value] + $0 }
}


// MARK: - Operators

/// Optional alternation operator.
postfix operator |? {}


infix operator <|> {
	associativity left
	precedence 120
}


// MARK: - Imports

import Result
