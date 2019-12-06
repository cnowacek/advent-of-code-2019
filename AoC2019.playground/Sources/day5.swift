import UIKit

var intcode: [Int] = [3,225,1,225,6,6,1100,1,238,225,104,0,1101,40,71,224,1001,224,-111,224,4,224,1002,223,8,223,101,7,224,224,1,224,223,223,1102,66,6,225,1102,22,54,225,1,65,35,224,1001,224,-86,224,4,224,102,8,223,223,101,6,224,224,1,224,223,223,1102,20,80,225,101,92,148,224,101,-162,224,224,4,224,1002,223,8,223,101,5,224,224,1,224,223,223,1102,63,60,225,1101,32,48,225,2,173,95,224,1001,224,-448,224,4,224,102,8,223,223,1001,224,4,224,1,224,223,223,1001,91,16,224,101,-79,224,224,4,224,1002,223,8,223,101,3,224,224,1,224,223,223,1101,13,29,225,1101,71,70,225,1002,39,56,224,1001,224,-1232,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1101,14,59,225,102,38,143,224,1001,224,-494,224,4,224,102,8,223,223,101,3,224,224,1,224,223,223,1102,30,28,224,1001,224,-840,224,4,224,1002,223,8,223,101,4,224,224,1,223,224,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,107,677,226,224,1002,223,2,223,1005,224,329,1001,223,1,223,8,226,226,224,102,2,223,223,1006,224,344,101,1,223,223,7,226,677,224,1002,223,2,223,1005,224,359,101,1,223,223,1007,677,226,224,1002,223,2,223,1005,224,374,1001,223,1,223,1007,677,677,224,1002,223,2,223,1006,224,389,101,1,223,223,1008,226,226,224,1002,223,2,223,1005,224,404,1001,223,1,223,108,677,226,224,1002,223,2,223,1006,224,419,1001,223,1,223,1108,677,226,224,102,2,223,223,1006,224,434,1001,223,1,223,108,226,226,224,1002,223,2,223,1005,224,449,101,1,223,223,7,677,677,224,1002,223,2,223,1006,224,464,1001,223,1,223,8,226,677,224,1002,223,2,223,1005,224,479,1001,223,1,223,107,226,226,224,102,2,223,223,1006,224,494,101,1,223,223,1007,226,226,224,1002,223,2,223,1005,224,509,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,524,1001,223,1,223,108,677,677,224,1002,223,2,223,1005,224,539,101,1,223,223,1107,677,226,224,102,2,223,223,1005,224,554,1001,223,1,223,107,677,677,224,1002,223,2,223,1005,224,569,101,1,223,223,8,677,226,224,102,2,223,223,1005,224,584,1001,223,1,223,7,677,226,224,102,2,223,223,1006,224,599,101,1,223,223,1008,677,677,224,1002,223,2,223,1005,224,614,101,1,223,223,1008,677,226,224,102,2,223,223,1006,224,629,1001,223,1,223,1108,677,677,224,102,2,223,223,1006,224,644,101,1,223,223,1108,226,677,224,1002,223,2,223,1005,224,659,1001,223,1,223,1107,226,226,224,102,2,223,223,1006,224,674,1001,223,1,223,4,223,99,226]
var inputValues = [5]

enum ParamMode {
    case position
    case immediate
}

struct Parameter {
    let value: Int
    let mode: ParamMode
}

extension Parameter: CustomDebugStringConvertible {
    var debugDescription: String {
        return mode == ParamMode.position ? "[\(value)]" : "\(value)"
    }
}

enum Instruction {
    case add(param1: Parameter, param2: Parameter, destination: Int)
    case multiply(param1: Parameter, param2: Parameter, destination: Int)
    case input(param1: Parameter)
    case output(param1: Parameter)
    case jumpIfTrue(param1: Parameter, param2: Parameter)
    case jumpIfFalse(param1: Parameter, param2: Parameter)
    case lessThan(param1: Parameter, param2: Parameter, destination: Int)
    case equals(param1: Parameter, param2: Parameter, destination: Int)
    case halt

    var numValues: Int {
        switch self {
        case .add:          return 4
        case .multiply:     return 4
        case .input:        return 2
        case .output:       return 2
        case .jumpIfTrue:   return 3
        case .jumpIfFalse:  return 3
        case .lessThan:     return 4
        case .equals:       return 4
        case .halt:         return 1
        }
    }

    var code: String {
        switch self {
        case .add:          return "ADD"
        case .multiply:     return "MULT"
        case .input:        return "IN"
        case .output:       return "OUT"
        case .jumpIfTrue:   return "JIT"
        case .jumpIfFalse:  return "JIF"
        case .lessThan:     return "LEST"
        case .equals:       return "EQUA"
        case .halt:         return "HALT"
        }
    }
}

extension Instruction: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(code)"
    }
}


func instructionAt(pointer: Int, program: [Int]) -> Instruction {
    let opValue = program[pointer]
    var opValueString = "\(opValue)"

    // Prepend 0's
    for _ in 0..<(5-opValueString.count) {
        opValueString.insert("0", at: opValueString.startIndex)
    }

    let opCodeString = opValueString.suffix(2)
    let opCode = Int(opCodeString)!

    let param3Mode = opValueString[opValueString.startIndex] == "1" ? ParamMode.immediate : ParamMode.position
    let param2Mode = opValueString[opValueString.index(opValueString.startIndex, offsetBy: 1)] == "1"
        ? ParamMode.immediate : ParamMode.position
    let param1Mode = opValueString[opValueString.index(opValueString.startIndex, offsetBy: 2)] == "1"
        ? ParamMode.immediate : ParamMode.position

    switch opCode {
    case 1:
        let param1 = Parameter(value: program[pointer + 1], mode: param1Mode)
        let param2 = Parameter(value: program[pointer + 2], mode: param2Mode)
        return .add(param1: param1, param2: param2, destination: program[pointer + 3])
    case 2:
        let param1 = Parameter(value: program[pointer + 1], mode: param1Mode)
        let param2 = Parameter(value: program[pointer + 2], mode: param2Mode)
        return .multiply(param1: param1, param2: param2, destination: program[pointer + 3])
    case 3:
        let param1 = Parameter(value: program[pointer + 1], mode: param1Mode)
        return .input(param1: param1)
    case 4:
        let param1 = Parameter(value: program[pointer + 1], mode: param1Mode)
        return .output(param1: param1)
    case 5:
        let param1 = Parameter(value: program[pointer + 1], mode: param1Mode)
        let param2 = Parameter(value: program[pointer + 2], mode: param2Mode)
        return .jumpIfTrue(param1: param1, param2: param2)
    case 6:
        let param1 = Parameter(value: program[pointer + 1], mode: param1Mode)
        let param2 = Parameter(value: program[pointer + 2], mode: param2Mode)
        return .jumpIfFalse(param1: param1, param2: param2)
    case 7:
        let param1 = Parameter(value: program[pointer + 1], mode: param1Mode)
        let param2 = Parameter(value: program[pointer + 2], mode: param2Mode)
        return .lessThan(param1: param1, param2: param2, destination: program[pointer + 3])
    case 8:
        let param1 = Parameter(value: program[pointer + 1], mode: param1Mode)
        let param2 = Parameter(value: program[pointer + 2], mode: param2Mode)
        return .equals(param1: param1, param2: param2, destination: program[pointer + 3])
    case 99:
        return .halt
    default:
        fatalError("Unknown Opcode: \(opCode)")
    }
}

func execute(instruction: Instruction, pointer: Int) -> Int {
    print("Executing \(instruction) at \(pointer)")
    switch instruction {
    case .add(let param1, let param2, let destination):
        let operand1 = (param1.mode == ParamMode.position) ? intcode[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? intcode[param2.value] : param2.value
        intcode[destination] = operand1 + operand2

    case .multiply(let param1, let param2, let destination):
        let operand1 = (param1.mode == ParamMode.position) ? intcode[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? intcode[param2.value] : param2.value
        intcode[destination] = operand1 * operand2

    case .input(let param1):
        // TODO: Add stdin?
        let input = inputValues.removeFirst()
        intcode[param1.value] = input
        break

    case .output(let param1):
        if param1.mode == ParamMode.position {
            print(intcode[param1.value])
        } else {
            print(param1.value)
        }

    case .jumpIfTrue(let param1, let param2):
        let operand1 = (param1.mode == ParamMode.position) ? intcode[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? intcode[param2.value] : param2.value
        if operand1 != 0 {
            return operand2
        }

    case .jumpIfFalse(let param1, let param2):
        let operand1 = (param1.mode == ParamMode.position) ? intcode[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? intcode[param2.value] : param2.value
        if operand1 == 0 {
            return operand2
        }

    case .lessThan(let param1, let param2, let destination):
        let operand1 = (param1.mode == ParamMode.position) ? intcode[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? intcode[param2.value] : param2.value
        if operand1 < operand2 {
            intcode[destination] = 1
        } else {
            intcode[destination] = 0
        }

    case .equals(let param1, let param2, let destination):
        let operand1 = (param1.mode == ParamMode.position) ? intcode[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? intcode[param2.value] : param2.value
        if operand1 == operand2 {
            intcode[destination] = 1
        } else {
            intcode[destination] = 0
        }

    case .halt:
        return -1
    }

    return pointer + instruction.numValues
}

public func day5() {

    var ipx = 0

    while ipx >= 0 {
        let instruction = instructionAt(pointer: ipx, program: intcode)
        ipx = execute(instruction: instruction, pointer: ipx)
    }
}
