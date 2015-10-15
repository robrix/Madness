//  Copyright (c) 2015 Rob Rix. All rights reserved.

// Extend String to be a CollectionType of CharacterView
extension String : CollectionType {
	// Swift crashes if we don't override count
	public var count: String.Index.Distance {
		return characters.count
	}

	public static func lift<A>(parser: Parser<String.CharacterView, A>.Function) -> Parser<String, A>.Function {
		return {
			parser($0.characters, $1)
		}
	}
}

let lambda: Parser<String, Lambda>.Function = fix { term in
	let symbol: Parser<String, String>.Function = String.lift(%("a"..."z"))

	let variable: Parser<String, Lambda>.Function = symbol |> map { Lambda.Variable($0) }
	let abstraction: Parser<String, Lambda>.Function = %"λ" *> symbol <*> (%"." *> term) |> map { Lambda.Abstraction($0, $1) }
	let application: Parser<String, Lambda>.Function = %"(" *> term <*> (%" " *> term) <* %")" |> map { (function: Lambda, argument: Lambda) -> Lambda in
		Lambda.Application(function, argument)
	}
	return variable <|> abstraction <|> application
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
