import Madness
import Result

let input = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]

typealias Fibonacci = Parser<[Int], [Int]>.Function

func fibonacci(_ x: Int, _ y: Int) -> Fibonacci {
	let combined: Fibonacci = %(x + y) >>- { (xy: Int) -> Fibonacci in
		{ [ xy ] + $0 } <^> fibonacci(y, xy)
	}
	return combined <|> pure([])
}

parse(fibonacci(0, 1), input: input).value

