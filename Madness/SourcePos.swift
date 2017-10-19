//  Copyright (c) 2014 Josh Vera. All rights reserved.

public typealias Line = Int
public typealias Column = Int

var DefaultTabWidth = 8

public struct SourcePos<Index: Comparable> {
	public let line: Line
	public let column: Column
	public let index: Index
	
	public init(index: Index) {
		line = 1
		column = 1
		self.index = index
	}
	
	public init(line: Line, column: Column, index: Index) {
		self.line = line
		self.column = column
		self.index = index
	}

}

extension SourcePos: Equatable {
	/// Returns whether two SourcePos are equal.
	public static func ==(first: SourcePos, other: SourcePos) -> Bool {
		return first.line == other.line && first.column == other.column && first.index == other.index
	}
}

/// Returns a new SourcePos advanced by the given index.
public func updateIndex<Index>(_ pos: SourcePos<Index>, _ index: Index) -> SourcePos<Index> {
	return SourcePos.init(line: pos.line, column: pos.column, index: index)
}

/// Returns a new SourcePos with its line, column, and index advanced by the given character.
public func updatePosCharacter(_ input: String.CharacterView, _ pos: SourcePos<String.CharacterView.Index>, _ char: Character) -> SourcePos<String.CharacterView.Index> {
	let nextIndex = input.index(after: pos.index)
	if char == "\n" {
		return SourcePos(line: pos.line + 1, column: 0, index: nextIndex)
	} else if char == "\t" {
		return SourcePos(line: pos.line, column: pos.column + DefaultTabWidth - ((pos.column - 1) % DefaultTabWidth), index: nextIndex)
	} else {
		return SourcePos(line: pos.line, column: pos.column + 1, index: nextIndex)
	}
}

/// Returns a new SourcePos with its line, column, and index advanced by the given string.
func updatePosString(_ input: String.CharacterView, _ pos: SourcePos<String.Index>, _ string: String) -> SourcePos<String.Index> {
	return string.characters.reduce(pos) { updatePosCharacter(input, $0, $1) }
}
