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

let term: Parser<String, Term>.Function = fix { (term: Parser<String, Term>.Function) -> Parser<String, Term>.Function in
	let variable: Parser<String, Term>.Function = symbol |> map { Term.Variable($0) }
	let abstraction: Parser<String, Term>.Function = ignore("λ") ++ symbol ++ ignore(".") ++ term |> map { Term.Abstraction($0, Box($1)) }
	let parenthesized: Parser<String, (Term, Term)>.Function = ignore("(") ++ term ++ ignore(" ") ++ term ++ ignore(")")
	let application: Parser<String, Term>.Function = parenthesized |> map { (function: Term, argument: Term) -> Term in
		Term.Application(Box(function), Box(argument))
	}
	return variable | abstraction | application
}

parse(term, "λx.(x x)")?.description
parse(term, "(λx.(x x) λx.(x x))")?.description
