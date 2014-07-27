A Swift Summary
===============

[*The Swift Programming Language*](https://itun.es/us/jEUH0.l) is a great book
filled with incredibly well-written descriptions and clever examples, and I
very highly recommend it.  It's divided into three sections: "A Swift Tour," a
language guide, and the formal grammar. This document falls in-between the tour
and guide—it's a brief description of all the interesting, surprising, and
unexpected aspects of the language that I came across while reading the book.

This isn't a summary of the entire language; the obvious, simple, and expected
aspects of it are not mentioned here.

This summary is divided up into the same sections as the language guide, and
follows its order exactly. Keywords are denoted in **bold**, and each section
falls under one of three categories:

* :exclamation: Important to remember
* :grey_question: Required further insight
* :bulb: Random thoughts/comments

### Table of Contents
[A Swift Tour](#a-swift-tour)  
[The Basics](#the-basics)  
[Basic Operators](#basic-operators)  

<br />

A Swift Tour
------------

### :grey_question: Global Scope

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

### :grey_question: Explicit Enum Values

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

### :grey_question: anyCommonElements Experiment

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

### :bulb: Keywords as Names

> […] you should avoid using keywords as names unless you have absolutely no
> choice.

When will this ever happen? Should the backticks feature even exist? I guess
\`class\` is a little better than clazz at least.

### :exclamation: Idiomatic `Int`/`UInt` Usage

> Use `UInt` only when you specifically need an unsigned integer type with the
> same size as the platform's native word swize. If this is not the case, `Int`
> is preferred, evn when the values to be stored are known to be non-negative.

### :exclamation: Type Inference of Literals

> The rules for combining numeric constants and variables are different from the
> rules for numeric literals. The literal value `3` can be added directly to the
> literal value `0.14159`, because number literals do not have an explicit type
> in and of themselves. Their type is inferred only at the point that they are
> evaluated by the compiler.

### :grey_question: Common Initialism Conventions

``` swift
let http404Error = (404, "Not Found")
```

Does convention dictate that this variable should instead be named
`HTTP404Error`?
[Here](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/index.html#//apple_ref/occ/instp/NSURLRequest/URL)'s
an example in the frameworks…

### :bulb: Optional Binding

Both `if let` and `if var` can be used for optional binding, but the former
seems to be much more prevalent.

<br />

Basic Operators
---------------
