func toComponent(string: String) -> CGFloat {
  return CGFloat(strtol(string, nil, 16)) / 255
}

let digit = %("0"..."9")
let lower = %("a"..."f")
let upper = %("A"..."F")
let hex = digit | lower | upper
let hex2 = (hex ++ hex |> map { $0 + $1 })
let component1: Parser<String, CGFloat>.Function = hex |> map { toComponent($0 + $0) }
let component2: Parser<String, CGFloat>.Function = toComponent <^> hex2
let three: Parser<String, [CGFloat]>.Function = component1 * 3
let six: Parser<String, [CGFloat]>.Function = component2 * 3

let colour: Parser<String, NSColor>.Function = ignore("#") ++ (six | three) |> map {
	NSColor(calibratedRed: $0[0], green: $0[1], blue: $0[2], alpha: 1)
}

if let reddish = parse(colour, "#d52a41").right {
	reddish
}

if let greenish = parse(colour, "#5a2").right {
	greenish
}

if let blueish = parse(colour, "#5e8ca1").right {
	blueish
}
