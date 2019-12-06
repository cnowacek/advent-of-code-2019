import Foundation

func isValid(password: String) -> Bool {

    guard password.count == 6 else { return false }
    guard containsStrictAdjacentPair(string: password) else { return false }
    guard digitsDontDecrease(number: Int(password)!) else { return false }
    return true
}

func digitsDontDecrease(number: Int) -> Bool {
    let firstDigit  = (number - (Int(number/10) * 10)) / 1
    let secondDigit = (number - (Int(number/100) * 100)) / 10
    let thirdDigit  = (number - (Int(number/1000) * 1000)) / 100
    let fourthDigit = (number - (Int(number/10000) * 10000)) / 1000
    let fifthDigit  = (number - (Int(number/100000) * 100000)) / 10000
    let sixthDigit  = (number - (Int(number/1000000) * 1000000)) / 100000
    return sixthDigit <= fifthDigit &&
        fifthDigit <= fourthDigit &&
        fourthDigit <= thirdDigit &&
        thirdDigit <= secondDigit &&
        secondDigit <= firstDigit
}

func containsAdjacentPair(string: String) -> Bool {
    var lettersSeen: [Character:Bool] = [:]
    for character in string {
        if let _ = lettersSeen[character] {
            return true
        }
        lettersSeen[character] = true
    }
    return false
}

func containsStrictAdjacentPair(string: String) -> Bool {
    var lettersSeen: [Character:Int] = [:]
    for character in string {
        if let letterCount = lettersSeen[character] {
            lettersSeen[character] = letterCount + 1
        } else {
            lettersSeen[character] = 1
        }
    }

    for letterCount in lettersSeen.values {
        if letterCount == 2 { return true }
    }
    return false
}

public func day4() {

    let minimumRange = 158126
    let maximumRange = 624574

    var count = 0
    for number in minimumRange..<maximumRange {
        if isValid(password: "\(number)") {
            count += 1
        }
    }

    print(count)
}
