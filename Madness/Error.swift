//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Result

/// A composite error.
public enum Error<I: Comparable>: Swift.Error, CustomStringConvertible {
	indirect case branch(String, SourcePos<I>, [Error])

	/// Constructs a leaf error, e.g. for terminal parsers.
	public static func leaf(_ reason: String, _ sourcePos: SourcePos<I>) -> Error {
		return .branch(reason, sourcePos, [])
	}

	public static func withReason(_ reason: String, _ sourcePos: SourcePos<I>) -> (Error, Error) -> Error {
		return { Error(reason: reason, sourcePos: sourcePos, children: [$0, $1]) }
	}

	public init(reason: String, sourcePos: SourcePos<I>, children: [Error]) {
		self = .branch(reason, sourcePos, children)
	}


	public var reason: String {
		switch self {
		case let .branch(s, _, _):
			return s
		}
	}

	public var sourcePos: SourcePos<I> {
		switch self {
		case let .branch(_, sourcePos, _):
			return sourcePos
		}
	}

	public var children: [Error] {
		switch self {
		case let .branch(_, _, c):
			return c
		}
	}


	public var depth: Int {
		return 1 + ((children.sorted { $0.depth < $1.depth }).last?.depth ?? 0)
	}


	// MARK: Printable
	
	public var description: String {
		return describe(0)
	}

	fileprivate func describe(_ n: Int) -> String {
		let description = String(repeating: "\t", count: n) + "\(sourcePos.index): \(reason)"
		if children.count > 0 {
			return description + "\n" + children.lazy.map { $0.describe(n + 1) }.joined(separator: "\n")
		}
		return description
	}
}


/// MARK: - Annotations

/// Annotate a parser with a name.
public func <?> <C: Collection, T>(parser: @escaping Parser<C, T>.Function, name: String) -> Parser<C, T>.Function {
	return describeAs(name)(parser)
}

/// Adds a name to parse errors.
public func describeAs<C: Collection, T>(_ name: String) -> (@escaping Parser<C, T>.Function) -> Parser<C, T>.Function {
	return { parser in
		{ input, index in
			return parser(input, index).mapError {
				Error(reason: "\(name): \($0.reason)", sourcePos: $0.sourcePos, children: $0.children)
			}
		}
	}
}


// MARK: - Operators

precedencegroup AnnotationPrecedence {
	associativity: left
	lowerThan: ChainingPrecedence
}

infix operator <?> : AnnotationPrecedence
