//
//  main.swift
//  aoc2019
//
//  Created by Charles A Nowacek on 12/12/19.
//  Copyright © 2019 kayosmedia. All rights reserved.
//

import Foundation

//let intcode: [Int] = [3,8,1001,8,10,8,105,1,0,0,21,46,67,76,101,118,199,280,361,442,99999,3,9,1002,9,4,9,1001,9,2,9,102,3,9,9,101,3,9,9,102,2,9,9,4,9,99,3,9,1001,9,3,9,102,2,9,9,1001,9,2,9,1002,9,3,9,4,9,99,3,9,101,3,9,9,4,9,99,3,9,1001,9,2,9,1002,9,5,9,101,5,9,9,1002,9,4,9,101,5,9,9,4,9,99,3,9,102,2,9,9,1001,9,5,9,102,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99]

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

func execute(instruction: Instruction, pointer: Int, memory: inout [Int], input: inout [Int], output: inout [Int]) -> Int {
//    print("Executing \(instruction) at \(pointer)")
    switch instruction {
    case .add(let param1, let param2, let destination):
        let operand1 = (param1.mode == ParamMode.position) ? memory[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? memory[param2.value] : param2.value
        memory[destination] = operand1 + operand2

    case .multiply(let param1, let param2, let destination):
        let operand1 = (param1.mode == ParamMode.position) ? memory[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? memory[param2.value] : param2.value
        memory[destination] = operand1 * operand2

    case .input(let param1):
        guard let _ = input.first else {
            print("Waiting for input...")
            return pointer
        }
        memory[param1.value] = input.removeFirst()
        break

    case .output(let param1):
        if param1.mode == ParamMode.position {
//            print(memory[param1.value])
            output.append(memory[param1.value])
        } else {
//            print(param1.value)
            output.append(param1.value)
        }

    case .jumpIfTrue(let param1, let param2):
        let operand1 = (param1.mode == ParamMode.position) ? memory[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? memory[param2.value] : param2.value
        if operand1 != 0 {
            return operand2
        }

    case .jumpIfFalse(let param1, let param2):
        let operand1 = (param1.mode == ParamMode.position) ? memory[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? memory[param2.value] : param2.value
        if operand1 == 0 {
            return operand2
        }

    case .lessThan(let param1, let param2, let destination):
        let operand1 = (param1.mode == ParamMode.position) ? memory[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? memory[param2.value] : param2.value
        if operand1 < operand2 {
            memory[destination] = 1
        } else {
            memory[destination] = 0
        }

    case .equals(let param1, let param2, let destination):
        let operand1 = (param1.mode == ParamMode.position) ? memory[param1.value] : param1.value
        let operand2 = (param2.mode == ParamMode.position) ? memory[param2.value] : param2.value
        if operand1 == operand2 {
            memory[destination] = 1
        } else {
            memory[destination] = 0
        }

    case .halt:
        return -1
    }

    return pointer + instruction.numValues
}

// Returns current pointer
public func run(intcode: inout [Int], input: [Int], output: inout [Int], ipx: Int = 0) -> Int {
    var ipx = ipx
    var mInput = input
    var mOutput: [Int] = []
    while ipx >= 0 {
        let instruction = instructionAt(pointer: ipx, program: intcode)
        ipx = execute(instruction: instruction, pointer: ipx, memory: &intcode, input: &mInput, output: &mOutput)
        if let _ = mOutput.first {
            output.append(mOutput.removeFirst())
            return ipx
        }
    }
    return -1
}


func day7() {
    
    var maxThruster = 0
    var phase: [Int] = []
    let intcode = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]
    //let intcode: [Int] = [3,8,1001,8,10,8,105,1,0,0,21,46,67,76,101,118,199,280,361,442,99999,3,9,1002,9,4,9,1001,9,2,9,102,3,9,9,101,3,9,9,102,2,9,9,4,9,99,3,9,1001,9,3,9,102,2,9,9,1001,9,2,9,1002,9,3,9,4,9,99,3,9,101,3,9,9,4,9,99,3,9,1001,9,2,9,1002,9,5,9,101,5,9,9,1002,9,4,9,101,5,9,9,4,9,99,3,9,102,2,9,9,1001,9,5,9,102,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99]

    let phasePermutations = permutations(xs: [5,6,7,8,9])
    
    for phasePermutation in phasePermutations {
        
        let psA = phasePermutation[0]
        let psB = phasePermutation[1]
        let psC = phasePermutation[2]
        let psD = phasePermutation[3]
        let psE = phasePermutation[4]
        
        var ampA = intcode
        var ampB = intcode
        var ampC = intcode
        var ampD = intcode
        var ampE = intcode
        
        var ampAipx = 0
        var ampBipx = 0
        var ampCipx = 0
        var ampDipx = 0
        var ampEipx = 0
        
        var input: Int? = 0
        var lastOutput = 0
        var count = 0
        while input != nil {
            print("Ran \(count)")
            let ampAin = [psA, input!]
            var ampAOut: [Int] = []
            ampAipx = run(intcode: &ampA, input: ampAin, output: &ampAOut, ipx: ampAipx)
            if ampAipx < 0 {
                break
            }
            
            let ampBin = [psB, ampAOut.removeFirst()]
            var ampBOut: [Int] = []
            ampBipx = run(intcode: &ampB, input: ampBin, output: &ampBOut, ipx: ampBipx)
            if ampBipx < 0 {
                break
            }
            
            let ampCin = [psC, ampBOut.removeFirst()]
            var ampCOut: [Int] = []
            ampCipx = run(intcode: &ampC, input: ampCin, output: &ampCOut, ipx: ampCipx)
            if ampCipx < 0 {
                break
            }
            
            let ampDin = [psD, ampCOut.removeFirst()]
            var ampDOut: [Int] = []
            ampDipx = run(intcode: &ampD, input: ampDin, output: &ampDOut, ipx: ampDipx)
            if ampDipx < 0 {
                break
            }
            
            let ampEin = [psE, ampDOut.removeFirst()]
            var ampEOut: [Int] = []
            ampEipx = run(intcode: &ampE, input: ampEin, output: &ampEOut, ipx: ampEipx)
            
            input = ampEOut.removeFirst()
            if let input = input {
                lastOutput = input
            }
            count+=1
        }
        print(lastOutput)
        if lastOutput > maxThruster {
            maxThruster = lastOutput
            phase = [psA, psB, psC, psD, psE]
        }
        
    }
    
    print("Max thrust of \(maxThruster) from \(phase)")
}

print("Running...")
day7()
print("Done")
