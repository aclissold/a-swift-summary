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
