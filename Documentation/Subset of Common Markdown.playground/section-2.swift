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

typealias NodeParser = Parser<()>.Function -> Parser<Node>.Function

let element: NodeParser = fix { element in
	{ prefix in
		let prefixedElements: NodeParser = {
			let each = (element(prefix ++ $0) | (prefix ++ $0 ++ newline)) --> { $0.map { [ $0 ] } ?? [] }
			return (each)+ --> { Node.Blockquote(join([], $0)) }
		}

		let header = prefix ++ ((%"#" * (1..<7)) --> { $0.count }) ++ ignore(" ") ++ restOfLine --> { Node.Header($0, $1) }
		let paragraph = (prefix ++ restOfLine)+ --> { Node.Paragraph("\n".join($0)) }
		let blockquote = prefix ++ { prefixedElements(ignore("> "))($0) }

		return header | paragraph | blockquote
	}
}

let ok: Parser<()>.Function = { ((), $0) }
let parsed = parse(element(ok), "> # hello\n> \n> hello\n> there\n> \n> \n")
if let translated = parsed?.0 {
	translated.description
}
