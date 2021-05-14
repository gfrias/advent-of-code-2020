import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

let filepath = Bundle.main.path(forResource: "day3", ofType: "txt")!

let lines = try String(contentsOfFile: filepath).split(separator: "\n").map { String($0) }

func prob1(right: Int, down: Int) -> Int {
    var trees = 0, offset = 0

    for (_, ln) in lines.enumerated().filter({$0.offset % down == 0}) {
        if ln[offset] == "#" {
            trees += 1
        }
        offset = (offset+right) % ln.count
    }
    return trees
}

func prob1b(right: Int, down: Int) -> Int {
    let size = lines.first?.count ?? 0

    return lines.enumerated()
        .filter{$0.offset % down == 0}
        .map{($0.offset*right/down, $0.element)}
        .filter{(i, ln) in
            ln[i % size] == "#"
        }.count
}


print(prob1(right: 1, down: 1)*prob1(right: 3, down: 1)*prob1(right: 5, down: 1)*prob1(right: 7, down: 1)*prob1(right: 1, down: 2))
print(prob1b(right: 1, down: 1)*prob1b(right: 3, down: 1)*prob1b(right: 5, down: 1)*prob1b(right: 7, down: 1)*prob1b(right: 1, down: 2))

