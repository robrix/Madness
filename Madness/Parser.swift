//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Parser<Term> {
	public typealias Function = String -> (Term, String)?
}


// MARK: - Terminals

/// Returns a parser which parses `string`.
public func literal(string: String) -> Parser<String>.Function {
	return {
		startsWith($0, string) ?
			(string, $0.fromOffset(countElements(string)))
		:	nil
	}
}


// MARK: - Nonterminals

/// Returns a parser which maps parse trees into another type.
public func map<T, U>(parser: Parser<T>.Function, f: T -> U) -> Parser<U>.Function {
	return {
		parser($0).map { (f($0), $1) }
	}
}
