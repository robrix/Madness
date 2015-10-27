//  Copyright (c) 2014 Josh Vera. All rights reserved.

import Prelude

struct SourcePos {
	typealias Line = Int
	typealias Column = Int
	typealias SourceName = String

	let line: Line
	let column: Column
}

func updatePosCharacter(pos: SourcePos, char: Character) -> SourcePos {
	if char == "\n" {
		return SourcePos(line: pos.line + 1, column: pos.column)
	} else if char == "\t" {
		return SourcePos(line: pos.line, column: pos.column + 8 - ((pos.column - 1) % 8))
	} else {
		return SourcePos(line: pos.line, column: pos.column + 1)
	}
}

func updatePosString(pos: SourcePos, string: String) -> SourcePos {
	return string.characters.reduce(pos, combine: updatePosCharacter)
}