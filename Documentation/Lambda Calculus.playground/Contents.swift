import Madness

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

typealias LambdaParser = Parser<String.CharacterView, Lambda>

func lambda(_ input: String.CharacterView, sourcePos: SourcePos<String.CharacterView.Index>) -> LambdaParser.Result {
	let symbol: StringParser = %("a"..."z")

	let variable: LambdaParser.Function = Lambda.variable <^> symbol
	let abstraction: LambdaParser.Function = Lambda.abstraction <^> ( lift(pair) <*> (%"λ" *> symbol) <*> (%"." *> lambda) )
	let application: LambdaParser.Function = Lambda.application <^> ( lift(pair) <*> (%"(" *> lambda) <*> (%" " *> lambda) <* %")" )
	
	let parser: LambdaParser.Function = variable <|> abstraction <|> application
	return parser(input, sourcePos)
}

parse(lambda, input: "λx.(x x)".characters).value?.description
parse(lambda, input: "(λx.(x x) λx.(x x))".characters).value?.description

