import Box
import Madness
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
