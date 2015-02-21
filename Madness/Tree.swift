//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns the 0th element.
public func at0<A>(x: A) -> A {
	return x
}

/// Returns the 0th element.
public func at0<A, B>(x: (A, B)) -> A {
	return x.0
}


/// Returns the 1st element.
public func at1<A, B>(x: (A, B)) -> B {
	return x.1.0
}

/// Returns the 1st element.
public func at1<A, B, C>(x: (A, (B, C))) -> B {
	return x.1.0
}


/// Returns the 2nd element.
public func at2<A, B, C>(x: (A, (B, C))) -> C {
	return x.1.1.0
}

/// Returns the 2nd element.
public func at2<A, B, C, D>(x: (A, (B, (C, D)))) -> C {
	return x.1.1.0
}


/// Returns the 3rd element.
public func at3<A, B, C, D>(x: (A, (B, (C, D)))) -> D {
	return x.1.1.1.0
}

/// Returns the 3rd element.
public func at3<A, B, C, D, E>(x: (A, (B, (C, (D, E))))) -> D {
	return x.1.1.1.0
}


/// Returns the 4th element.
public func at4<A, B, C, D, E>(x: (A, (B, (C, (D, E))))) -> E {
	return x.1.1.1.1.0
}

/// Returns the 4th element.
public func at4<A, B, C, D, E, F>(x: (A, (B, (C, (D, (E, F)))))) -> E {
	return x.1.1.1.1.0
}


/// Returns the 5th element.
public func at5<A, B, C, D, E, F>(x: (A, (B, (C, (D, (E, F)))))) -> F {
	return x.1.1.1.1.1.0
}

/// Returns the 5th element.
public func at5<A, B, C, D, E, F, G>(x: (A, (B, (C, (D, (E, (F, G))))))) -> F {
	return x.1.1.1.1.1.0
}


// MARK: - Imports

import Prelude
