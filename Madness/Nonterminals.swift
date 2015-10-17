//  Copyright (c) 2015 Rob Rix. All rights reserved.

func concatenate<T, U, V>(left: Prism<Stream<T>, U>, right: Prism<Stream<T>, V>) -> Prism<Stream<T>, (U, V)> {
	return Prism(
		forward: { (left.forward($0) &&& right.forward($0.rest)) },
		backward: { left.backward($0.0) ++ right.backward($0.1) })
}

func alternate<T, U, V>(left: Prism<Stream<T>, U>, right: Prism<Stream<T>, V>) -> Prism<Stream<T>, Either<U, V>> {
	return Prism(
		forward: { left.forward($0).map(Either.left) ?? right.forward($0).map(Either.right) },
		backward: { $0.either(ifLeft: left.backward, ifRight: right.backward) })
}

func `repeat`<T, U>(parser: Prism<Stream<T>, U>) -> Prism<Stream<T>, [U]> {
	let forward: Stream<T> -> [U] = fix { f in
		{ stream in parser.forward(stream).map { [ $0 ] + f(stream.rest) } ?? [] }
	}
	let backward: [U] -> Stream<T> = { $0.lazy.map(parser.backward).reduce(nil, combine: ++) }
	return Prism(
		forward: { forward($0) },
		backward: backward)
}


import Either
import Prelude
import Stream
