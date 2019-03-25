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

// if we want closures to take parameters we write it in the following way:
func letsTravelTo(action: (String) -> Void) {
    print("I will now go to:")
    action("San Francisco")
    print("Yeah, I'm there!")
}

letsTravelTo { (place: String) in
    print("The beautiful town of \(place)")
}

// just like handing in parameters we can also make closures return parameters of any type of data by replacing the -> Void with the desired data type

func makeTravelPlans(action: (String) -> String) {
    print("I have a new plan for my next vacation")
    let destination = action("Hawaii")
    print(destination)
    print("Let's check the flights")
}

makeTravelPlans { (location: String) -> String in
    return "Next trip will be to \(location)"
}

// we can use shorthand parameter names in closures since Swift knows the type of arguments that are given to a closure and we can access them in order with a $ sign before, so e.g. $0. Also as Swift knows we are returning a String (in this case) we can omit the return keyword in case we only have one line in our closure
makeTravelPlans {
    "Next trip will be to \($0)"
}

// for multiple parameters in a single closure we can simply put them together using commas
func travelWithSpeed(action: (String, Int) -> String) {
    print("Let's go")
    let description = action("Maui", 80)
    print(description)
    print("We're there!")
}

travelWithSpeed {
    "We're going to \($0) with the insane speed of \($1) km/h"
}

// we can also return closures from functions which looks a little goofy because we use two ->'s:
func goTo() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}

let goingTo = goTo()
goingTo("Spain")

// we can capture values inside the closure. This means we can use values from a function that contains the closure and access them inside of the closure. This sounds complicated but the following example will make it more clear:
func travelWithCount() -> (String) -> Int {
    var counter = 0
    return {
        print("I'm going to \($0)")
        counter += 1
        return counter
    }
}

let result = travelWithCount()
print(result("London"))     // 1
print(result("Berlin"))     // 2
print(result("Paris"))      // 3

