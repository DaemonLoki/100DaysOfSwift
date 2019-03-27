// classes are similar to structs as they let you define properties and functions. There are 5 important differences thought that distinguish them from structs.

// 1. Classes never have a memberwise initializer, we have to always define an initializer if you have properties in a class.
class Dog {
    var name: String
    var breed: String
    
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
    
    func makeNoise() {
        print("Woof, woof!")
    }
}

let poppy = Dog(name: "Poppy", breed: "Poodle")

// 2. Classes can inherit from other classes. They thereby inherit all properties and methods of the original class and can even add its own on top. The "child" class can use "inheritence" / "subclassing" to inherit from the "parent" / "super" class.

//  This is done via adding the parent class with a colon after the child class name. It can then call the initializer from the super class from its own which may vary.

// with method overriding subclasses can use their own implementations of methods from the superclass. In the case of Poodle we can override the makeNoise() method to make the poodle make a different voice than other dogs.

// if we don't want someone to use our class as a parent class we can forbid inheritance using the "final" keyword.

final class Poodle: Dog {
    init(name: String) {
        super.init(name: name, breed: "Poodle")
    }
    
    override func makeNoise() {
        print("Wiff, wiff!")
    }
}

let labradoodle = Dog(name: "Tom", breed: "Labradoodle")
let poodlino = Poodle(name: "Poodlino")

labradoodle.makeNoise()
poodlino.makeNoise()

// 3. Classes differ from structs in the way they are copied. If we copy in instance of a class to another variable, they both point to the same spot in memory. That means if we change one instance, the other one changes as well. For structs this is not the case as everytime they are copied a different point in memory is assigned.
class Singer {
    var name = "Taylor Swift"
}

var singer = Singer()
print(singer.name)
var singerCopy = singer
singerCopy.name = "Justin Bieber"
print(singer.name)
// as they point to the same object in memory the name is also changed for the first instance

// 4. Classes have "deinitializers" which are called when an instance of a class is destroyed. This can e.g. happen if it is created inside of a for-loop and then destroyed when the for loop is exited
class Person {
    var name = "John Doe"
    
    init() {
        print("\(name) is alive")
    }
    
    func printGreeting() {
        print("Hello, I'm \(name)")
    }
    
    deinit {
        print("\(name) is no more.")
    }
}

for _ in 1...3 {
    let person = Person()
    person.printGreeting()
}

// 5. In constant (let) classes variable properties can be changed. In structs it is not possible to change variable properties when the struct is constant. If you want to avoid changeability the property of the class needs to be constant (a let).
class Dancer {
    var name = "Dancing Queen"
}

let queen = Dancer()
queen.name = "Dancing King"
print(queen.name)
// we would have to make name a let inside of the Dancer class to forbid it from being changed
