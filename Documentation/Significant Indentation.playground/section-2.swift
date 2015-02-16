// MARK: - Lexing rules

let newline = ignore("\n")
let header = ((%"#" * (1..<7)) --> { $0.count }) ++ ignore(%" ") ++ (any+ --> { "".join($0) }) ++ newline
let ws = %" " | %"\t"
let text = %("a"..."z") | %("A"..."Z") | %("0"..."9") | ws
let restOfLine = (text+ --> { "".join($0) }) ++ newline
