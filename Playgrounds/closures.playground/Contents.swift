// functions can be assigned to variables and also used in the same way but with a special syntax
// a simple example is to define a function with no name and assign it a value
let driving = {
    print("I'm driving")
}

// we can call this function as any regular function simply with:
driving()

// if we want a closure to take parameters we have to define them inside the curly braces. They are defined in parenthesis and followed by the keyword "in", followed by the function body. When calling them something different from functions is that parameters are not called with their name. Also parameter labels may not be used
let drivingTo = { (destination: String) in
    print("I'm driving to \(destination)")
}
drivingTo("Spain")

// when we want to return values we have to define that before the "in" keyword as in normal functions with "->"
let drivingToReturn = { (destination: String) -> String in
    return "I'm driving to \(destination)"
}

let dest = drivingToReturn("Spain")
print(dest)

// since closures are types like Strings and Ints we can pass them into functions with the following style: () -> 0
// so e.g.
func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived")
}

travel(action: driving)

// one special case is if the last parameter of a function is a closure. Then it is possible to call it in the following way:
func say(word: () -> Void) {
    print("I'm going to say the word \(word) now")
    word()
    print("That wasn't hard")
}

say {
    print("Hello")
}

// NOTE: if there are no other parameters as in the case above we do not even need parenthesis () after say, but only in the case of no other parameters
