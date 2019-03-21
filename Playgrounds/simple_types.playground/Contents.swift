// Variables can be assigned with var and hold an initial value that can later be changed
var str = "Hello, playground"
str = "Goodbye, Playground"

// As Swift is a type-safe language variables can only have on type
var age = 28            // inferred to be an int
var name = "Stefan"     // inferred to be a String
var money = 300_000     // underscores can be used as separators and don't change the number

// it is not possible to assign a String to an integer variable, e.g. age = "Stefan"

// Multi-line strings use triple quotes
var poem = """
To be or not to be
That is thy question
"""

// with backslashes at the end of each line a line-break is prevented (only formatting is done)
var other_poem = """
Roses are red, \
Code is blue, \
This is not a poem
"""

// other types are doubles and booleans
var pi = 3.141
var you_are_awesome = true

// You can use other variables in strings with string interpolation:
var sentence = "My age is \(age)"

// Constants are declared with let and con't take on other values in the future
let answer_to_everything = 42

// while type is inferred it is also possible to use type annotations
let album: String = "Smells like teen spirit"
let year: Int = 2019
let height: Double = 1.84
let great_day: Bool = true
