/*:
 # Algebraic Data Types Exercises

 1. What algebraic operation does the function type `(A) -> B` correspond to? Try explicitly enumerating all the values of some small cases like `(Bool) -> Bool`, `(Unit) -> Bool`, `(Bool) -> Three` and `(Three) -> Bool` to get some intuition.
 */
// Bool -> Bool
// true -> true, false -> true
// true -> false, false -> false
// true -> false, false -> true
// true -> true, false -> false

// (Void) -> Bool
// () -> true
// () -> false

// Bool -> Three
// true -> .one, false -> .one
// true -> .two, false -> .two
// true -> .three, false -> .three
// true -> .one, false -> .two
// true -> .one, false -> .three
// true -> .two, false -> .one
// true -> .two, false -> .three
// true -> .three, false -> .one
// true -> .three, false -> .two

// (A) -> B
// b^a
/*:
 2. Consider the following recursively defined data structure. Translate this type into an algebraic equation relating `List<A>` to `A`.
 */
indirect enum List<A> {
  case empty
  case cons(A, List<A>)
}

// List<A> = 1 + A * List<A>

// With recursion:
// = 1 + A * (1 + A * List<A>)
//= 1 + A + A^2 * List<A>
//= 1 + A + A^2 * (1 + A * List<A>)
//= 1 + A + A^2 + A^3 * List<A>
//= 1 + A + A^2 + A^3 * (1 + A * List<A>)
//= 1 + A + A^2 + A^3 + A^4 * List<A>...
/*:
 3. Is `Optional<Either<A, B>>` equivalent to `Either<Optional<A>, Optional<B>>`? If not, what additional values does one type have that the other doesn’t?
 */
// Either<A, B>
// A OR B = a + b

// Optional<Either<A, B>>
// nil OR A OR B = 1 + (A + B)

// Either<Optional<A>, Optional<B>>
// nilA OR A OR nilB OR B = (1 + A) + (1 + B)
/*:
 4. Is `Either<Optional<A>, B>` equivalent to `Optional<Either<A, B>>`?
 */
// Either<Optional<A>, B>
// nilA OR A OR B = (1 + A) + B

// Optional<Either<A, B>>
// nil OR A OR B = 1 + (A + B)
/*:
 5. Swift allows you to pass types, like `A.self`, to functions that take arguments of `A.Type`. Overload the `*` and `+` infix operators with functions that take any type and build up an algebraic representation using `Pair` and `Either`. Explore how the precedence rules of both operators manifest themselves in the resulting types.
 */
enum Either<A, B> {
  case first(A)
  case second(B)
}

struct Pair<A, B> {
  let first: A
  let second: B
}

func +<A, B>(_ lhs: A.Type, rhs: B.Type) -> Either<A, B>.Type {
  Either<A, B>.self
}

func *<A, B>(_ lhs: A.Type, rhs: B.Type) -> Pair<A, B>.Type {
  Pair<A, B>.self
}

Void.self + Bool.self * Int.self // Either<Void, Pair<Bool, Int>>
Never.self * Void.self + Bool.self * Void.self // Either<Pair<Never, Void>, Pair<Bool, Void>>
Bool.self + Int.self + Float.self // Either<Either<Bool, Int>, Float>
Bool.self + Int.self + Float.self * Void.self // Either<Either<Bool, Int>, Pair<Float, Void>>
