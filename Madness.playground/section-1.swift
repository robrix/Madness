import Box
import Madness
enum Term: Printable {
	case Variable(String)
	case Abstraction(String, Box<Term>)
	case Application(Box<Term>, Box<Term>)
}
