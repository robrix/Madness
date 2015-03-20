//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// A composite error.
public enum Error<I: ForwardIndexType>: Printable {
	/// Constructs a leaf error, e.g. for terminal parsers.
	public static func leaf(reason: String, _ index: I) -> Error {
		return Leaf(reason, Box(index))
	}

	/// Constructs a branch error, e.g. for nonterminal parsers.
	public static func branch(errors: [Error]) -> Error {
		return Branch(errors)
	}


	/// Case analysis.
	public func analysis<Result>(@noescape #ifLeaf: (String, I) -> Result, @noescape ifBranch: [Error] -> Result) -> Result {
		switch self {
		case let Leaf(reason, index):
			return ifLeaf(reason, index.value)
		case let Branch(errors):
			return ifBranch(errors)
		}
	}


	// MARK: Cases

	case Leaf(String, Box<I>)
	case Branch([Error])
}


// MARK: - Imports

import Box
