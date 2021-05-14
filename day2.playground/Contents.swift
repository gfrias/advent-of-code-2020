import Foundation

let filepath = Bundle.main.path(forResource: "day2", ofType: "txt")!

//let lines = "1-3 a: abcde\n1-3 b: cdefg\n2-9 c: ccccccccc".split(separator: "\n")
let lines = try String(contentsOfFile: filepath).split(separator: "\n")

func prob1() {
    var validCount = 0
    for line in lines {
        let parts = line.split(separator: " ")
        let ranges = parts[0].split(separator: "-")
        let (mn, mx) = (Int(ranges[0])!, Int(ranges[1])!)
        let letter = parts[1].split(separator: ":")[0]
        let pass = parts[2]

        let count = pass.reduce(into: 0) { (res, c) in
            if String(c) == letter {
                res += 1
            }
        }

        if count >= mn && count <= mx {
            validCount += 1
        }
    }
    print(validCount)
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

func prob2() {
    var validCount = 0

    for line in lines {
        let parts = line.split(separator: " ")
        let ranges = parts[0].split(separator: "-")
        let (p1, p2) = (Int(ranges[0])! - 1, Int(ranges[1])! - 1)
        let letter = Character(parts[1].split(separator: ":")[0].description)
        let pass = parts[2].description
        print(p1, p2, letter, pass)

        if p2 < pass.count {
            if pass[p1] == letter && pass[p2] != letter  {
                validCount += 1
            }
            if pass[p1] != letter && pass[p2] == letter  {
                validCount += 1
            }
        }
    }
    print(validCount)
}

prob2()
