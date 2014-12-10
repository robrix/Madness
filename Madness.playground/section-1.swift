import Box
import Madness
import Prelude

enum Term: Printable {
	case Variable(String)
	case Abstraction(String, Box<Term>)
	case Application(Box<Term>, Box<Term>)

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


let symbol = range("a"..."z")

let term: Parser<Term>.Function = fix { term in
	let variable = symbol --> { Term.Variable($0) }
	let abstraction = literal("λ") ++ symbol ++ literal(".") ++ term --> { Term.Abstraction($0.1.0, Box($0.1.1.1.0)) }
	let application = literal("(") ++ term ++ literal(" ") ++ term ++ literal(")") --> { Term.Application(Box($0.1.0), Box($0.1.1.1.0)) }
	return (variable | abstraction | application)
}

let parse: String -> Term? = {
	term($0)?.0
}

parse("λx.(x x)")?.description
