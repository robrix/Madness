//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// The type of trees to drop from the input.
public typealias Ignore = ()


/// Ignores any parse trees produced by `parser`.
public func ignore<C: CollectionType, T>(parser: Parser<C, T>.Function) -> Parser<C, ()>.Function {
	return parser --> const(())
}

/// Ignores any parse trees produced by a parser which parses `string`.
public func ignore(string: String) -> Parser<String, ()>.Function {
	return ignore(%string)
}


// MARK: - Imports

import Prelude
