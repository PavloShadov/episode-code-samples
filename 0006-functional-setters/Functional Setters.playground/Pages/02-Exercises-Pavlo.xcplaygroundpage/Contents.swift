/*:
 # Functional Setters Exercises

 1. As we saw with free `map` on `Array`, define free `map` on `Optional` and use it to compose setters that traverse into an optional field.
 */
public func map<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
  return { $0.map(f) }
}

// free map on array
let sut = [(42, nil), (1729, "Swift")]
sut |> map { print($0) }

// free map on optional
let optInteger: Int? = nil
optInteger
  |> map(String.init)

// free map on array with optionals
sut
  |> (map <<< second <<< map) { $0 + " Rocks"}
print()
/*:
 2. Take the following `User` struct and write a setter for its `name` property. Add another property, and add a setter for it. What are some potential issues with building these setters?
 */
struct Location {
  let name: String
}

struct User {
  let name: String
  let lastname: String
  let location: Location
}

func setName(_ f: @escaping (String) -> String) -> (User) -> User {
  return { User(name: f($0.name), lastname: $0.lastname, location: $0.location) }
}

func setLastname(_ f: @escaping (String) -> String) -> (User) -> User {
  return { User(name: $0.name, lastname: f($0.lastname), location: $0.location) }
}

let user = User(name: "Lera", lastname: "Shadova", location: Location(name: "Berlin"))
let newUser = user
  |> setName { _ in "Pavlo"}
  |> setName { $0.uppercased() }
  |> setLastname { _ in "Shadov" }

print(newUser)
print()
/*:
 3. Add a `location` property to `User`, which holds a `Location`, defined below. Write a setter for `userLocationName`. Now write setters for `userLocation` and `locationName`. How do these setters compose?
 */
func setLocationName(_ f: @escaping (String) -> String) -> (Location) -> Location {
  return { Location(name: f($0.name)) }
}

func setUserLocation(_ f: @escaping (Location) -> Location) -> (User) -> User {
  return { User(name: $0.name, lastname: $0.lastname, location: f($0.location)) }
}

func setUserLocationName(_ f: @escaping (String) -> String) -> (User) -> User {
  return { user in
    user
      |> (setUserLocation <<< setLocationName)(f)
  }
}

let tester = User(name: "Tester", lastname: "One", location: Location(name: "New York"))
let newTester = tester |> setUserLocationName { _ in "London" }
print(newTester)
print()
/*:
 4. Do `first` and `second` work with tuples of three or more values? Can we write `first`, `second`, `third`, and `nth` for tuples of _n_ values?
 */
let testTuple = (1, "Hello", 44)
  
// first and second - don't work with tuple of 3+ values
//testTuple
//  |> first(incr)

func third<A, B, C, D>(_ f: @escaping (C) -> D) -> ((A, B, C)) -> (A, B, D) {
  return { tuple in
    return (tuple.0, tuple.1, f(tuple.2))
  }
}

testTuple
  |> third(incr)
print()

// Swift doesn't support variadic generics
/*:
 5. Write a setter for a dictionary that traverses into a key to set a value.
 */
func setValue<Key: Hashable, Value>(_ value: Value, for key: Key)
  -> (Dictionary<Key, Value>) -> Dictionary<Key, Value> {
    return { oldDictionary in
        var newDictionary = oldDictionary
        newDictionary[key] = value
        return newDictionary
    }
}

let testDict = ["first": 1, "second": 2]
dump(
testDict
  |> setValue(3, for: "first")
  |> setValue(150, for: "second")
  |> setValue(0, for: "third")
)
print()
/*:
 6. Write a setter for a dictionary that traverses into a key to set a value if and only if that value already exists.
 */
func setValue<Key: Hashable, Value>(for key: Key)
  -> (@escaping (Value) -> Value)
  -> (Dictionary<Key, Value>) -> Dictionary<Key, Value> {
  return { valueUpdate in
    { oldDictionary in
      guard let oldValue = oldDictionary[key] else { return oldDictionary }
      var newDictionary = oldDictionary
      newDictionary[key] = valueUpdate(oldValue)
      return newDictionary
    }
  }
}

let testDict2 = ["first": 1, "second": 2]
dump(
testDict2
  |> (setValue(for: "first")) { $0 + 1 }
  |> (setValue(for: "second")) { _ in 0 }
  |> (setValue(for: "third")) { _ in 999 }
)
print()
/*:
 7. What is the difference between a function of the form `((A) -> B) -> (C) -> (D)` and one of the form `(A) -> (B) -> (C) -> D`?
 */
//func firstForm<A, B, C, D>() -> ((A) -> B) -> (C) -> (D) {
//  return { aToB in
//    return { c in
//      return d
//    }
//  }
//}

//func secondForm<A, B, C, D>() -> (A) -> (B) -> (C) -> (D) {
//  return { a in
//    return { b in
//      return { c in
//        return d
//      }
//    }
//  }
//}
