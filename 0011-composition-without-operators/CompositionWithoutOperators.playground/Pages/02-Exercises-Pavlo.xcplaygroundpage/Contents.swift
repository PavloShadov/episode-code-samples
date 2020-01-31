/*:
 # Composition without Operators

 1. Write concat for functions (inout A) -> Void.
 */
func concat<A>(_ f: @escaping (inout A) -> Void,
               _ g: @escaping (inout A) -> Void,
               _ fs: ((inout A) -> Void)...) -> (inout A) -> Void {
  return { a in
    f(&a)
    g(&a)
    fs.forEach { f in f(&a) }
  }
}
/*:
 2. Write concat for functions (A) -> A.
 */
func concat<A>(_ f: @escaping (A) -> A,
               _ g: @escaping (A) -> A,
               _ fs: ((A) -> A)...) -> (A) -> A {
  return { a in
//    THIS SOLUTION DOESN'T WORK BECAUSE OF ONE ADDITIONAL FUNCTION CALL
//    guard let firstVariadicFunc = fs.first else { return a |> f >>> g }
//    return a |> f >>> g >>> fs.reduce(firstVariadicFunc, >>>)
    let allFunctions = [f, g] + fs
    return allFunctions.reduce(a, { result, element in element(result) })
  }
}

concat(incr, incr, incr, incr)(3)
/*:
 3. Write compose for backward composition. Recreate some of the examples from our functional setters episodes (part 1 and part 2) using compose and pipe.
 */
// TODO
