import Foundation

let filepath = Bundle.main.path(forResource: "day9", ofType: "txt")!

let lines = try String(contentsOfFile: filepath)
                .split(whereSeparator: \.isNewline)
                .compactMap{ Int($0) }

func prob1() -> Int {
    var positions = [Int:Int]()

    for (k, v) in lines.enumerated() {
        positions[v] = k
    }
    let step = 25

    for i in step..<lines.count {
        let n = lines[i]
        var valid = false
        for j in i-step..<i {
            let m = lines[j]
            let diff = n - m
            
            if let pos = positions[diff], pos >= i-step, pos < i {
                valid = true
                break
            }
        }
        if !valid {
            return n
        }
    }

    return -1
}

func prob2() -> Int {
    let n = prob1()

    var (i, j, acc) = (0, 0, lines[0])

    while acc < n {
        j += 1
        acc += lines[j]
        if acc == n {
            return lines[i...j].min()!+lines[i...j].max()!
        } else if acc > n {
            acc -= lines[j]
            j -= 1
            acc -= lines[i]
            i += 1
            assert(i <= j)
        }
    }

    return -1
}

print(prob2())
