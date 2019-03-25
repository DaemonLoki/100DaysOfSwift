func sumNumbers(numbers: Int...) {
    var sum = 0
    for number in numbers {
        sum += number
    }
    print(sum)
}

sumNumbers(numbers: 10, 12, 13, 14)
