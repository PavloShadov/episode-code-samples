/*:
 # The Many Faces of Map Exercises

 1. Implement a `map` function on dictionary values, i.e.

    ```
    map: ((V) -> W) -> ([K: V]) -> [K: W]
    ```

    Does it satisfy `map(id) == id`?

 */
func map<V, W, K: Hashable>(_ f: @escaping (V) -> W) -> ([K: V]) -> [K: W] {
  return { dict in
    var newDict = [K: W]()
    for (key, value) in zip(dict.keys, dict.values) {
      newDict[key] = f(value)
    }
    return newDict
  }
}

["first": 1, "second" : 2]
  |> map(incr)

// map(id) = id

//return { dict in
//  var newDict = [K: W]()
//  for (key, value) in zip(dict.keys, dict.values) {
//    newDict[key] = id(value)
//  }
//  return newDict
//}

//return { dict in
//  var newDict = [K: W]()
//  for (key, value) in zip(dict.keys, dict.values) {
//    newDict[key] = value
//  }
//  return newDict
//}

//return { dict in
//  var newDict = dict
//  return newDict
//}

//return { dict in
//  return dict
//}

//return { $0 }
/*:
 2. Implement the following function:

    ```
    transformSet: ((A) -> B) -> (Set<A>) -> Set<B>
    ```

    We do not call this `map` because it turns out to not satisfy the properties of `map` that we saw in this episode. What is it about the `Set` type that makes it subtly different from `Array`, and how does that affect the genericity of the `map` function?
 */
func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { xs in
    var result = [B]()
    xs.forEach { result.append(f($0)) }
    return result
  }
}

func transformSet<A, B>(_ f: @escaping (A) -> B) -> (Set<A>) -> Set<B> {
  return { set in
    var newSet = Set<B>()
    set.forEach { newSet.insert(f($0)) }
    return newSet
  }
}

func id<A>(_ a: A) -> A { a }
func hellofy(_ x: Int) -> String { String("Hello") }

let testSet: Set<Int> = [1, 2, 3, 3] // [1, 2, 3]
testSet
  |> transformSet { String($0) } // ["1", "3", "2"]

testSet
  |> transformSet(hellofy) // ["Hello"]

[1, 2, 3]
  |> map(hellofy) // ["Hello", "Hello", "Hello"]
/*:
 3. Recall that one of the most useful properties of `map` is the fact that it distributes over compositions, _i.e._ `map(f >>> g) == map(f) >>> map(g)` for any functions `f` and `g`. Using the `transformSet` function you defined in a previous example, find an example of functions `f` and `g` such that:

    ```
    transformSet(f >>> g) != transformSet(f) >>> transformSet(g)
    ```

    This is why we do not call this function `map`.
 */
func shout(_ x: String) -> String { x + "!"}

testSet
  |> transformSet(hellofy) >>> transformSet(shout)

testSet
  |> transformSet(hellofy >>> shout)


/*:
 4. There is another way of modeling sets that is different from `Set<A>` in the Swift standard library. It can also be defined as function `(A) -> Bool` that answers the question "is `a: A` contained in the set." Define a type `struct PredicateSet<A>` that wraps this function. Can you define the following?

     ```
     map: ((A) -> B) -> (PredicateSet<A>) -> PredicateSet<B>
     ```

     What goes wrong?
 */
// TODO
/*:
 5. Try flipping the direction of the arrow in the previous exercise. Can you define the following function?

    ```
    fakeMap: ((B) -> A) -> (PredicateSet<A>) -> PredicateSet<B>
    ```
 */
// TODO
/*:
 6. What kind of laws do you think `fakeMap` should satisfy?
 */
// TODO
/*:
 7. Sometimes we deal with types that have multiple type parameters, like `Either` and `Result`. For those types you can have multiple `map`s, one for each generic, and no one version is “more” correct than the other. Instead, you can define a `bimap` function that takes care of transforming both type parameters at once. Do this for `Result` and `Either`.
 */
// TODO
