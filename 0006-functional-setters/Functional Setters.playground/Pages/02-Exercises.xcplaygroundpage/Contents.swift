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

func setName(_ name: String) -> (User) -> User {
  return { User(name: name, lastname: $0.lastname, location: $0.location) }
}

func setLastname(_ lastname: String) -> (User) -> User {
  return { User(name: $0.name, lastname: $0.lastname, location: user.location) }
}

let user = User(name: "Lera", lastname: "Shadova", location: Location(name: "Berlin"))
let newUser = user
  |> setName("Pavlo")
  |> setLastname("Shadov")

print(newUser)
/*:
 3. Add a `location` property to `User`, which holds a `Location`, defined below. Write a setter for `userLocationName`. Now write setters for `userLocation` and `locationName`. How do these setters compose?
 */
func setUserLocation(_ location: Location) -> (User) -> User {
  return { User(name: $0.name, lastname: $0.lastname, location: location) }
}

func setLocationName(_ locationName: () -> String) -> (Location) -> Location {
  return { _ in Location(name: locationName()) }
}

func setUserLocationName(_ locationName: String) -> (User) -> User {
//  without composition:
//
  return { user in
    let location = Location(name: locationName)
    return User(name: user.name, lastname: user.lastname, location: location)
  }
  
//  with composition
//
//  return { user in
//    user
//      |> (setUserLocation(_:) <<< setLocationName){ locationName }
//  }
}
/*:
 4. Do `first` and `second` work with tuples of three or more values? Can we write `first`, `second`, `third`, and `nth` for tuples of _n_ values?
 */
// TODO
/*:
 5. Write a setter for a dictionary that traverses into a key to set a value.
 */
// TODO
/*:
 6. Write a setter for a dictionary that traverses into a key to set a value if and only if that value already exists.
 */
// TODO
/*:
 7. What is the difference between a function of the form `((A) -> B) -> (C) -> (D)` and one of the form `(A) -> (B) -> (C) -> D`?
 */
// TODO
