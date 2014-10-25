A Swift Summary
===============

[*The Swift Programming Language*](https://itun.es/us/jEUH0.l) is a great book
filled with incredibly well-written descriptions and clever examples, and I
very highly recommend it.  It's divided into three sections: "A Swift Tour," a
language guide, and the formal grammar. This document falls in-between the tour
and guide—it's a brief description of all the interesting, surprising, and
unexpected aspects of the language that I came across while reading the book.

It isn't a recap of the entire book; the obvious, simple, and expected aspects
of it are not mentioned here.

### Format

This summary is divided up into the same sections as the language guide, and
follows its order exactly. Each subsection falls under one of three categories:

* :grey_exclamation: Important to remember
* :question: Required further insight
* :bulb: Random thought/comment

<br />

### Table of Contents

For those without hyperlinks, I had nothing to add.

[A Swift Tour](#a-swift-tour)  
[The Basics](#the-basics)  
[Basic Operators](#basic-operators)  
Strings and Characters  
[Collection Types](#collection-types)  
[Control Flow](#control-flow)  
[Functions](#functions)  
Closures  
[Enumerations](#enumerations)  
[Classes and Structure](#classes-and-structures)  
[Properties](#properties)  
[Methods](#methods)  
[Subscripts](#subscripts)  
[Inheritance](#inheritance)  
[Initialization](#initialization)  
[Deinitialization](#deinitialization)  
[Automatic Reference Counting](#automatic-reference-counting)  
[Optional Chaining](#optional-chaining)  
[Type Casting](#type-casting)  
Nested Types  
[Extensions](#extensions)  
[Protocols](#protocols)  
[Generics](#generics)  
[Access Control](#access-control)  
[Advanced Operators](#advanced-operators)  

*Disclaimer: all direct quotations from* The Swift Programming Language *are
presented here in*

> blockquotes

*and are used strictly for non-commercial,
educational purposes under Fair Use
([17 U.S.C. § 107](http://www.law.cornell.edu/uscode/text/17/107)). I am
neither affiliated with nor endorsed by Apple.*

<br />

A Swift Tour
------------

#### :question: Global Scope

> Code written at global scope is used as the entry point for the
program.

That's awesome! But what happens if you have two source files in a project and
attempt to build & run it in Xcode?

It turns out that if you have
more than one source file, one must be named `main.swift` and will be used as
the entry point. Any other file with top-level code will raise `error:
expressions are not allowed at the top level`.

In fact, you can remove the `@UIApplicationMain` attribute from an iOS app
and create a `main.swift` file with nothing but:

``` swift
UIApplicationMain(C_ARGC, C_ARGV, NSStringFromClass(UIApplication), NSStringFromClass(AppDelegate))
```
and your app will still run!

#### :question: Explicit Enum Values

``` swift
enum Rank: Int {
    case Ace = 1
    case Two, Three, four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    […]
```

If you were to provide explicit raw values of `1` for the first case and `3`
for the second case, what would the third be?

``` swift
enum Test: Int {
    case A = 1
    case B = 3
    case C // equals 4
}
```
Implicit raw values are always incremented by 1 from that of the value before
it. An error will occur if a value is auto-incremented into one already used.

#### :question: anyCommonElements Experiment

> Modify the `anyCommonElements` function to make a function that returns an
> array of the elements that any two sequences have in common.

This wasn't an immediately obvious solution:

``` swift
func anyCommonElements<
    T, U where T: Sequence, U: Sequence,
    T.GeneratorType.Element: Equatable,
    T.GeneratorType.Element == U.GeneratorType.Element>
    (lhs: T, rhs: U) -> [T.GeneratorType.Element] {
        var commonElements: [T.GeneratorType.Element] = [] // [T.GeneratorType.Element]() doesn't seem to work
            for lhsItem in lhs {
                for rhsItem in rhs {
                    if lhsItem == rhsItem {
                        commonElements.append(lhsItem)
                    }
                }
            }
        return commonElements
}
```

<br />

The Basics
----------

#### :bulb: Keywords as Names

> […] you should avoid using keywords as names unless you have absolutely no
> choice.

When will this ever happen? Should the backticks feature even exist? I guess
\`class\` is a little better than clazz at least.

#### :grey_exclamation: Idiomatic `Int`/`UInt` Usage

> Use `UInt` only when you specifically need an unsigned integer type with the
> same size as the platform's native word swize. If this is not the case, `Int`
> is preferred, even when the values to be stored are known to be non-negative.

#### :grey_exclamation: Type Inference of Literals

> The rules for combining numeric constants and variables are different from the
> rules for numeric literals. The literal value `3` can be added directly to the
> literal value `0.14159`, because number literals do not have an explicit type
> in and of themselves. Their type is inferred only at the point that they are
> evaluated by the compiler.

#### :question: Common Initialism Conventions

``` swift
let http404Error = (404, "Not Found")
```

Does convention dictate that this variable should instead be named
`HTTP404Error`?
[Here](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/index.html#//apple_ref/occ/instp/NSURLRequest/URL)'s
an example in the frameworks.

#### :bulb: Optional Binding

Both `if let` and `if var` can be used for optional binding, but the former
seems to be much more prevalent.

<br />

Basic Operators
---------------

#### :question: Remainder Operator Type Inference

``` swift
8 % 2.5   // equals 0.5
```

> In this example, `8` divided by `2.5` equals `3`, with a remainder of `0.5`,
> so the remainder operator returns a `Double` value of `0.5`.

Would the remainder of two `Float`s also return a `Double`?

Nope:

``` swift
let x: Float = 1.5
let y: Float = 1
let z = x % y   // of type Float
```

If you try `Float(1.5) % 1` you'll also get a `Float` because Swift will infer
the `1` literal to be a `Float` in this context. Pretty neat! But if you try
this:

``` swift
let x: Float = 1.5
let y: Double = 1
let z = x % y
```

You'll be reminded that Swift doesn't implictly convert types for you.

#### :question: Rigorous Closed Range Operator Definition

> The *closed range operator* `(a...b)` defines a range that runs from `a` to
> `b`, and includes the values `a` and `b`.

What happens if `a` and `b` have the same value? It turns out that the loop will
execute once, not twice. So `for i in 1...1` would be a redundantly silly way to
say "do this once."

<br />

Collection Types
----------------

#### :question: Array Type Inference

> Thanks to type inference, you don't need to specify the type to be stored in
> the array when using [the repeated value] initializer, because it can be
> inferred from the default value:
>
> ``` swift
> var anotherThreeDoubles = [Double](count: 3, repeatedValue: 2.5)
> ```

After thinking about it for a while, I believe this to be a mistake. Using a
repeated value of `1` will still yield a `[Double]` since it's explicitly stated
in the initializer. They probably intended to use `Array(count: 3,
repeatedValue: 2.5)`, at which point the above quotation is true. I submitted
this as an issue on their bug reporter.

<br />

Control Flow
------------

#### :bulb: Break in a Loop Statement

> When used inside a loop statement, `break` ends the loop's execution
> immediately.

The following loop has an interesting (although possibly obvious) property:

``` swift
var i: Int
for i = 0; i < 10; ++i {
    // if i == 9 { break }
}
println(i)
```

It executes 10 times either way, but if you uncomment the `break`, it will print
`9` instead of `10`.

<br />

Functions
---------

#### :grey_exclamation: Automatic External Parameter Names

> You can opt out of this behavior by writing an underscore (_) instead of an
> explicit external name when you define the parameter.

#### :bulb: Variadic Parameter Types

Variadic parameters simply appear within a function's body as a typed `Array`—no
`va_list` or `va_args`.

<br />

Enumerations
------------

#### :bulb: Associated Values

The ability to associate values with members of an enumeration is a language
feature I've never even heard of before, so this section is definitely worth
reading twice.

<br />

Classes and Structures
----------------------

#### :grey_exclamation: Memberwise Initializers

> All structures have an automatically-generated *memberwise initializer*, which
> you can use to initialize the member properties of new structure instances.

#### :bulb: Identity Operators and Strings

The *identical to* operator (`===`) checks if two variables or constants refer
to the same class instances.

A `String` is passed around by reference behind the
scenes, and two values may even lazily refer to the same reference. How might
`===` behave for two value types with the same value but different underlying
references?

It turns out that there's no way to play around with this, because `===` only
works for types conforming to the `AnyObject` protocol, and `non-class type
'String' cannot conform to class protocol 'AnyObject'`. Interesting to think
about though.

<br />

Properties
----------

#### :bulb: Property Observers

> If you assign a value to a property within its own `didSet` observer, the new
> value that you assign will replace the one that was just set.

Good thing this doesn't cause an infinite `didSet` loop!

#### :bulb: Lazy Evaluation

> Global constants and variables are always computed lazily.

Imagine the effect on startup time if you had a lot of global constants or
variables. It would be instinctive to prefix them all with `lazy`, but
luckily this is already the default and you don't even have to think about it.

<br />

Methods
-------

#### :grey_exclamation: Methods on `struct` and `enum`

> The fact that structures and enumerations can define methods in Swift is a
> major difference from C and Objective-C.

#### :grey_exclamation: Implicit `self` Compliance

> Within the body of a type method, the implicit `self` property refers to the
> type itself, rather than an instance of that type.

<br />

Subscripts
----------

#### :bulb: Subscript Overloading

Similar to method or operator overloading, *subscript overloading* is the term
for defining more than one subscript on a type.

<br />

Inheritance
-----------

#### :bulb: Classes vs. Other Types

The main difference between classes and other types in Swift is that they have
reference, rather than value, semantics. The other major difference is that
they allow inheritance.

#### :grey_exclamation: How to Call `super` on Subscripts

> An overridden subscript for `someIndex` can access the superclass version of
> the same subscript as `super[someIndex]` from within the overriding subscript
> implementation.

#### :grey_exclamation: Overriding Property Access

> You can present an inherited read-only property as a read-write property by
> providing both a getter and a setter in your subclass property override. You
> cannot, however, present an inherited read-write property as a read-only
> property.

<br />

Initialization
--------------

#### :bulb: Initial Values

> Classes and structures *must* set all of their stored properties to an
> appropriate initial value by the time an instance of that class or structure
> is created.

This requirement is mostly likely just an implementation detail and may be
removed at some point in the future.

#### :grey_exclamation: Calling Other Initializers

> The process of an initializer calling another is referred to as *initializer
> delegation*.

#### :grey_exclamation: Initializers on Value Types

> If you define a custom initializer for a value type, you will no longer have
> access to the default initializer (or the memberwise initializer, if it is a
> structure) for that type.

#### :grey_exclamation: Failable Initializer Syntax

> Although you write `return nil` to trigger an initialization failure, you do
> not use the `return` keyword to indicate initialization success.

#### :bulb: `init!`

Using `init?` to indicate that initialization can fail is an effective way to
handle errors. It returns a `Type?`, implying that either a value or "nothing"
was initialized. But when would `init!` be useful?  Implictly-unwrapped
optionals indicate that you can be confident that the value you're currently
working with is not `nil` without having to check it, but that it may have been
`nil` at some point in its lifetime. Since you're working with a value from the
very beginning of its lifetime when you obtain it from an initializer, there
aren't many use cases for `init!`.

It likely exists to help out with the Objective-C framework transitions to avoid
having to manually check every single converted initializer, since "this thing
might be nil but probably isn't" is how Objective-C works by default.

One other use case is overriding a failable initializer with one that you know
will never fail, but other than that `init!` should probably be avoided when
possible.

<br />

Deinitialization
----------------

#### :grey_exclamation: `super.deinit()`?

> […] the superclass deinitializer is called automatically at the end of a
> subclass deinitializer implementation.

<br />

Automatic Reference Counting
----------------------------

#### :question: Strong Reference Cycles

> Here's an example of how a strong reference cycle can be created by accident.

This is a very important concept in ARC, and one that's easy to completely gloss
over or forget about entirely.
[StrongReferenceCycles.playground](StrongReferenceCycles.playground) contains
the sample code modified to work in a Playground, because the best way of
learning is to see for yourself firsthand and tinker.

#### :grey_exclamation: Capture Lists

`[unowned self]` can be read as…
> "capture self as an unowned reference rather than a strong reference".

<br />

Optional Chaining
-----------------

#### :grey_exclamation: Chaining on Non-Optionals

> […] the result of an optional chaining call is always an optional value,
> even if the property, method, or subscript you are querying returns a
> non-optional value.

#### :question: Prefix Increment Operator on Optionals

An example of using the postfix increment operator on a chained optional is
given:

``` swift
testScores["Bev"]?[0]++
```

But where should `++` go for prefix incrementing? Is it even possible?

<br />

Type Casting
------------

#### :bulb: Type Inference

> Swift's type checker is able to deduce that `Movie` and `Song` have a common
> superclass of `MediaItem`, and so it infers a type of `[MediaItem]` for the
> `library` array:

Sick!!!

#### :grey_exclamation: Type Checking

`is` is referred to as the *type check operator*. Likewise, `as` is the *type
cast operator*.

#### :bulb: Downcasting Arrays

This is a very common and helpful pattern when working with an `Array` whose
type is known to be different than that of the instance (e.g., an `NSArray`):

> ``` swift
> for movie in someObjects as [Movie] {
>     println("Movie: '\(movie.name)', dir. \(movie.director)")
> }
> ```

<br />

Extensions
----------

#### :grey_exclamation: Retroactive Modeling

*Retroactive modeling* is the term for
> extending types for which you do not have access to the original source code.

#### :question: Convenience Initializers for Value Types

An example is given extending a `Rect` structure with
`init(center: Point, size: Size)`. This is clearly for convenience purposes
since all it does is compute the value of the expected `origin` argument and
delegate to that initializer instead. However, no `convenience` keyword is
present. This is because the concept of *convenience initializers* only truly
applies to classes, and value types must rely on extensions to achieve the same
effect.

<br />

Protocols
---------

#### :grey_exclamation: Protocols Shared by Reference and Value Types

> Always prefix type property requirements with the `class` keyword when you
> define them in a protocol. This rule pertains even though type property
> requirements are prefixed with the `static` keyword when implemented by a
> structure or enumeration.

<br />

Generics
--------

#### :grey_exclamation: Placeholder Types

For a placeholder type `T` in a function parameter,

> The placeholder type represented by the type parameter is replaced with an
> *actual* type whenever the function is called.

#### :grey_exclamation: Naming Type Parameters

> It is traditional to use the single-character name `T` for the type parameter.
> However, you can use any valid identifier as the type parameter name.

#### :bulb: On Optionals

> The `topItem` property returns an optional value of type `T`. If the stack is
> empty, `topItem` returns `nil`; if the stack is not empty, `topItem` returns
> the final item in the `items` array.

Optionals are great!

#### :bulb: Type Constraints

The section on type constraints details a unique language feature and is
definitely worth reading a second time.

#### :bulb: `typealias`

Associated types are a concept not often found in other languages, so the
section on it is worth reading carefully.

#### :grey_exclamation: Where Clauses

> A where clause enables you to require that an associated type conforms to a
> certain protocol, and/or that certain type parameters and associated types
> be the same.

<br />

Access Control
--------------

#### :bulb: Guiding Principle

This must be important, because it's the only fully-italicized sentence in the
entire book:

> Access levels in Swift follow an overall guiding principle: *No entity can be
> defined in terms of another entity that has a lower (more restrictive) access
> level.*

#### :bulb: `private`

"To hide implementation details" is the best description of the concept of
*private* I've ever read. It's concise yet leaves no room for ambiguity.

#### :grey_exclamation: Access Level Propagation

> The access control level of a type also affects the default access level of
> that type's members.

#### :grey_exclamation: Inheritance Access

> An override can make an inherited class member more accessible than its
> superclass version.

#### :bulb: File-Scoped Private

> ``` swift
> public class A {
>     private func someMethod() {}
> }
>
> internal class B: A {
>     override internal func someMethod() {
>         super.someMethod()
>     }
> }
> ```
>
> Because superclass `A` and subclass `B` are defined in the same source file,
> it is valid for the `B` implementation of `someMethod` to call
> `super.someMethod()`.

Although obvious based on the definition of `private`, this is radically
different from other programming languages.

<br />

Advanced Operators
------------------

#### :bulb: Overflow Operators Begin With `&`

So ampersands have two uses—overflow operators and inout parameters.

#### :question: Overflow Operators

Are overflow operators (`&+`, `&-`, `&*`, `&/`, `&%`) unique to Swift? They're
a clever idea—overflow is a silent killer!

#### :question: Divide by Zero

Division or remainder by zero causes an error, but equals zero if the overflow
operators are used instead. Why?

#### :grey_exclamation: `+=`, etc.

Operators combining assignment with another operation are called *compound
assignment operators*.
