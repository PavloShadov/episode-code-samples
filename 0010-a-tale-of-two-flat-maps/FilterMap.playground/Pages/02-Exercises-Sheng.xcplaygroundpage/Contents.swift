/*:
 # A Tale of Two Flat-Maps, Exercises

 1. Define `filtered` as a function from `[A?]` to `[A]`.
 */
func filtered<A>(_ xs: [A?]) -> [A] {
    var result = [A]()
    for x in xs {
        if let a = x { result.append(a) }
    }
    return result
}

let xs: [Int?] = [2, nil, 99, 8, 6]
filtered(xs)
/*:
 2. Define `partitioned` as a function from `[Either<A, B>]` to `(left: [A], right: [B])`. What does this function have in common with `filtered`?
 */
func partitioned<A, B>(_ es: [Either<A, B>]) -> (left: [A], right: [B]) {
    var result = (left: [A](), right: [B]())
    for e in es {
        switch e {
        case .left(let a): result.left.append(a)
        case .right(let b): result.right.append(b)
        }
    }
    return result
}

let es: [Either<Int, Int>] = [.right(3), .right(99), .left(7), .right(5), .left(1)]
partitioned(es)
/*:
 3. Define `partitionMap` on `Optional`.
 */
extension Optional {
    func partitionMap<A>(_ transform: (Wrapped) -> A?) -> A? {
        switch self {
        case .none: return nil
        case .some(let v): return transform(v)
        }
    }
}

extension Array {
    func partitionMap<A>(_ transform: (Element) -> A?) -> [A] {
        var result = [A]()
        for x in self {
            if let a = transform(x) { result.append(a) }
        }
        return result
    }
}
/*:
 4. Dictionary has `mapValues`, which takes a transform function from `(Value) -> B` to produce a new dictionary of type `[Key: B]`. Define `filterMapValues` on `Dictionary`.
 */
extension Dictionary {
    func filterMapValues<B>(_ transform: (Value) -> B?) -> [Key: B] {
        var result = [Key: B]()
        for (key, value) in self {
            if let b = transform(value) { result[key] = b }
        }
        return result
    }
}
/*:
 5. Define `partitionMapValues` on `Dictionary`.
 */
extension Dictionary {
    func partitionMapValues<A, B>(_ transform: (Value) -> Either<A, B>)
        -> (left: [Key: A], right: [Key: B]) {
            var result = (left: [Key: A](), right: [Key: B]())
            for (key, value) in self {
                switch transform(value) {
                case .left(let a):
                    result.left[key] = a
                case .right(let b):
                    result.right[key] = b
                }
            }
            return result
    }
}
/*:
 6. Rewrite `filterMap` and `filter` in terms of `partitionMap`.
 */
/*:
 7. Is it possible to define `partitionMap` on `Either`?
 */

