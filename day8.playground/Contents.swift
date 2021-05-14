import Foundation

let filepath = Bundle.main.path(forResource: "day8", ofType: "txt")!

enum Operation {
    case acc(Int)
    case jmp(Int)
    case nop(Int)

    static func fromString(_ str: String.SubSequence) -> Operation? {
        let parts = str.split(separator: " ")
        guard let strOperation = parts.first,
              parts.count == 2,
              let val = Int(String(parts[1])) else {
            return nil
        }
        switch strOperation {
        case "acc":
            return Operation.acc(val)
        case "jmp":
            return Operation.jmp(val)
        case "nop":
            return Operation.nop(val)
        default:
            return nil
        }
    }
}

let lines = try String(contentsOfFile: filepath)
                .split(whereSeparator: \.isNewline)
                .compactMap{ Operation.fromString($0) }

func prob1(_ lines:[Operation]) -> (Int, Int) {
    var executed = Set<Int>()
    var pointer = 0

    var acc = 0
    while(!executed.contains(pointer) && pointer < lines.count) {
        executed.insert(pointer)
        let op = lines[pointer]

        switch op {
        case .acc(let val):
            acc += val
            pointer += 1
        case .jmp(let val):
            pointer += val
        case .nop(_):
            pointer += 1
        }
    }

    return (acc, pointer)
}

func prob2(_ lines:[Operation]) -> Int {
    var operations = lines

    for i in 0..<operations.count {
        let oldOp = operations[i]
        var newOp = oldOp
        switch operations[i] {
        case .jmp(let val):
            newOp = .nop(val)
        case .nop(let val):
            newOp = .jmp(val)
        default:
            continue
        }
        operations[i] = newOp
        let (acc, pointer) = prob1(operations)
        if pointer == operations.count {
            return acc
        }
        operations[i] = oldOp
    }

    return -1
}

print(prob2(lines))

