import Box
import Cocoa
import Darwin
import Madness
import Prelude


// MARK: Lambda calculus

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
	let abstraction = ignore("λ") ++ symbol ++ ignore(".") ++ term --> { Term.Abstraction($0, Box($1)) }
	let application = ignore("(") ++ term ++ ignore(" ") ++ term ++ ignore(")") --> { Term.Application(Box($0), Box($1)) }
	return variable | abstraction | application
}

parse(term, "λx.(x x)")?.description
parse(term, "(λx.(x x) λx.(x x))")?.description


// MARK: HTML-ish colours

let toComponent: String -> CGFloat = { CGFloat(strtol($0, nil, 16)) / 255 }

let hex = %("0"..."9") | %("a"..."f") | %("A"..."F")
let hex2 = (hex ++ hex --> { $0 + $1 })
let three = hex * 3 --> { $0.map { toComponent($0 + $0) } }
let six = hex2 * 3 --> { $0.map(toComponent) }

let colour = ignore("#") ++ (six | three) --> {
	NSColor(calibratedRed: $0[0], green: $0[1], blue: $0[2], alpha: 1)
}

if let reddish = parse(colour, "#d52a41") {
	reddish
}

if let greenish = parse(colour, "#5a2") {
	greenish
}

if let blueish = parse(colour, "#5e8ca1") {
	blueish
}
