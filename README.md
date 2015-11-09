# Recursive Descent into Madness

Madness is a Swift µframework for parsing strings in simple context-free grammars. Combine parsers from simple Swift expressions and parse away:

```swift
let digit = %("0"..."9") <|> %("a"..."f") <|> %("A"..."F")
let hex = digit+ |> map { strtol(join("", $0), nil, 16) }
parse(%"0x" *> hex, "0xdeadbeef") // => 3,735,928,559
```

Your parsers can produce your own model objects directly, making Madness ideal for experimenting with grammars, for example in a playground.

![screenshot of parsing HTML colours in an Xcode playground: `let reddish = parse(colour, "#d52a41")!`](https://cloud.githubusercontent.com/assets/59671/5415280/1453c774-81f4-11e4-8726-b51423bb06f9.png)

See `Madness.playground` for some examples of parsing with Madness.


## Use

- **Lexing**

	Madness can be used to write lexers, lexeme parsers, and scannerless parsers. @bencochran has built a [lexer and parser for the LLVM tutorial language, Kaleidoscope](https://github.com/bencochran/KaleidoscopeLang).

- **Any**

	```swift
	any
	```

	parses any single character.

- **Strings**

	```swift
	%"hello"
	```

	parses the string “hello”.

- **Ranges**

	```swift
	%("a"..."z")
	```

	parses any lowercase letter from “a” to “z” inclusive.

- **Concatenation**

	```swift
	x <*> y <*> z
	```

	parses `x` followed by `y` and produces parses as `(X, Y)`.

- **Alternation**

	```swift
	x <|> y
	```

	parses `x`, and if it fails, `y`, and produces parses as `Either<X, Y>`. If `x` and `y` are of the same type, then it produces parses as `X`.

	```swift
	oneOf([x1, x2, x3])
	```

	tries a sequence of parsers until the first success, producing parses as `X`.

	```swift
	anyOf(["x", "y", "z"])
	```

	tries to parse one each of a set of literals in sequence, collecting each successful parse into an array until none match.

	```swift
	allOf(["x", "y", "z"])
	```

	greedier than `anyOf`, parsing every match from a set of literals in sequence, including duplicates.

- **Repetition**

	```swift
	x*
	```

	parses `x` 0 or more times, producing parses as `[X]`.

	```swift
	x+
	```

	parses `x` one or more times.

	```swift
	x * 3
	```

	parses `x` exactly three times.

	```swift
	x * (3..<6)
	```

	parses `x` three to five times. Use `Int.max` for the upper bound to parse three or more times.

- **Mapping**

	```swift
	x |> map { $0 }
	{ $0 } <^> x
	x --> { _, _, y in y }
	```

	parses `x` and maps its parse trees using the passed function. Use mapping to build your model objects. `-->` passes the input and parsed range as well as the parsed data for e.g. error reporting or AST construction.

- **Ignoring**

	Some text is just decoration. `x *> y` parses `x` and then `y` just like `<*>`, but drops the result of `x`. `x <* y` does the same, but drops the result of `y`.

API documentation is in the source.


## This way Madness lies

### ∞ loop de loops

Madness employs simple—naïve, even—recursive descent parsing. Among other things, that means that it can’t parse any arbitrary grammar that you could construct with it. In particular, it can’t parse left-recursive grammars:

```swift
let number = %("0"..."9")
let addition = expression <*> %"+" <*> expression
let expression = addition <|> number
```

`expression` is left-recursive: its first term is `addition`, whose first term is `expression`. This will cause infinite loops every time `expression` is invoked; try to avoid it.


### I love ambiguity more than [@numist](https://twitter.com/numist/status/423722622031908864)

Alternations try their left operand before their operand, and are short-circuiting. This means that they disambiguate (arbitrarily) to the left, which can be handy; but this can have unintended consequences. For example, this parser:

```swift
%"x" <|> %"xx"
```

will not parse “xx” completely.


## Integration

1. Add this repository as a submodule and check out its dependencies, and/or [add it to your Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile) if you’re using [carthage](https://github.com/Carthage/Carthage/) to manage your dependencies.
2. Drag `Madness.xcodeproj` into your project or workspace, and do the same with its dependencies (i.e. the other `.xcodeproj` files included in `Madness.xcworkspace`). NB: `Madness.xcworkspace` is for standalone development of Madness, while `Madness.xcodeproj` is for targets using Madness as a dependency.
3. Link your target against `Madness.framework` and each of the dependency frameworks.
4. Application targets should ensure that the framework gets copied into their application bundle. (Framework targets should instead require the application linking them to include Madness and its dependencies.)
