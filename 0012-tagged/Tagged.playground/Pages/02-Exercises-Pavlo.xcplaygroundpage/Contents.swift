struct Tagged<Tag, RawValue> {
  let rawValue: RawValue
}

extension Tagged: Decodable where RawValue: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.init(rawValue: try container.decode(RawValue.self))
  }
}

extension Tagged: Equatable where RawValue: Equatable {
  static func == (lhs: Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}

extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
  typealias IntegerLiteralType = RawValue.IntegerLiteralType
  
  init(integerLiteral value: RawValue.IntegerLiteralType) {
    self.init(rawValue: RawValue(integerLiteral: value))
  }
}

enum EmailTag {}
typealias Email = Tagged<EmailTag, String>

struct Subscription: Decodable {
  typealias Id = Tagged<Subscription, Int>

  let id: Id
  let ownerId: User.Id
}

struct User: Decodable {
  typealias Id = Tagged<User, Int>
  enum AgeTag {}
  typealias Age = Tagged<AgeTag, Int>

  let id: Id
  let name: String
  let age: Age
  let email: Email
  let subscriptionId: Subscription.Id?
}
/*:
 # Tagged Exercises

 1. Conditionally conform Tagged to ExpressibleByStringLiteral in order to restore the ergonomics of initializing our User’s email property. Note that ExpressibleByStringLiteral requires a couple other prerequisite conformances.
 */
extension Tagged: ExpressibleByUnicodeScalarLiteral where RawValue: ExpressibleByUnicodeScalarLiteral {
  typealias UnicodeScalarLiteralType = RawValue.UnicodeScalarLiteralType

  init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
    self.init(rawValue: RawValue(unicodeScalarLiteral: value))
  }
}

extension Tagged: ExpressibleByExtendedGraphemeClusterLiteral where RawValue: ExpressibleByExtendedGraphemeClusterLiteral {
  typealias ExtendedGraphemeClusterLiteralType = RawValue.ExtendedGraphemeClusterLiteralType

  init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
    self.init(rawValue: RawValue(extendedGraphemeClusterLiteral: value))
  }
}

extension Tagged: ExpressibleByStringLiteral where RawValue: ExpressibleByStringLiteral {
  typealias StringLiteralType = RawValue.StringLiteralType

  init(stringLiteral value: StringLiteralType) {
    self.init(rawValue: RawValue(stringLiteral: value))
  }
}

let user = User(id: 1, name: "Pavlo", age: 28, email: "example@lol.com", subscriptionId: 123)
/*:
 2. Conditionally conform Tagged to Comparable and sort users by their id in descending order.
 */
extension Tagged: Comparable where RawValue: Comparable {
  static func < (lhs: Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

let users = [User(id: 1, name: "Test", age: 12, email: "qwerty", subscriptionId: 123),
            User(id: 3, name: "Test2", age: 24, email: "lol", subscriptionId: nil),
            User(id: 2, name: "Test3", age: 56, email: "meme", subscriptionId: 90)]

users.sorted { $0.id < $1.id }
/*:
 3. Let’s explore what happens when you have multiple fields in a struct that you want to strengthen at the type level. Add an age property to User that is tagged to wrap an Int value. Ensure that it doesn’t collide with User.Id. (Consider how we tagged Email.)
 */
// Before added AgeTag these were compilable
// let user2 = User(id: User.Age(rawValue: 1), name: "", age: User.Id(rawValue: 20), email: "", subscriptionId: nil)
// let user3 = User(id: User.Id(rawValue: 1), name: "", age: User.Id(rawValue: 20), email: "", subscriptionId: nil)
// let user4 = User(id: User.Age(rawValue: 1), name: "", age: User.Age(rawValue: 20), email: "", subscriptionId: nil)

let user5 = User(id: User.Id(rawValue: 1), name: "", age: User.Age(rawValue: 20), email: "", subscriptionId: nil)
/*:
 4. Conditionally conform Tagged to Numeric and alias a tagged type to Int representing Cents. Explore the ergonomics of using mathematical operators and literals to manipulate these values.
 */
extension Tagged: AdditiveArithmetic where RawValue: AdditiveArithmetic {
  static func += (lhs: inout Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) {
    lhs = Tagged(rawValue: lhs.rawValue + rhs.rawValue)
  }
  
  static func -= (lhs: inout Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) {
    lhs = Tagged(rawValue: lhs.rawValue - rhs.rawValue)
  }
  
  static func + (lhs: Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) -> Tagged<Tag, RawValue> {
    return Tagged(rawValue: lhs.rawValue + rhs.rawValue)
  }
  
  static func - (lhs: Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) -> Tagged<Tag, RawValue> {
    return Tagged(rawValue: lhs.rawValue - rhs.rawValue)
  }
  
  static var zero: Tagged<Tag, RawValue> {
    return self.init(rawValue: RawValue.zero)
  }
}

extension Tagged: Numeric where RawValue: Numeric {
  typealias Magnitude = RawValue.Magnitude
  
  init?<T>(exactly source: T) where T : BinaryInteger {
    guard let rawValue = RawValue(exactly: source) else { return nil }
    self.init(rawValue: rawValue)
  }
  
  var magnitude: Magnitude {
    rawValue.magnitude
  }
  
  static func * (lhs: Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) -> Tagged<Tag, RawValue> {
    return Tagged(rawValue: lhs.rawValue * rhs.rawValue)
  }
  
  static func *= (lhs: inout Tagged<Tag, RawValue>, rhs: Tagged<Tag, RawValue>) {
    lhs = Tagged(rawValue: lhs.rawValue * rhs.rawValue)
  }
}

enum CoinsTag {}

struct Money {
  let coins: Tagged<CoinsTag, Int>
}

let fifty = Money(coins: 50)
let quarter = Money(coins: 25)
let dollar = Money(coins: fifty.coins + quarter.coins + quarter.coins)
let twentyFiveBucks = Money(coins: fifty.coins * fifty.coins)
/*:
 5. Create a tagged type, Light<A> = Tagged<A, Color>, where A can represent whether the light is on or off. Write turnOn and turnOff functions to toggle this state.
 */

/*:
 6. Write a function, changeColor, that changes a Light’s color when the light is on. This function should produce a compiler error when passed a Light that is off.
 */
// TODO
/*:
 7. Create two tagged types with Double raw values to represent Celsius and Fahrenheit temperatures. Write functions celsiusToFahrenheit and fahrenheitToCelsius that convert between these units.
 */
enum CelsiusTag {}
typealias Celsius = Tagged<CelsiusTag, Double>

enum FahrenheitTag {}
typealias Fahrenheit = Tagged<FahrenheitTag, Double>

func celsiusToFahrenheit(_ celsius: Celsius) -> Fahrenheit {
  return Fahrenheit(rawValue: (celsius.rawValue * 9 / 5) + 32)
}

func fahrenheitToCelsius(_ fahrenheit: Fahrenheit) -> Celsius {
  return Celsius(rawValue: (fahrenheit.rawValue - 32) * 5 / 9)
}

let bodyTemp = Celsius(rawValue: 36.6)
dump(celsiusToFahrenheit(bodyTemp))

let bradberry = Fahrenheit(rawValue: 451)
dump(fahrenheitToCelsius(bradberry))
/*:
 8. Create Unvalidated and Validated tagged types so that you can create a function that takes an Unvalidated<User> and returns an Optional<Validated<User>> given a valid user. A valid user may be one with a non-empty name and an email that contains an @.
 */
// TODO
