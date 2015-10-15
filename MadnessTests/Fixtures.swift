//  Copyright (c) 2015 Rob Rix. All rights reserved.

let lambda: Parser<String.CharacterView, Lambda>.Function = fix { term in
	let symbol: Parser<String.CharacterView, String>.Function = %("a"..."z")

	let variable: Parser<String.CharacterView, Lambda>.Function = { Lambda.Variable($0) } <^> symbol
	let abstraction: Parser<String.CharacterView, Lambda>.Function = { Lambda.Abstraction($0, Box($1)) } <^> ignore("λ") ++ symbol ++ ignore(".") ++ term
	let parenthesized: Parser<String.CharacterView, (Lambda, Lambda)>.Function = ignore("(") ++ term ++ ignore(" ") ++ term ++ ignore(")")
	let application: Parser<String.CharacterView, Lambda>.Function = { (function: Lambda, argument: Lambda) -> Lambda in
		Lambda.Application(Box(function), Box(argument))
	} <^> parenthesized
	return variable | abstraction | application
}

enum Lambda: CustomStringConvertible {
	case Variable(String)
	case Abstraction(String, Box<Lambda>)
	case Application(Box<Lambda>, Box<Lambda>)

	var description: String {
		switch self {
		case let Variable(symbol):
			return symbol
		case let Abstraction(symbol, body):
			return "λ\(symbol).\(body.value.description)"
		case let Application(x, y):
			return "(\(x.value.description) \(y.value.description))"
		}
	}
}


import Box
import Madness
import Prelude
