// the most common loop is a for loop which can work in different ways
// one way is to use a range
let count = 1...10
for number in count {
    print(number)
}

// we can also loop through arrays
let puddingSorts = ["vanilla", "chocolate", "straciatella"]
for pudding in puddingSorts {
    print("I really like \(pudding) pupdding")
}

// if we do not need the object that is iterated over we use an underscore so that Swift is not assigning it a value
for _ in 1...5 {
    print("I shall not eat my homework!")
}

// another loop style is the while loop
var number = 1
while number <= 20 {
    print(number)
    number += 1
}

// the repeat loop is slightly different (more like a do-while-loop)
var counter = 1
repeat {
    print(counter)
    counter += 1
} while counter <= 20

// NOTE: the repeat loop is at least run once whereas the while-loop can also directly terminate

// we can also exit loops with a break statement
var seconds = 20
while seconds >= 0 {
    print(seconds)
    
    if seconds == 8 {
        print("Booooring, let's end this!")
        break
    }
    seconds -= 1
}

// we can also exit multiple loops at once by assigning names to the loops. all loops inside of the called loop will terminate as well
outerLoop: for i in 1...10 {
    for j in 1...10 {
        let product = i * j
        print("\(i) times \(j) is \(product)")
        
        if product == 50 {
            print("Jackpot!")
            break outerLoop
        }
    }
}

// we can skip items with the continue keyword, e.g. all even numbers
for i in 1...20 {
    if i % 2 == 0 {
        continue
    }
    print(i)
}

// we can create infinite loops with "while true" but need a condition inside to somehow be able to end this
var secondCounter = 0
while true {
    print(" ")
    secondCounter += 1
    
    if secondCounter == 273 {
        break
    }
}
