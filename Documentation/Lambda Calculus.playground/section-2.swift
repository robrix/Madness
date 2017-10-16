indirect enum Lambda: CustomStringConvertible {
	case variable(String)
	case abstraction(String, Lambda)
	case application(Lambda, Lambda)
    
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

typealias LambdaParser = Parser<String.CharacterView, Lambda>.Function

func fix<T, U>(_ f: @escaping (@escaping (T) -> U) -> (T) -> U) -> (T) -> U {
    return { f(fix(f))($0) }
}

let lambda: LambdaParser = fix { lambda in
	let symbol: StringParser = %("a"..."z")

	let variable: LambdaParser = Lambda.variable <^> symbol
	let abstraction: LambdaParser = Lambda.abstraction <^> ( lift(pair) <*> (%"λ" *> symbol) <*> (%"." *> lambda) )
	let application: LambdaParser = Lambda.application <^> ( lift(pair) <*> (%"(" *> lambda) <*> (%" " *> lambda) <* %")" )
    
	return variable <|> abstraction <|> application
}

parse(lambda, input: "λx.(x x)").value?.description
parse(lambda, input: "(λx.(x x) λx.(x x))").value?.description

