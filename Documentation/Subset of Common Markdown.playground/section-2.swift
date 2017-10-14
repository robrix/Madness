// MARK: - Lexing rules

let newline = %"\n"
let ws = %" " <|> %"\t"
let lower = %("a"..."z")
let upper = %("A"..."Z")
let digit = %("0"..."9")
let text = lower <|> upper <|> digit <|> ws
let restOfLine = { $0.joined(separator: "") } <^> many(text) <* newline
let texts = { $0.joined(separator: "") } <^> some(text <|> (%"" <* newline))

// MARK: - AST

enum Node: CustomStringConvertible {
	case blockquote([Node])
	case header(Int, String)
	case paragraph(String)
    
    func analysis<T>(ifBlockquote: ([Node]) -> T, ifHeader: (Int, String) -> T, ifParagraph: (String) -> T) -> T {
		switch self {
		case let .blockquote(nodes):
			return ifBlockquote(nodes)
		case let .header(level, text):
			return ifHeader(level, text)
		case let .paragraph(text):
			return ifParagraph(text)
		}
	}

	// MARK: Printable

	var description: String {
		return analysis(
			ifBlockquote: { "<blockquote>" + $0.lazy.map{ $0.description }.joined(separator: "") + "</blockquote>" },
			ifHeader: { "<h\($0)>\($1)</h\($0)>" },
			ifParagraph: { "<p>\($0)</p>" })
	}
}


// MARK: - Parsing rules

typealias NodeParser = Parser<String.CharacterView, Node>.Function
typealias ElementParser = (@escaping StringParser) -> NodeParser

func fix<T, U>(_ f: @escaping (@escaping (T) -> U) -> (T) -> U) -> (T) -> U {
    return { f(fix(f))($0) }
}

let element: ElementParser = fix { element in
	{ prefix in

		let octothorpes: IntParser = { $0.count } <^> (%"#" * (1..<7))
		let header: NodeParser = prefix *> ( Node.header <^> (lift(pair) <*> octothorpes <*> (%" " *> restOfLine)) )
		let paragraph: NodeParser = prefix *> ( Node.paragraph <^> texts )
		let blockquote: NodeParser = prefix *> { ( Node.blockquote <^> some(element(prefix *> %"> ")) )($0, $1) }
		
		return header <|> paragraph <|> blockquote
	}
}

let parser = many(element(pure("")))
if let parsed = parse(parser, input: "> # hello\n> \n> hello\n> there\n> \n> \n").value {
    let description = parsed.reduce(""){ $0 + $1.description }
}

if let parsed = parse(parser, input: "This is a \nparagraph\n> # title\n> ### subtitle\n> a").value {
    let description = parsed.reduce(""){ $0 + $1.description }
}

