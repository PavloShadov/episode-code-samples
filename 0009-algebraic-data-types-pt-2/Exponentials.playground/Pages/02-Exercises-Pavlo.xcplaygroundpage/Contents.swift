/*:
 # Algebraic Data Types: Exponents, Exercises

 1. Explore the equivalence of `1^a = a`.
 */
// 1^a = a
// Void <- A = A
// (A) -> Void = A : this is absurd
/*:
  2. Explore the properties of `0^a`. Consider the cases where `a = 0` and `a != 0` separately.
 */
pow(0, 0)
pow(0, 100)
// 0^a = 0, when a != 0
// (A) -> Never = Never

func crash<A>(_ f: (A) -> Never) -> Never { abort() }

// 0^a = 1, then a = 0
// (A) -> Never = Void

func doNothing<A>(_ f: (A) -> Never) -> Void {}
/*:
  3. How do you think generics fit into algebraic data types? We've seen a bit of this with thinking of `Optional<A>` as `A + 1 = A + Void`.
  */
// Array<A> = A + A + A + ... A ???
/*:
  4. Show that the set type over a type `A` can be represented as `2^A`. What does union and intersection look like in this formulation?
  */
//  2^A = Set<A>
//  (A) -> Bool = Set<A>

// func toSet<A>(_ f: (A) -> Bool) -> Set<A> {
//    let res: Set<A> = []
//    return res
// }

// Union:
// Set<A> * Set<A> = 2^A * 2^A = 2^(A + A) = 2^(2 * A)
// (Bool, A) -> Bool = Set<A> * Set<A>

// Intersection: Set<A> + Set<A> = 2^A + 2^A = 2 * 2^A
// (Bool, (A) -> Bool) = Set<A> + Set<A>
/*:
  5. Show that the dictionary type with keys in `K`  and values in `V` can be represented by `V^K`. What does union of dictionaries look like in this formulation?
  */
// (K) -> V = Dictionary<K, V>
// func toDict<K, V>(_ f: (K) -> V) -> Dictionary<K, V> {
//  return Dictionary[k] = f(k)
// }
/*:
  6. Implement the following equivalence:
  */
func to<A, B, C>(_ f: @escaping (Either<B, C>) -> A) -> ((B) -> A, (C) -> A) {
  return
    ({ b in
        f(.left(b))
      },
      { c in
        f(.right(c))
      })
}

func from<A, B, C>(_ f: ((B) -> A, (C) -> A)) -> (Either<B, C>) -> A {
  return  { either in
    switch either {
    case .left(let b):
      return f.0(b)
    case .right(let c):
      return f.1(c)
    }
  }
}
/*:
  7. Implement the following equivalence:
  */
func to<A, B, C>(_ f: @escaping (C) -> (A, B)) -> ((C) -> A, (C) -> B) {
  return
    ({ c in
      f(c).0
    },
    { c in
      f(c).1
    })
}

func from<A, B, C>(_ f: ((C) -> A, (C) -> B)) -> (C) -> (A, B) {
  return { (f.0($0), f.1($0)) }
}
