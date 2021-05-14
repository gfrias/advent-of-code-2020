import Foundation

let filepath = Bundle.main.path(forResource: "day15", ofType: "txt")!
//let filepath = "/Users/gfrias/advent/day15.playground/Resources/day15.txt"

let startNums = try String(contentsOfFile: filepath)
                    .split(whereSeparator: \.isNewline)
                    .flatMap { $0.split(separator: ",")}
                    .compactMap{Int($0)}

func prob1() -> Int {
    var mem = [Int:(Int,Int)]()

    var last = 0, count = 0
    for i in 0..<startNums.count {
        last = startNums[i]
        if let tuple = mem[last] {
            mem[last] = (i-tuple.1, i)
        } else {
            mem[last] = (0, i)
        }
        count += 1
    }

    for i in count..<30000000 {
        if i % 1000 == 0 {
            print(i, "\(i/300000)%")
        }
        let t = mem[last] ?? (0, i)

        let say = t.0

        let u = mem[say] ?? (0, i)

        mem[say] = (i-u.1, i)

        last = say
    }
//    print(mem)

    return last
}

print(prob1())
