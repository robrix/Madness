//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// This parser succeeds iff `parser` fails. This parser does not consume any input.
public func not<C: Collection, T> (_ parser: @escaping Parser<C, T>.Function) -> Parser<C, ()>.Function {
	return { input, index in
		return parser(input, index).analysis(
			ifSuccess: { (_, endIndex) in
				Result.failure(Error.leaf("failed negative lookahead ending at \(endIndex)", index))
			},
			ifFailure: { _ in Result.success(((), index)) }
		)
	}
}

// MARK: - Imports

import Result
