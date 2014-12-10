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

