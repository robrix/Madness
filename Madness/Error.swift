//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// A composite error.
public struct Error<I: ForwardIndexType>: Printable {
	/// Constructs a leaf error, e.g. for terminal parsers.
	public static func leaf(reason: String, _ index: I) -> Error {
		return Error(reason: reason, _index: Box(index), children: [])
	}

	public static func withReason(reason: String, _ index: I) -> (Error, Error) -> Error {
		return { Error(reason: reason, _index: Box(index), children: [$0, $1]) }
	}


	public let reason: String

	public var index: I {
		return _index.value
	}
	private let _index: Box<I>

	public let children: [Error]


	public var depth: Int {
		return 1 + ((sorted(children) { $0.depth < $1.depth }).last?.depth ?? 0)
	}


	// MARK: Printable

	public var description: String {
		return describe(0)
	}

	private func describe(n: Int) -> String {
		let description = String(count: n, repeatedValue: "\t" as Character) + "\(index): \(reason)"
		if children.count > 0 {
			return description + "\n" + "\n".join(lazy(children).map { $0.describe(n + 1) })
		}
		return description
	}
}


/// Adds a name to parse errors.
public func describeAs<C: CollectionType, T>(name: String)(_ parser: Parser<C, T>.Function) -> Parser<C, T>.Function {
	return { input, index in
		parser(input, index).either(
			ifLeft: { Either.left(Error(reason: "\(name): \($0.reason)", _index: $0._index, children: $0.children)) },
			ifRight: Either.right)
	}
}


import Box
import Either
import Prelude
