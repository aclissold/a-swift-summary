// https://developer.apple.com/library/ios/documentation/swift/conceptual/swift_programming_language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-XID_91

class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { println("\(name) is being deinitialized") }
}

class Apartment {
    let number: Int
    init(number: Int) { self.number = number }
    /* weak */ var tenant: Person?
    deinit { println("Apartment #\(number) is being deinitialized") }
}

// Playgrounds seem to hang on to references longer than a real environment,
// but wrapping them in an optional appears to compensate for this.
// See http://stackoverflow.com/q/24021340/2546659.
struct X {
    var john: Person? = Person(name: "John Appleseed")
    var number73: Apartment? = Apartment(number: 73)
}

var x: X? = X()

x!.john!.apartment = x!.number73
x!.number73!.tenant = x!.john

x!.john = nil
x!.number73 = nil
