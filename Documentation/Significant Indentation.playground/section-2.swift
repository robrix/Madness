// MARK: - Lexing rules

let newline = ignore("\n")
let ws = %" " | %"\t"
let text = %("a"..."z") | %("A"..."Z") | %("0"..."9") | ws
let restOfLine = (text+ --> { "".join($0) }) ++ newline


// MARK: - AST

enum Node: Printable {
	case Blockquote([Node])
	case Header(Int, String)


	func analysis<T>(#ifBlockquote: [Node] -> T, ifHeader: (Int, String) -> T) -> T {
		switch self {
		case let Blockquote(nodes):
			return ifBlockquote(nodes)
		case let Header(level, text):
			return ifHeader(level, text)
		}
	}


	// MARK: Printable

	var description: String {
		return analysis(
			ifBlockquote: { "<blockquote>\n\t" + "\n\t".join(lazy($0).map(toString)) + "\n</blockquote>" },
		ifHeader: { "<h\($0)>\($1)</h\($0)>" })
	}
}


// MARK: - Parsing rules

let header = ((%"#" * (1..<7)) --> { $0.count }) ++ ignore(" ") ++ restOfLine --> { Node.Header($0, $1) }
let blockquote = ignore(">") ++ ignore(" ") ++ restOfLine

let s = header("# Words\n")?.0
