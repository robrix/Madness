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

/// Returns the least fixed point of the function returned by `f`.
///
/// This is useful for e.g. making recursive closures without using the two-step assignment dance.
///
/// \param f  - A function which takes a parameter function, and returns a result function. The result function may recur by calling the parameter function.
///
/// \return  A recursive function.
func fix<T, U>(f: ((T) -> U) -> (T) -> U) -> (T) -> U {
	return { f(fix(f))($0) }
}

typealias LambdaParser = Parser<String, Lambda>.Function

let lambda: LambdaParser = fix { term in
	let symbol: Parser<String, String>.Function = String.lift(%("a"..."z"))

	let variable: LambdaParser = Lambda.Variable <^> symbol
	let abstraction: LambdaParser = { x in { y in Lambda.Abstraction(x, y) } } <^> (%"λ" *> symbol) <*> (%"." *> term)
	let application: LambdaParser = { x in { y in Lambda.Application(x, y) } } <^> (%"(" *> term) <*> (%" " *> term) <* %")"
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
