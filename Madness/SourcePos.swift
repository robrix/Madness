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

extension SourcePos {
	/// Returns a new SourcePos advanced by the given index.
	public func advanced(to index: Index) -> SourcePos {
		return SourcePos(line: line, column: column, index: index)
	}
	
	/// Returns a new SourcePos advanced by `count`.
	public func advanced<C: Collection>(by distance: C.IndexDistance, from input: C) -> SourcePos where C.Index == Index {
		return advanced(to: input.index(index, offsetBy: distance))
	}
}

extension SourcePos where Index == String.Index {
	/// Returns a new SourcePos with its line, column, and index advanced by the given character.
	public func advanced(by char: Character, from input: String.CharacterView) -> SourcePos {
		let nextIndex = input.index(after: index)
		if char == "\n" {
			return SourcePos(line: line + 1, column: 0, index: nextIndex)
		} else if char == "\t" {
			return SourcePos(line: line, column: column + DefaultTabWidth - ((column - 1) % DefaultTabWidth), index: nextIndex)
		} else {
			return SourcePos(line: line, column: column + 1, index: nextIndex)
		}
	}

	/// Returns a new SourcePos with its line, column, and index advanced by the given string.
	func advanced(by string: String, from input: String.CharacterView) -> SourcePos {
		return string.characters.reduce(self) { $0.advanced(by: $1, from: input) }
	}
}
