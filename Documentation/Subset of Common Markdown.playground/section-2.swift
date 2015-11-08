// MARK: - Lexing rules

let newline = %"\n"
let ws = %" " <|> %"\t"
let lower = %("a"..."z")
let upper = %("A"..."Z")
let digit = %("0"..."9")
let text = lower <|> upper <|> digit <|> ws
let restOfLine = { $0.joinWithSeparator("") } <^> text* <* newline
let texts = { $0.joinWithSeparator("") } <^> (text <|> (%"" <* newline))+

// MARK: - AST

enum Node: CustomStringConvertible {
	case Blockquote([Node])
	case Header(Int, String)
	case Paragraph(String)
    
    func analysis<T>(ifBlockquote ifBlockquote: [Node] -> T, ifHeader: (Int, String) -> T, ifParagraph: String -> T) -> T {
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
			ifBlockquote: { "<blockquote>" + $0.lazy.map{ $0.description }.joinWithSeparator("") + "</blockquote>" },
			ifHeader: { "<h\($0)>\($1)</h\($0)>" },
			ifParagraph: { "<p>\($0)</p>" })
	}
}


// MARK: - Parsing rules

typealias NodeParser = Parser<String.CharacterView, Node>.Function
typealias ElementParser = StringParser -> NodeParser

let element: ElementParser = fix { element in
	{ prefix in

		let octothorpes: IntParser = { $0.count } <^> (%"#" * (1..<7))
		let header: NodeParser = prefix *> ( Node.Header <^> (lift(pair) <*> octothorpes <*> (%" " *> restOfLine)) )
		let paragraph: NodeParser = prefix *> ( Node.Paragraph <^> texts )
		let blockquote: NodeParser = prefix *> { ( Node.Blockquote <^> element(prefix *> %"> ")+ )($0, $1) }
		
		return header <|> paragraph <|> blockquote
	}
}

let parser = element(pure(""))*
if let parsed = parse(parser, input: "> # hello\n> \n> hello\n> there\n> \n> \n").right {
    let description = parsed.reduce(""){ $0 + $1.description }
}

if let parsed = parse(parser, input: "This is a \nparagraph\n> # title\n> ### subtitle\n> a").right {
    let description = parsed.reduce(""){ $0 + $1.description }
}

