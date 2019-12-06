import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int

    func distance() -> Int {
        return abs(self.x) + abs(self.y)
    }

    func up() -> Point {
        return Point(x: self.x, y: self.y+1)
    }
    func down() -> Point {
        return Point(x: self.x, y: self.y-1)
    }
    func left() -> Point {
        return Point(x: self.x-1, y: self.y)
    }
    func right() -> Point {
        return Point(x: self.x+1, y: self.y)
    }
}

func timing(ords: [String]) -> [Point:Int] {
    var timings: [Point:Int] = [:]
    var currentPosition = Point(x: 0, y: 0)
    var time = 0

    for ord in ords {
        let direction = ord.prefix(upTo: ord.index(ord.startIndex, offsetBy: 1))
        let countString = ord.suffix(from: ord.index(ord.startIndex, offsetBy: 1))
        let count = Int(countString)!

        switch direction {
        case "U":
            for _ in 0..<count {
                time += 1
                currentPosition = currentPosition.up()
                if timings[currentPosition] == nil {
                    timings[currentPosition] = time
                }
            }
        case "D":
            for _ in 0..<count {
                time += 1
                currentPosition = currentPosition.down()
                if timings[currentPosition] == nil {
                    timings[currentPosition] = time
                }
            }
        case "L":
            for _ in 0..<count {
                time += 1
                currentPosition = currentPosition.left()
                if timings[currentPosition] == nil {
                    timings[currentPosition] = time
                }
            }
        case "R":
            for _ in 0..<count {
                time += 1
                currentPosition = currentPosition.right()
                if timings[currentPosition] == nil {
                    timings[currentPosition] = time
                }
            }

        default: break
        }
    }

    return timings
}

func fillSpaces(ords: [String]) -> Set<Point> {
    var space: Set<Point> = Set<Point>()
    var currentPosition = Point(x: 0, y: 0)

    for ord in ords {
        let direction = ord.prefix(upTo: ord.index(ord.startIndex, offsetBy: 1))
        let countString = ord.suffix(from: ord.index(ord.startIndex, offsetBy: 1))
        let count = Int(countString)!

        switch direction {
        case "U":
            for _ in 0..<count {
                currentPosition = currentPosition.up()
                space.insert(currentPosition)
            }
        case "D":
            for _ in 0..<count {
                currentPosition = currentPosition.down()
                space.insert(currentPosition)
            }
        case "L":
            for _ in 0..<count {
                currentPosition = currentPosition.left()
                space.insert(currentPosition)
            }
        case "R":
            for _ in 0..<count {
                currentPosition = currentPosition.right()
                space.insert(currentPosition)
            }

        default: break
        }
    }

    return space
}

public func day3() {
    guard let fileUrl = Bundle.main.url(forResource: "input3", withExtension: nil) else { fatalError() }
    guard let text = try? String(contentsOf: fileUrl, encoding: String.Encoding.utf8) else { fatalError() }
    let lines = text.split(separator: "\n")
        .map({ return $0.split(separator: ",").map({ return String($0) }) })


    let wire1 = lines[0]
    let wire2 = lines[1]

    let wire1space: Set<Point> = fillSpaces(ords: wire1)
    let wire1timings = timing(ords: wire1)

    let wire2space: Set<Point> = fillSpaces(ords: wire2)
    let wire2timings = timing(ords: wire2)

    let intersection = wire1space.intersection(wire2space)
    
    print(wire1space.count)
    print(wire2space.count)
    print(intersection)

    let closestIntersection = intersection.reduce(intersection.first!) { (lowest, current) -> Point in
        let currentLowestTimeing = wire1timings[lowest]! + wire2timings[lowest]!
        let currentTiming = wire1timings[current]! + wire2timings[current]!
        if currentLowestTimeing > currentTiming {
            return current
        }
        return lowest
    }

    let lowestTiming = wire1timings[closestIntersection]! + wire2timings[closestIntersection]!
    print("Closest intersection: \(closestIntersection) with timing = \(lowestTiming)")
}
