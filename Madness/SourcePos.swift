//  Copyright (c) 2014 Josh Vera. All rights reserved.

import Prelude

public struct SourcePos<Index: ForwardIndexType> {
	typealias Line = Int
	typealias Column = Int

	let line: Line
	let column: Column
	let index: Index
	
	init(index: Index) {
		line = 1
		column = 1
		self.index = index
	}
	
	init(line: Line, column: Column, index: Index) {
		self.line = line
		self.column = column
		self.index = index
	}
}

func updateIndex<Index: ForwardIndexType>(pos: SourcePos<Index>, _ index: Index) -> SourcePos<Index> {
	return SourcePos.init(line: pos.line, column: pos.column, index: index)
}

func updatePosCharacter(pos: SourcePos<String.Index>, _ char: Character) -> SourcePos<String.Index> {
	let nextIndex = pos.index.successor()
	if char == "\n" {
		return SourcePos(line: pos.line + 1, column: pos.column, index: nextIndex)
	} else if char == "\t" {
		return SourcePos(line: pos.line, column: pos.column + 8 - ((pos.column - 1) % 8), index: nextIndex)
	} else {
		return SourcePos(line: pos.line, column: pos.column + 1, index: nextIndex)
	}
}

func updatePosString(pos: SourcePos<String.Index>, string: String) -> SourcePos<String.Index> {
	return string.characters.reduce(pos, combine: updatePosCharacter)
}