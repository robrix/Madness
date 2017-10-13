//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// A composite error.
public enum Error<I: ForwardIndexType>: ErrorType, CustomStringConvertible {
	indirect case Branch(String, SourcePos<I>, [Error])

	/// Constructs a leaf error, e.g. for terminal parsers.
	public static func leaf(reason: String, _ sourcePos: SourcePos<I>) -> Error {
		return .Branch(reason, sourcePos, [])
	}

	public static func withReason(reason: String, _ sourcePos: SourcePos<I>) -> (Error, Error) -> Error {
		return { Error(reason: reason, sourcePos: sourcePos, children: [$0, $1]) }
	}

	public init(reason: String, sourcePos: SourcePos<I>, children: [Error]) {
		self = .Branch(reason, sourcePos, children)
	}


	public var reason: String {
		switch self {
		case let .Branch(s, _, _):
			return s
		}
	}

	public var sourcePos: SourcePos<I> {
		switch self {
		case let .Branch(_, sourcePos, _):
			return sourcePos
		}
	}

	public var children: [Error] {
		switch self {
		case let .Branch(_, _, c):
			return c
		}
	}


	public var depth: Int {
		return 1 + ((children.sort { $0.depth < $1.depth }).last?.depth ?? 0)
	}


	// MARK: Printable
	
	public var description: String {
		return describe(0)
	}

	private func describe(n: Int) -> String {
		let description = String(count: n, repeatedValue: "\t" as Character) + "\(sourcePos.index): \(reason)"
		if children.count > 0 {
			return description + "\n" + children.lazy.map { $0.describe(n + 1) }.joinWithSeparator("\n")
		}
		return description
	}
}


/// MARK: - Annotations

/// Annotate a parser with a name.
public func <?> <C: CollectionType, T>(parser: Parser<C, T>.Function, name: String) -> Parser<C, T>.Function {
	return describeAs(name)(parser)
}

/// Adds a name to parse errors.
public func describeAs<C: CollectionType, T>(name: String) -> Parser<C, T>.Function -> Parser<C, T>.Function {
	return { parser in
		{ input, index in
			parser(input, index).mapError {
				Error(reason: "\(name): \($0.reason)", sourcePos: $0.sourcePos, children: $0.children)
			}
		}
	}
}


// MARK: - Operators

infix operator <?> {
	associativity left
	precedence 90
}
