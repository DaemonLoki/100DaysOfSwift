struct Staff {
    var teachers: [String]
    private var students = [String]()
    
    init(names: String..., printNames: Bool) {
        self.teachers = names
        if printNames {
            print(self.teachers)
        }
    }
}

let staff = Staff(names: "Tom", "Jerry", "Mouse", printNames: true)
print(staff.teachers)
