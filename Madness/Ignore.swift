//  Copyright (c) 2015 Rob Rix. All rights reserved.

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
