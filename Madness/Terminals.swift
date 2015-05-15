//  Copyright (c) 2015 Rob Rix. All rights reserved.

func literal<T: Equatable>(element: T) -> Prism<Stream<T>, T> {
	return Prism(
		forward: { $0.first == element ? $0.first : nil },
		backward: Stream.pure)
}


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


import Either
import Prelude
import Stream
