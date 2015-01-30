//  Copyright (c) 2015 Rob Rix. All rights reserved.

import XCTest

struct Tree<T: Equatable>: Equatable, Printable {
	init(_ value: T, _ children: [Tree] = []) {
		self.values = [ value ]
		self.children = children
	}

	let values: [T]
	let children: [Tree]


	// MARK: Printable

	var description: String {
		let space = " "
		let valueString = space.join(map(values, toString))
		return children.count > 0 ?
			"(\(valueString) \(space.join(map(children, toString))))"
		:	"(\(valueString))"
	}
}

func == <T: Equatable> (left: Tree<T>, right: Tree<T>) -> Bool {
	return left.values == right.values && left.children == right.children
}

final class BindTests: XCTestCase {
}
