//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// A composite error.
public enum Error<I: ForwardIndexType> {
	case Leaf(String, Box<I>)
	case Branch([Error])
}


// MARK: - Imports

import Box
