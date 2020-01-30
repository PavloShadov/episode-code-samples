/*:
 # A Tale of Two Flat-Maps, Exercises

 1. Define `filtered` as a function from `[A?]` to `[A]`.
 */
func filtered<A>(_ input: [A?]) -> [A] {
  return input.compactMap { $0 }
}

filtered([1, 2, nil, 5])
/*:
 2. Define `partitioned` as a function from `[Either<A, B>]` to `(left: [A], right: [B])`. What does this function have in common with `filtered`?
 */
func partioned<A, B>(_ input: [Either<A, B>]) -> (left: [A], right: [B]) {
  var result = (left: [A](), right: [B]())
  
  for x in input {
    switch x {
    case .left(let l):
      result.left.append(l)
    case .right(let r):
      result.right.append(r)
    }
  }
  
  return result
}

let eithers: [Either<Int, String>] = [.left(4), .right("Hello"), .right("World"), .left(0)]
partioned(eithers)

/*:
 3. Define `partitionMap` on `Optional`.
 */
extension Optional {
  func partionMap<A>(_ transform: @escaping (Wrapped) -> A?) -> A? {
    switch self {
    case .none:
      return nil
    case .some(let value):
      return transform(value)
    }
  }
}

/*:
 4. Dictionary has `mapValues`, which takes a transform function from `(Value) -> B` to produce a new dictionary of type `[Key: B]`. Define `filterMapValues` on `Dictionary`.
 */
extension Dictionary {
  func filterMapValues<A>(_ transform: @escaping (Value) -> A?) -> [Key: A] {
    var result = [Key: A]()
    
    for (key, value) in self {
      if let filteredValue = transform(value) {
        result[key] = filteredValue
      }
    }
    
    return result
  }
}
/*:
 5. Define `partitionMapValues` on `Dictionary`.
 */
extension Dictionary {
  func partitionMapValues<A, B>(_ transform: @escaping (Value) -> Either<A, B>)
    -> (lefts: [Key: A], rights: [Key: B]) {
      
      var result = (lefts: [Key: A](), rights: [Key: B]())
      
      for (key, value) in self {
        switch transform(value) {
        case .left(let l):
          result.lefts[key] = l
        case .right(let r):
          result.rights[key] = r
        }
      }
      
      return result
  }
}


func partitionMapValues<A, B, Value, Key: Hashable>(_ f: @escaping (Value) -> Either<A, B>)
  -> ([Key: Value]) -> (lefts: [Key: A], rights: [Key: B]) {
    return { $0.partitionMapValues(f) }
}
/*:
 6. Rewrite `filterMap` and `filter` in terms of `partitionMap`.
 */
/*:
 7. Is it possible to define `partitionMap` on `Either`?
 */
