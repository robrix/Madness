//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Convenience for describing the types of parser combinators.
///
/// \param Tree  The type of parse tree generated by the parser.
public enum Parser<C: CollectionType, Tree> {
	/// The type of parser combinators.
	public typealias Function = (C, C.Index) -> Result

	/// The type produced by parser combinators.
	public typealias Result = Either<Error<C.Index>, (Tree, C.Index)>
}

/// Parses `input` with `parser`, returning the parse trees or `nil` if nothing could be parsed, or if parsing did not consume the entire input.
public func parse<C: CollectionType, Tree>(parser: Parser<C, Tree>.Function, input: C) -> Either<Error<C.Index>, Tree> {
	return parser(input, input.startIndex).flatMap { $1 == input.endIndex ? .right($0) : .left(.leaf("finished parsing before end of input", $1)) }
}

public func parse<Tree>(parser: Parser<String.CharacterView, Tree>.Function, input: String) -> Either<Error<String.Index>, Tree> {
	return parser(input.characters, input.startIndex).flatMap { $1 == input.endIndex ? .right($0) : .left(.leaf("finished parsing before end of input", $1)) }
}

// MARK: - Terminals

/// Returns a parser which never parses its input.
public func none<C: CollectionType, Tree>(string: String = "no way forward") -> Parser<C, Tree>.Function {
	return { _, index in Either.left(Error.leaf(string, index)) }
}

/// Returns a parser which parses any single character.
public func any<C: CollectionType>(input: C, index: C.Index) -> Parser<C, C.Generator.Element>.Result {
	if index != input.endIndex {
		let parsed = input[index]
		let next = index.successor()
		
		return .Right((parsed, next))
	} else {
		return .Left(Error.leaf("", index))
	}
}


/// Returns a parser which parses a `literal` sequence of elements from the input.
///
/// This overload enables e.g. `%"xyz"` to produce `String -> (String, String)`.
public prefix func % <C: CollectionType where C.Generator.Element: Equatable> (literal: C) -> Parser<C, C>.Function {
	return { input, index in
		containsAt(input, index: index, needle: literal) ?
			.Right(literal, index.advancedBy(literal.count))
		:	.Left(.leaf("expected \(literal)", index))
	}
}

public prefix func %(literal: String) -> Parser<String.CharacterView, String>.Function {
	return String.init <^> %literal.characters
}

/// Returns a parser which parses a `literal` element from the input.
public prefix func % <C: CollectionType where C.Generator.Element: Equatable> (literal: C.Generator.Element) -> Parser<C, C.Generator.Element>.Function {
	return { input, index in
		index != input.endIndex && input[index] == literal ?
			.Right(literal, index.successor())
		:	.Left(.leaf("expected \(literal)", index))
	}
}


/// Returns a parser which parses any character in `interval`.
public prefix func %<I: IntervalType where I.Bound == Character>(interval: I) -> Parser<String.CharacterView, String>.Function {
	return { (input: String.CharacterView, index: String.Index) -> Parser<String.CharacterView, String>.Result in
		(index < input.endIndex && interval.contains(input[index])) ?
			.Right(String(input[index]), index.successor())
		:	.Left(.leaf("expected an element in interval \(interval)", index))
	}
}


// MARK: - Nonterminals

private func memoize<T>(f: () -> T) -> () -> T {
	var memoized: T!
	return {
		if memoized == nil {
			memoized = f()
		}
		return memoized
	}
}

public func delay<C: CollectionType, T>(parser: () -> Parser<C, T>.Function) -> Parser<C, T>.Function {
	let memoized = memoize(parser)
	return { memoized()($0, $1) }
}


// MARK: - Private

/// Returns `true` iff `collection` contains all of the elements in `needle` in-order and contiguously, starting from `index`.
func containsAt<C1: CollectionType, C2: CollectionType where C1.Generator.Element == C2.Generator.Element, C1.Generator.Element: Equatable>(collection: C1, index: C1.Index, needle: C2) -> Bool {
	let needleCount = needle.count.toIntMax()
	let range = index..<index.advancedBy(C1.Index.Distance(needleCount), limit: collection.endIndex)
	if range.count.toIntMax() < needleCount { return false }

	return zip(range, needle).lazy.map { collection[$0] == $1 }.reduce(true) { $0 && $1 }
}

// Returns a parser that satisfies the given predicate
public func satisfy<C: CollectionType> (pred: C.Generator.Element -> Bool) -> Parser<C, C.Generator.Element>.Function {
	return { input, index in
		if index != input.endIndex {
			let parsed = input[index]
			let next = index.successor()
			
			if pred(parsed) {
				return .Right((parsed, next))
			} else {
				return .Left(Error.leaf("Failed to parse \(String(parsed)) with predicate at index", index))
			}
		} else {
			return .Left(Error.leaf("Failed to parse at end of input", index))
		}
	}
}


// MARK: - Operators

/// Map operator.
infix operator --> {
	/// Associates to the left.
	associativity left

	/// Lower precedence than |.
	precedence 100
}


/// Literal operator.
prefix operator % {}


// MARK: - Imports

import Either
import Prelude
