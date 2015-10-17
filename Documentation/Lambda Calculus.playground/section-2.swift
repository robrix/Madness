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


let lambda: Parser<String.CharacterView, Lambda>.Function = fix { lambda in
	let symbol: Parser<String.CharacterView, String>.Function = %("a"..."z")

	let variable: Parser<String.CharacterView, Lambda>.Function = symbol |> map { Lambda.Variable($0) }
	let abstraction: Parser<String.CharacterView, Lambda>.Function = lift(pair) <*> (%"λ" *> symbol) <*> (%"." *> lambda) |> map { Lambda.Abstraction($0, $1) }
    let application: Parser<String.CharacterView, Lambda>.Function = lift(pair) <*> (%"(" *> lambda) <*> (%" " *> lambda) <* %")" |> map { (function: Lambda, argument: Lambda) -> Lambda in
		Lambda.Application(function, argument)
	}
	return variable <|> abstraction <|> application
}

parse(lambda, input: "λx.(x x)").right?.description
parse(lambda, input: "(λx.(x x) λx.(x x))").right?.description

