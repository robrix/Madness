//  Copyright (c) 2015 Rob Rix. All rights reserved.

// Extend String to be a CollectionType of CharacterView
extension String : CollectionType {
	// Swift crashes if we don't override count
	public var count: String.Index.Distance {
		return characters.count
	}
}

let lambda: Parser<String.CharacterView, Lambda>.Function = fix { term in
	let symbol: Parser<String.CharacterView, String>.Function = %("a"..."z")

	let variable: Parser<String.CharacterView, Lambda>.Function = { Lambda.Variable($0) } <^> symbol
	let abstraction: Parser<String.CharacterView, Lambda>.Function = { Lambda.Abstraction($0, $1) } <^> ignore("λ") ++ symbol ++ ignore(".") ++ term
	let parenthesized: Parser<String.CharacterView, (Lambda, Lambda)>.Function = ignore("(") ++ term ++ ignore(" ") ++ term ++ ignore(")")
	let application: Parser<String.CharacterView, Lambda>.Function = { (function: Lambda, argument: Lambda) -> Lambda in
		Lambda.Application(function, argument)
	} <^> parenthesized
	return variable | abstraction | application
}

enum Lambda: CustomStringConvertible {
	case Variable(String)
	indirect case Abstraction(String, Lambda)
	indirect case Application(Lambda, Lambda)

	var description: String {
		switch self {
		case let Variable(symbol):
			return symbol
		case let Abstraction(symbol, body):
			return "λ\(symbol).\(body.description)"
		case let Application(x, y):
			return "(\(x.description) \(y.description))"
		}
	}
}


import Madness
import Prelude
