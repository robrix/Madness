// MARK: - Lexing rules

let newline = ignore("\n")
let ws = %" " | %"\t"
let lower = %("a"..."z")
let upper = %("A"..."Z")
let digit = %("0"..."9")
let text = lower | upper | digit | ws
let restOfLine: Parser<String, String>.Function = (text+ |> map { "".join($0) }) ++ newline


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

typealias NodeParser = Parser<String, Ignore>.Function -> Parser<String, Node>.Function

let element: NodeParser = fix { element in
	{ prefix in
		let prefixedElements: NodeParser = {
			let each = (element(prefix ++ $0) | (prefix ++ $0 ++ newline)) |> map { $0.map { [ $0 ] } ?? [] }
      return (each)+ |> map { Node.Blockquote(join([], $0)) }
		}

		let octothorpes: Parser<String, Int>.Function = (%"#" * (1..<7)) |> map { $0.count }
		let header: Parser<String, Node>.Function = prefix ++ octothorpes ++ ignore(" ") ++ restOfLine |> map { (level: Int, title: String) in Node.Header(level, title) }
		let paragraph: Parser<String, Node>.Function = (prefix ++ restOfLine)+ |> map { Node.Paragraph("\n".join($0)) }
		let blockquote: Parser<String, Node>.Function = prefix ++ { prefixedElements(ignore("> "))($0, $1) }

		return header | paragraph | blockquote
	}
}

let ok: Parser<String, Ignore>.Function = { (Ignore(), $1) }
let parsed = parse(element(ok), "> # hello\n> \n> hello\n> there\n> \n> \n")
if let translated = parsed.0 {
	translated.description
}
