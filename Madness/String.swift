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

public let double: DoubleParser = {
	let minus = (%"-")|?
	let digits = digit+
	
	return minus >>- { sign in
		digits >>- { digits in
			let double = digits.reduce(0.0, combine: { num, char in
				return 10 * num + Double(String(char))!
			})

			return pure(sign != nil ? double : -1 * double)
		}
	}
}()

public let digit: CharacterParser = oneOf("0123456789")

public let space: CharacterParser = char(" ")

public let newline: CharacterParser = char("\n")

public let crlf: CharacterParser = char("\r\n")

public let endOfLine: CharacterParser = newline <|> crlf

public let tab: CharacterParser = char("\t")

public func oneOf(input: String) -> CharacterParser {
	return satisfy { input.characters.contains($0) }
}

public func noneOf(input: String) -> CharacterParser {
	return satisfy { !input.characters.contains($0) }
}

public func char(input: Character) -> CharacterParser {
	return satisfy { $0 == input }
}

public func string(input: String) -> StringParser {
	return %input
}
