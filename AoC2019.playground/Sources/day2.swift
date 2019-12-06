import Foundation

public func day2() {
    guard let fileUrl = Bundle.main.url(forResource: "input2", withExtension: nil) else { fatalError() }
    guard let text = try? String(contentsOf: fileUrl, encoding: String.Encoding.utf8) else { fatalError() }
    var intcode: [Int] = text.split(separator: ",")
        .filter({ if let integer = Int($0) { return true } else { return false } })
        .map({ return Int($0)! })

    for param1 in 0...99 {

        for param2 in 0...99 {
            let result = execute(program: intcode, param1: param1, param2: param2)
            if result == 19690720 {
                print("Found match... (\(param1), \(param2))")
                return
            } else {
                print("No match... (\(param1), \(param2))")
            }
        }
    }
}

func execute(program: [Int], param1: Int, param2: Int) -> Int {
    var mProgram = program
    mProgram[1] = param1
    mProgram[2] = param2
    return execute(program: mProgram)
}

func execute(program: [Int]) -> Int {
    var mProgram = program
    var shouldHalt = false
    for i in stride(from: 0, to: mProgram.endIndex, by: 4) {
        let instruction = mProgram[i]
        switch instruction {
        case 1:
            let first = mProgram[mProgram[i + 1]]
            let second = mProgram[mProgram[i + 2]]
            let destination = mProgram[i + 3]
            mProgram[destination] = first + second
        case 2:
            let first = mProgram[mProgram[i + 1]]
            let second = mProgram[mProgram[i + 2]]
            let destination = mProgram[i + 3]
            mProgram[destination] = first * second
        case 99:
            shouldHalt = true
        default:
            fatalError("Unrecognized Instruction")
        }

        if shouldHalt {
            break
        }
    }
    return mProgram[0]
}

