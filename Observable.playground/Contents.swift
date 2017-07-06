//: Playground - noun: a place where people can play

import Observable

struct Person {
    var cgpa: Double
    var first: Observable<String>
    var last: Observable<String>
    
    init(first: String, last: String, cgpa: Double) {
        self.cgpa = cgpa
        self.first = Observable(first)
        self.last = Observable(last)
    }
}

var p = Person(first: "Shahzad", last: "Majeed", cgpa: 3.1)

p.first.afterChange += printNewValue

p.last.afterChange += printNewValue

p.first.value = "Abbass"
p.last.value = "Majeed"

func printNewValue(oldValue: Any, newValue: Any) {
    print("\(oldValue) updated to \(newValue)")
}