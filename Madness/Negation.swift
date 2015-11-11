//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// This parser succeeds iff `parser` fails. This parser does not consume any input.
public func not<C: CollectionType, T> (parser: Parser<C, T>.Function) -> Parser<C, ()>.Function {
	return { input, index in
		return parser(input, index).either(
			ifLeft: { _ in Either.Right((), index) },
			ifRight: { (_, endIndex) in
				Either.Left(Error.leaf("failed negative lookahead ending at \(endIndex)", index))
		})
	}
}

// MARK: - Imports

import Either
import Prelude
