let toComponent: String -> CGFloat = { CGFloat(strtol($0, nil, 16)) / 255 }

let digit = %("0"..."9")
let lower = %("a"..."f")
let upper = %("A"..."F")
let hex = digit | lower | upper
let hex2 = (hex ++ hex --> { $0 + $1 })
let component1: Parser<String, CGFloat>.Function = hex --> { toComponent($0 + $0) }
let component2: Parser<String, CGFloat>.Function = hex2 --> toComponent
let three: Parser<String, [CGFloat]>.Function = component1 * 3
let six: Parser<String, [CGFloat]>.Function = component2 * 3

let colour: Parser<String, NSColor>.Function = ignore("#") ++ (six | three) --> {
	NSColor(calibratedRed: $0[0], green: $0[1], blue: $0[2], alpha: 1)
}

if let reddish = parse(colour, "#d52a41") {
	reddish
}

if let greenish = parse(colour, "#5a2") {
	greenish
}

if let blueish = parse(colour, "#5e8ca1") {
	blueish
}
