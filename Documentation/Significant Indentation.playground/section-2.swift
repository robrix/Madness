// MARK: - Lexing rules

let newline = ignore("\n")
let ws = %" " | %"\t"
let text = %("a"..."z") | %("A"..."Z") | %("0"..."9") | ws
let restOfLine = (text+ --> { "".join($0) }) ++ newline


// MARK: - AST

enum Node {
	case Header(Int, String)
}


// MARK: - Parsing rules

let header = ((%"#" * (1..<7)) --> { $0.count }) ++ ignore(" ") ++ restOfLine --> { Node.Header($0, $1) }

let s = header("# Words\n")?.0
