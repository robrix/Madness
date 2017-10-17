//  Copyright (c) 2015 Rob Rix. All rights reserved.

extension String {
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

func lambda(_ input: String, sourcePos: SourcePos<String.Index>) -> Parser<String, Lambda>.Result {
	let symbol: Parser<String, String>.Function = String.lift(%("a"..."z"))

	let variable: LambdaParser = Lambda.variable <^> symbol
	let abstraction: LambdaParser = { x in { y in Lambda.abstraction(x, y) } } <^> (%"λ" *> symbol) <*> (%"." *> lambda)
	let application: LambdaParser = { x in { y in Lambda.application(x, y) } } <^> (%"(" *> lambda) <*> (%" " *> lambda) <* %")"
	let parser: LambdaParser = variable <|> abstraction <|> application
	return parser(input, sourcePos)
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
