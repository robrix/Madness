indirect enum Lambda: CustomStringConvertible {
	case Variable(String)
	case Abstraction(String, Lambda)
	case Application(Lambda, Lambda)
    
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

typealias LambdaParser = Parser<String.CharacterView, Lambda>.Function

let lambda: LambdaParser = fix { lambda in
	let symbol: StringParser = %("a"..."z")

	let variable: LambdaParser = Lambda.Variable <^> symbol
	let abstraction: LambdaParser = Lambda.Abstraction <^> ( lift(pair) <*> (%"λ" *> symbol) <*> (%"." *> lambda) )
	let application: LambdaParser = Lambda.Application <^> ( lift(pair) <*> (%"(" *> lambda) <*> (%" " *> lambda) <* %")" )
    
	return variable <|> abstraction <|> application
}

parse(lambda, input: "λx.(x x)").right?.description
parse(lambda, input: "(λx.(x x) λx.(x x))").right?.description

