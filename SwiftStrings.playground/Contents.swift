import UIKit


// ---------------------
// Strings are not array
// ---------------------
let name = "Taylor"

for letter in name {
    print("Give me a \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]


// -----------------------------
// Working with Strings in Swift
// -----------------------------

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

extension String {
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
        
    }
}

let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

print(weather.capitalizedFirst)

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages)

// better way:
languages.contains(where: input.contains)


// ------------------
// NSAttributedString
// ------------------

let string = "This is a test string"
let attributes: [NSAttributedString.Key : Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString1 = NSAttributedString(string: string, attributes: attributes)

let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

// ----------
// Challenges
// ----------

extension String {
    
    // Challenge 1
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        
        return prefix + self
    }
    
    // Challenge 2
    func isNumeric() -> Bool {
        return Double(self) != nil ? true : false
    }
    
    // Challenge 3
    func lines() -> [String] {
        return self.split(separator: "\n").map({ String($0) })
    }
    
}

// Testing challenge 1
"pet".withPrefix("car")
"testPrefix".withPrefix("test")

// Testing challenge 2
"Test".isNumeric()
"23".isNumeric()
"123.123".isNumeric()

// Testing challenge 3
"This\nis\na\ntest".lines()
"Should\nreturn\n4\nlines".lines().count
