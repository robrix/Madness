func toComponent(string: String) -> CGFloat {
  return CGFloat(strtol(string, nil, 16)) / 255
}

let digit = %("0"..."9")
let lower = %("a"..."f")
let upper = %("A"..."F")
let hex = digit <|> lower <|> upper
let hex2 = lift(+) <*> hex <*> hex
let component1: Parser<String.CharacterView, CGFloat>.Function = hex |> map { toComponent($0 + $0) }
let component2: Parser<String.CharacterView, CGFloat>.Function = toComponent <^> hex2
let three: Parser<String.CharacterView, [CGFloat]>.Function = component1 * 3
let six: Parser<String.CharacterView, [CGFloat]>.Function = component2 * 3

let colour: Parser<String.CharacterView, NSColor>.Function = %"#" *> (six <|> three) |> map {
	NSColor(calibratedRed: $0[0], green: $0[1], blue: $0[2], alpha: 1)
}

if let reddish = parse(colour, input: "#d52a41").right {
	reddish
}

if let greenish = parse(colour, input: "#5a2").right {
	greenish
}

if let blueish = parse(colour, input: "#5e8ca1").right {
	blueish
}
