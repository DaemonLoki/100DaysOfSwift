// Optionals can be used if we want to store values in properties but it might be the case that we only learn them later or maybe not for every instance.
// Instead of assigning a random (impossible) value we an use optionals. It might have a certain value or no value at all, which is "nil" in Swift
// We can simply make a type optional by putting a "?" behind it.
var age: Int? = nil

// We can then later assign a value to it
age = 34

// Because Optionals might or might not hold values we can't access them directly. We need to "unwrap" the optional before. This can be done e.g. via "if let" syntax:
var name: String? = nil

if let unwrapped = name {
    print("\(unwrapped.count) letters")
} else {
    print("Missing name")
}

// Another option for unwrapping is "guard let". It will unwrap the optional and only run the "else" statement if it finds nil. Otherwise it will let you continue your code with the provided unwrapped value still there. Therefore you can e.g. use a guard statement at the beginning of a function to check that all necessary optionals are provided and take the happy path after that.
func greet(_ name: String?) {
    guard let unwrapped = name else {
        print("You didn't provide a name!")
        return
    }
    
    print("Hello \(unwrapped)!")
}

// We can "force unwrap" optionals with the "!" operator. We should only do this if we are really sure that the optional contains a value because otherwise it can crash. In the example we turn the "num" let from an optional Int (Int?) to a regular Int
let str = "5"
let num = Int(str)!

// It is possible to create "implicitly unwrapped optionals". These are defined with an "!" instead of a "?". A valid usecase is, if you create a variable and it is nil but you know for sure that it will contain a value at the time we need to access it. However if this is not the case, the code will crash and therefore it is recommended to use regular optionals where possible.
//  They are mainly used to avoid the necessity of always unwrapping your optionals with "if let" or "guard let" statements.
let counter: Int! = nil

// "Nil coalescing" gives us the option to unwrap an optional and assign its value to a variable or otherwise provide a default value with the "??" operator. The handy thing is that the result won't be an optional.
func username(for id: Int) -> String? {
    if id == 1 {
        return "Taylor Swift"
    } else {
        return nil
    }
}

let user = username(for: 15) ?? "Anonymous"

// We can use a shortcut when using optionals called "optional chaining". If we are trying to use a chain of variable accesses and one of them is an optional we can use "?" to either unwrap it and continue in the chain or directly return nil. In the example if "first" is nil it will directly stop execution there and assign "nil" to "beatle". Otherwise it will continue with the unwrapped value of "first" and call "uppercased()" on it.
let names = ["John", "Paul", "George", "Ringo"]
let beatle = names.first?.uppercased()

// We can also use an "optional try" to check for values in throwing functions. We have the following situation:
enum PasswordError: Error {
    case obvious
}

func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    return true
}

do {
    try checkPassword("password")
    print("That password is good!")
} catch {
    print("You can't use that password!")
}

// Here we handle the throwing function with a "do, try, catch". We can also use "try?" to change the function to return an optional. In the error case nil is returned and otherwise the return value wrapped in an optional. We can then do this:
if let result = try? checkPassword("password") {
    print("Result was \(result)")
} else {
    print("D'oh")
}

// It is also possible to force the try with "try!" if we know for sure that the function won't fail. We need to be aware that our code crashes if it DOES throw an error so let's use it carefully.
try! checkPassword("secret")
print("Ok!")

// The initializer in line 30 ( Int(...) ) is an example of a "failable initializer". It will create an instance if certain conditions are met but return nil if this is not the case. We can e.g. create a failable initializer if a Person struct is not initialized with a 9-digit id like this:
struct Person {
    var id: String
    
    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}

// Swift always has to know the type of your variables. Sometimes we may know more. Let's look at this example:
class Animal { }
class Fish: Animal { }

class Dog: Animal {
    func makeNoise() {
        print("Woof, woof!")
    }
}

let pets = [Fish(), Dog(), Fish(), Dog()]

// As swift now know that all items inherit from type "Animal" it uses type inference to make pets an array of "Animal".
// However we can loop over the array and check if an item is of type "Dog" which is called "typecasting" and call the "makeNoise()" function in this case.
// This is done with the "as?" keyword which returns an optional that is "nil" if the typecast fails or the converted type otherwise.
for pet in pets {
    if let dog = pet as? Dog {
        dog.makeNoise()
    }
}
