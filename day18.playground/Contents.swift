import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day18.playground/Resources/day18.txt"

let lines = try String(contentsOfFile: filepath).replacingOccurrences(of: " ", with: "")
                        .split(whereSeparator: \.isNewline)
                        .map{ String($0) }

protocol Node {
    func apply() -> Int
}

struct Number: Node {
    let n: Int

    init(c: Character) {
        self.n = Int(String(c))!
    }
    func apply() -> Int {
        n
    }
}

struct Term: Node {
    var op: Character
    var nodes: [Node]

    init(op: Character, nodes: [Node]) {
        self.op = op
        self.nodes = nodes
    }

    func apply() -> Int {
        switch(op) {
        case "+":
            return nodes.map { $0.apply() }.reduce(0, +)
        case "*":
            return nodes.map { $0.apply() }.reduce(1, *)
        default:
            assert(false, "operation not supported by Term")
        }
    }
}

func toRPN(line:String, usePrecedence: Bool) -> [Character] {
//    print("evaluating \(line)")

    var res = [Character]()
    var operands = [Character]()

    for c in line {
        switch (c) {
        case "0"..."9":
            res.append(c)
        case "+":
            while let oper = operands.last, (oper == "+" || (oper == "*" && !usePrecedence)) {
                res.append(operands.popLast()!)
            }
            operands.append(c)
        case "*":
            while let oper = operands.last, (oper == "+" || oper == "*") {
                res.append(operands.popLast()!)
            }
            operands.append(c)
        case "(":
            operands.append(c)
        case ")":
            while let oper = operands.last, oper != "(" {
                res.append(operands.popLast()!)
            }
            if let oper = operands.last, oper == "(" {
                _ = operands.popLast()
            }
        default:
            assert(false, "not implemented")
        }
    }

    while !operands.isEmpty {
        res.append(operands.popLast()!)
    }

    return res
}

func buildAST(line: String, usePrecedence: Bool) -> Node {
    let rpn = toRPN(line: line, usePrecedence: usePrecedence)

    var ret = [Node]()

    for c in rpn {
        switch (c) {
        case "0"..."9":
            ret.append(Number(c: c))
        case "+", "*":
            if let n2 = ret.popLast(), let n1 = ret.popLast() {
                ret.append(Term(op: c, nodes: [n1, n2]))
            } else {
                assert(false, "parse error")
            }
        default:
            assert(false, "command not supported")
        }
    }

    assert(ret.count == 1)
    return ret.first!
}

func evalLine(line:String, usePrecedence: Bool) -> Int {
    let node = buildAST(line: line, usePrecedence: usePrecedence)

    let ret = node.apply()
//    print("res=\(ret)")
    return ret
}

func prob1() -> Int {
    return lines.map { evalLine(line: $0, usePrecedence: false) }.reduce(0, +)
}

func prob2() -> Int {
    return lines.map { evalLine(line: $0, usePrecedence: true) }.reduce(0, +)
}

print(prob1())
print(prob2())
