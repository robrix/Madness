//  Copyright (c) 2015 Rob Rix. All rights reserved.

let lambda: Parser<String, Lambda>.Function = fix { term in
	let symbol: Parser<String, String>.Function = %("a"..."z")

	let variable: Parser<String, Lambda>.Function = symbol |> map { Lambda.Variable($0) }
	let abstraction: Parser<String, Lambda>.Function = %"λ" *> symbol <*> (%"." *> term) |> map { Lambda.Abstraction($0, Box($1)) }
	let application: Parser<String, Lambda>.Function = %"(" *> term <*> (%" " *> term) <* %")" |> map { (function: Lambda, argument: Lambda) -> Lambda in
		Lambda.Application(Box(function), Box(argument))
	}
	return variable <||> abstraction <||> application
}

enum Lambda: Printable {
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
