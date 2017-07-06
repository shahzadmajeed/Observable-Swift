//: Playground - noun: a place where people can play

import Observable

class Person {
    var cgpa: Observable<Double>
    var first: Observable<String>
    var last: Observable<String>
    var college: String
    init(first: String, last: String, cgpa: Double, college: String) {
        self.cgpa = Observable(cgpa)
        self.college = college
        self.first = Observable(first)
        self.last = Observable(last)
    }
}

var p = Person(first: "Shahzad", last: "Majeed", cgpa: 3.1, college: "FAST")

p.first.afterChange += printNewValue
p.last.afterChange += printNewValue
p.cgpa.afterChange += { oldValue, newValue in
    print("\(oldValue) updated to \(newValue)")
    // Update UI here
}

p.first.value = "Abbass"
p.last.value = "Majeed"
p.cgpa.value = 4.0

func printNewValue(oldValue: Any, newValue: Any) {
    print("\(oldValue) updated to \(newValue)")
}