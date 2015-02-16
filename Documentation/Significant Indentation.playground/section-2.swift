// MARK: - Lexing rules

let newline = ignore("\n")
let ws = %" " | %"\t"
let text = %("a"..."z") | %("A"..."Z") | %("0"..."9") | ws
let restOfLine = (text+ --> { "".join($0) }) ++ newline


// MARK: - AST

enum Node: Printable {
	case Blockquote([Node])
	case Header(Int, String)
	case Paragraph(String)


	func analysis<T>(#ifBlockquote: [Node] -> T, ifHeader: (Int, String) -> T, ifParagraph: String -> T) -> T {
		switch self {
		case let Blockquote(nodes):
			return ifBlockquote(nodes)
		case let Header(level, text):
			return ifHeader(level, text)
		case let Paragraph(text):
			return ifParagraph(text)
		}
	}


	// MARK: Printable

	var description: String {
		return analysis(
			ifBlockquote: { "<blockquote>\n\t" + "\n\t".join(lazy($0).map { $0.description }) + "\n</blockquote>" },
			ifHeader: { "<h\($0)>\($1)</h\($0)>" },
			ifParagraph: { "<p>\($0)</p>" })
	}
}


// MARK: - Parsing rules

let element: Parser<Node>.Function = fix { element in
	let header = ((%"#" * (1..<7)) --> { $0.count }) ++ ignore(" ") ++ restOfLine --> { Node.Header($0, $1) }
	let paragraph = restOfLine --> { Node.Paragraph($0) }
	let blockquote: Parser<Node>.Function = (ignore(%">" ++ %" ") ++ (element | newline))+ --> {
		Node.Blockquote(reduce($0, []) { $0 + ($1.map { [ $0 ] } ?? []) })
	}
	return header | paragraph | blockquote
}

if let translated = element("> # Words\n> \n> paragraph\n")?.0 {
	translated.description
}
