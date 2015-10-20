//
//  String.swift
//  Madness
//
//  Created by Josh Vera on 10/19/15.
//  Copyright © 2015 Rob Rix. All rights reserved.
//

import Foundation

public typealias CharacterParser = Parser<String.CharacterView, Character>.Function
public typealias StringParser = Parser<String.CharacterView, String>.Function
public typealias DoubleParser = Parser<String.CharacterView, Double>.Function

public func digit() -> CharacterParser {
	return oneOf("123456789")
}

public func double() -> DoubleParser {
	let minus = (%"-")|?
	let digits = digit()+
	
	return minus >>- { sign in
		digits >>- { digits in
			let toDouble = { (chars: [Character]) in
				chars.reduce(0.0, combine: { (num: Double, c: Character) in
					return 10 * num + Double(String(c))!
				})
			}
			let double = toDouble(digits)

			return pure(sign != nil ? double : -1 * double)
		}
	}
}

public func oneOf(input: String) -> CharacterParser {
	return satisfy { input.characters.contains($0) }
}

public func noneOf(input: String) -> CharacterParser {
	return satisfy { !input.characters.contains($0) }
}

public func space() -> CharacterParser {
	return satisfy { $0 == " " }
}

public func newline() -> CharacterParser {
	return satisfy { $0 == "\n" }
}

public func crlf() -> CharacterParser {
	return satisfy { $0 == "\r" }
}

public func endOfLine() -> CharacterParser {
	return newline() <|> crlf()
}

public func tab() -> CharacterParser {
	return satisfy { $0 == "\t" }
}

public func char(input: Character) -> CharacterParser {
	return satisfy { $0 == input }
}

public func string(input: String) -> StringParser {
	return %input
}
