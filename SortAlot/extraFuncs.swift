func some(_ funct: (Int, Int) -> Bool, array: [Int], a: Int) -> Bool {
    for el in array {
        if (funct(el, a)) {
            return true
        }
    }
    return false
}

func equiv(_ a: Int, b: Int) -> Bool {
    return a == b
}
