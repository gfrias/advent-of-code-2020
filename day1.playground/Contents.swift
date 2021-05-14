import Foundation

let filepath = Bundle.main.path(forResource: "input_day1", ofType: "txt")!

let lines = try String(contentsOfFile: filepath).split(separator: "\n")

var values = Set<Int>(lines.map { Int($0)! })

func prob1() {
    for val in values {
        let diff = 2020 - val
        if values.contains(diff) {
            let mult = val * diff
            print("found \(val)*\(diff)=\(mult)")
            return
        }
    }
}

func prob2() {
    for v1 in values {
        for v2 in values {
            if v1 != v2 {
                let diff = 2020 - v1 - v2
                if values.contains(diff) {
                    let mult = v1 * v2 * diff
                    print("found \(v1)*\(v2)*\(diff)=\(mult)")
                    return
                }
            }
        }
    }
}

prob2()
