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


let symbol = %("a"..."z")

let term: Parser<Term>.Function = fix { term in
	let variable = symbol --> { Term.Variable($0) }
	let abstraction = ignore(%"λ") ++ symbol ++ ignore(%".") ++ term --> { Term.Abstraction($0, Box($1)) }
	let application = ignore(%"(") ++ term ++ ignore(%" ") ++ term ++ ignore(%")") --> { Term.Application(Box($0), Box($1)) }
	return variable | abstraction | application
}

let parse: String -> Term? = {
	term($0)?.0
}

parse("λx.(x x)")?.description
parse("(λx.(x x) λx.(x x))")?.description
