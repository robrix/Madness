//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Divides a `sliceable` into two subslices, before and after the given `offset`.
internal func divide<S: Sliceable>(sliceable: S, offset: S.Index.Distance) -> (S.SubSlice, S.SubSlice) {
	let (start, end) = (sliceable.startIndex, sliceable.endIndex)
	let divider = advance(start, offset, end)
	return (sliceable[start..<divider], sliceable[divider..<end])
}
