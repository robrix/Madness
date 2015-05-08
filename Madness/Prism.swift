//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct Prism<From, To> {
	let forward: From -> To?
	let backward: To -> From
}
import Prelude
