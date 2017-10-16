//  Copyright (c) 2015 Rob Rix. All rights reserved.

// Extend String to be a CollectionType of CharacterView
extension String : Collection {
	// Swift crashes if we don't override count
	public var count: String.IndexDistance {
		return characters.count
	}

	public static func lift<A>(_ parser: @escaping Parser<String.CharacterView, A>.Function) -> Parser<String, A>.Function {
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
func fix<T, U>(_ f: @escaping (@escaping (T) -> U) -> (T) -> U) -> (T) -> U {
	return { f(fix(f))($0) }
}

typealias LambdaParser = Parser<String, Lambda>.Function

let lambda: LambdaParser = fix { term in
	let symbol: Parser<String, String>.Function = String.lift(%("a"..."z"))

	let variable: LambdaParser = Lambda.variable <^> symbol
	let abstraction: LambdaParser = { x in { y in Lambda.abstraction(x, y) } } <^> (%"λ" *> symbol) <*> (%"." *> term)
	let application: LambdaParser = { x in { y in Lambda.application(x, y) } } <^> (%"(" *> term) <*> (%" " *> term) <* %")"
	return variable <|> abstraction <|> application
}

enum Lambda: CustomStringConvertible {
	case variable(String)
	indirect case abstraction(String, Lambda)
	indirect case application(Lambda, Lambda)

	var description: String {
		switch self {
		case let .variable(symbol):
			return symbol
		case let .abstraction(symbol, body):
			return "λ\(symbol).\(body.description)"
		case let .application(x, y):
			return "(\(x.description) \(y.description))"
		}
	}
}


import Madness
