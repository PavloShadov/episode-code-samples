func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {
    return { update in
      return { oldInstance in
        var copy = oldInstance
        copy[keyPath: kp] = update(copy[keyPath: kp])
        return copy
      }
    }
}

struct Person {
  var firstName: String
  var lastName: String
}

func map<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
  return { $0.map(f) }
}

struct Food {
  var name: String
}

struct Location {
  var name: String
}

struct User {
  var favoriteFoods: [Food]
  var location: Location
  var name: String
}
/*:
 # Setters and Key Paths Exercises

 1. In this episode we used `Dictionary`’s subscript key path without explaining it much. For a `key: Key`, one can construct a key path `\.[key]` for setting a value associated with `key`. What is the signature of the setter `prop(\.[key])`? Explain the difference between this setter and the setter `prop(\.[key]) <<< map`, where `map` is the optional map.
 */


let person = Person(firstName: "Pavlo", lastName: "Shadov")
let newIdentity = (prop(\Person.firstName)) { _ in "Pasha" }
                    <> (prop(\Person.lastName)) { $0.uppercased() }
person
  |> newIdentity

let dict = ["hello": 5, "world!": 6]

prop(\Dictionary<String,Int>.["hello"]) // ((Int?) -> Int) -> Dict -> Dict
prop(\Dictionary<String, Int>.["hello"]) <<< map // ((Int) -> Int) -> Dict -> Dict

let coolSetter = (prop(\Dictionary<String, Int>.["hello"]) <<< map)(incr)
dict
  |> coolSetter

/*:
 2. The `Set<A>` type in Swift does not have any key paths that we can use for adding and removing values. However, that shouldn't stop us from defining a functional setter! Define a function `elem` with signature `(A) -> ((Bool) -> Bool) -> (Set<A>) -> Set<A>`, which is a functional setter that allows one to add and remove a value `a: A` to a set by providing a transformation `(Bool) -> Bool`, where the input determines if the value is already in the set and the output determines if the value should be included.
 */
func elem<A>(_ a: A) -> (@escaping (Bool) -> Bool) -> (Set<A>) -> Set<A> {
  return { shouldInclude in
    return { set in
      let updatedSet: Set<A>
      if shouldInclude(set.contains(a)) {
        updatedSet = set.union([a])
      } else {
        updatedSet = set.subtracting([a])
      }
      return updatedSet
    }
  }
}
/*:
 3. Generalizing exercise #1 a bit, it turns out that all subscript methods on a type get a compiler generated key path. Use array’s subscript key path to uppercase the first favorite food for a user. What happens if the user’s favorite food array is empty?
 */
let user = User(favoriteFoods: [Food(name: "Borscht"), Food(name: "Pasta")],
                location: Location(name: "Berlin"),
                name: "Pavlo")
let userWithEmptyFood = User(favoriteFoods: [], location: Location(name: "Asgard"), name: "Boi")

let uppercaser = (prop(\User.favoriteFoods[0].name)) { $0.uppercased() }
dump(user |> uppercaser)
// dump(userWithEmptyFood |> uppercaser) --> CRASH
/*:
4. Recall from a previous episode that the free filter function on arrays has the signature ((A) -> Bool) -> ([A]) -> [A]. That’s kinda setter-like! What does the composed setter prop(\User.favoriteFoods) <<< filter represent?
 */
func filter<A>(_ f: @escaping (A) -> Bool) -> ([A]) -> [A] {
  return { $0.filter(f) }
}

user
  |> (prop(\User.favoriteFoods) <<< filter) { $0.name == "Borscht" }
/*:
 5. Define the `Result<Value, Error>` type, and create `value` and `error` setters for safely traversing into those cases.
 */
let result: Result<Int, Error> = .success(5)

func value<A, B, Error>(_ f: @escaping (A) -> B) -> (Result<A, Error>) -> Result<B, Error> {
  return { result in
    switch result {
    case .success(let v):
      return .success(f(v))
    case .failure(let e):
      return .failure(e)
    }
  }
}

func error<A, ErrorA, ErrorB>(_ f: @escaping (ErrorA) -> ErrorB) -> (Result<A, ErrorA>) -> Result<A, ErrorB> {
  return { result in
    switch result {
    case .success(let v):
      return .success(v)
    case .failure(let e):
      return .failure(f(e))
    }
  }
}

result
  |> value(incr)
/*:
 6. Is it possible to make key path setters work with `enum`s?
 */
// NEIN
/*:
 7. Redefine some of our setters in terms of `inout`. How does the type signature and composition change?
 */
func propInOut<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (inout Value) -> Void)
  -> (inout Root) -> Void {
    return { update in
      return { root in
          update(&root[keyPath: kp])
      }
    }
}
