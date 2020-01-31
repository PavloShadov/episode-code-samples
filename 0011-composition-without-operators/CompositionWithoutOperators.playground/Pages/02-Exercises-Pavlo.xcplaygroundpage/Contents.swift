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
func pipe<A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}

func backPipe<A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
  return { f(g($0)) }
}

func with<A, B>(_ a: A, _ f: (A) -> B) -> B {
  return f(a)
}

func second<A, B, C>(_ f: @escaping (B) -> C) -> ((A, B)) -> (A, C) {
  return { ($0.0, f($0.1)) }
}

func first<A, B, C>(_ f: @escaping (A) -> B) -> ((A, C)) -> (B, C) {
  return { (f($0.0), $0.1) }
}

func map<A, B>(_ f: @escaping(A) -> B) -> ([A]) -> [B] {
  return { $0.map(f) }
}


let targetOne = ((1, "One"), false)

//targetOne
//  |> (first <<< first)(incr)
//  |> (first <<< second) { $0.uppercased() }
//  |> second { !$0 }

with(targetOne,
  pipe(
    pipe(
      backPipe(first, first)(incr),
      backPipe(first, second)({ $0 + "!" })
    ),
    second { !$0 }
  )
)

