# Value Observing and Events for Swift

Swift lacks the powerful Key Value Observing (KVO) from Objective-C. But thanks to clousures, generics and property observers, in some cases it allows for far more elegent observing. You have to be explicit about what can be observed, though.

## Overview

### Observables

Using `Observable<T>` and related clases you can impelement wide range of patterns using value observing. Some of the features: 

- observable variables and properties
- short readable syntax using `+=`, `-=`, `<-`, `^`
- handlers for _before_ or _after_ the change
- handlers for `(oldValue, newValue)` or `(newValue)`
- adding multiple handlers per observable
- removing / invalidating handlers
- handlers tied to observer lifetime
- observable mutations of value types (structs, tuples, ...)
- conversions from observables to underlying type
- observables combining other observables
- observables as value types or reference types
- ...

### Events

Sometimes, you dont want to observe for value change, but other significant events.
Under the hood `Observable<T>` uses `beforeChange` and `afterChange` of `Event<(T, T)>`. You can, however, use `Event<T>` directly and implement other events too.

## Examples
`Observable<T>` is a simple `struct` allowing you to have observable variables.

```swift
// create a Observable<Int> variable
var x = Observable(0)

// add a handler
x.afterChange += { println("Changed x from \($0) to \($1)") }

// change the value, prints "Changed x from 0 to 42"
x <- 42
```

You can, of course, have observable properties in a `class` or a `struct`:

```swift
struct Person {
    let first: String
    var last: Observable<String>
    
    init(first: String, last: String) {
        self.first = first
        self.last = Observable(last)
    }
}
    
var ramsay = Person(first: "Ramsay", last: "Snow")
ramsay.last.afterChange += { println("Ramsay \($0) is now Ramsay \($1)") }        
ramsay.last <- "Bolton"
```

For value types (such as `structs` or `tuples`) you can also observe their mutations:


```swift
struct Person {
    let first: String
    var last: String
    var full: String { get { return "\(first) \(last)" } }
}

var ramsay = Observable(Person(first: "Ramsay", last: "Snow"))
// x += { ... } is the same as x.afterChange += { ... }
ramsay += { println("\($0.full) is now \($1.full)") }
ramsay.value.last = "Bolton"
```

You can remove observers by keeping the subscription object:

```swift
var x = Observable(0)    
let subscr = x.afterChange += { (_,_) in println("changed") }
// ...
x.afterChange -= subscr
```

Invalidating it:

```swift
var x = Observable(0)    
let subscr = x.afterChange += { (_,_) in println("changed") }
// ...
subscr.invalidate() // will be removed next time event fires
```

Or tie the subscription to object lifetime:

```swift
var x = Observable(0)        
for _ in 0..1 {
    let o = NSObject() // in real-world this would probably be self
    x.afterChange.add(owner: o) { (oV, nV) in println("\(oV) -> \(nV)") }
    x <- 42 // handler called
} // o deallocated, handler invalidated
x <- -1 // handler not called
```

`Event<T>` is a simple `struct` allowing you to define subscribable events. `Observable<T>` uses `Event<(T, T)>` for `afterChange` and `beforeChange`.

```swift
class SomeClass {
 	// defining an event someone might be interested in
 	var somethingChanged = Event<String>()
 
 	// ...
 
 	func doSomething() {
 		// ...
 		// fire the event and notify all observers
 		somethingChanged.notify("Hello!")
 		// ...
 	}
}

var obj = SomeClass()

// subscribe to an event
obj.somethingChanged += { println($0) }

obj.doSomething()
```

More examples can be found in tests in `ObservableTests.swift`