//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Prism<From, To> {
	let forward: From -> To?
	let backward: To -> From
}


// MARK: Composition

public func >>> <From, Middle, To> (left: Prism<From, Middle>, right: Prism<Middle, To>) -> Prism<From, To> {
	return compose(right, left)
}

private func compose<A, B, C>(g: Prism<B, C>, _ f: Prism<A, B>) -> Prism<A, C> {
	return Prism(
		forward: { f.forward($0).flatMap(g.forward) },
		backward: f.backward <<< g.backward)
}


import Prelude
