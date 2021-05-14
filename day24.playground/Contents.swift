import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day24.playground/Resources/day24.txt"

let lines = try String(contentsOfFile: filepath).replacingOccurrences(of: " ", with: "")
                        .split(whereSeparator: \.isNewline)
                        .map{ String($0) }

let SIZE = 200

func parse(line:String) -> [String] {
    var ret = [String]()
    var cmd: String? = nil

    for c in line {
        let str = String(c)

        if let strCommand = cmd {
            if str == "w" || str == "e" {
                ret.append(strCommand + str)
                cmd = nil
            } else {
                assert(false, "command unknown")
            }
        } else {
            if str == "n" || str == "s" {
                cmd = str
            } else {
                ret.append(str)
            }
        }
    }

    return ret
}

func parse(lines:[String]) -> [[String]] {
    lines.map { parse(line: $0)}
}

func move(point: (Int, Int), dir: String) -> (Int, Int) {
    let isRowEven = (point.0 % 2) == 0

    switch dir {
    case "e":
        return (point.0, point.1+1)
    case "w":
        return (point.0, point.1-1)
    case "ne":
        if isRowEven {
            return (point.0-1, point.1)
        } else {
            return (point.0-1, point.1+1)
        }
    case "nw":
        if isRowEven {
            return (point.0-1, point.1-1)
        } else {
            return (point.0-1, point.1)
        }
    case "se":
        if isRowEven {
            return (point.0+1, point.1)
        } else {
            return (point.0+1, point.1+1)
        }
    case "sw":
        if isRowEven {
            return (point.0+1, point.1-1)
        } else {
            return (point.0+1, point.1)
        }
    default:
        assert(false, "unknown direction: \(dir)")
    }

    return point
}

func buildMatrix(directions: [[String]]) ->[[Bool]] {
    var matrix = Array(repeating:Array(repeating: false, count: SIZE), count: SIZE)

    let origin = (SIZE/2-1, SIZE/2-1)

    var curr = origin

    for dir in directions {
        curr = origin
        for d in dir {
            curr = move(point: curr, dir: d)
        }
        matrix[curr.0][curr.1] = !matrix[curr.0][curr.1]
    }

    return matrix
}

func prob1(lines:[String]) -> Int {
    let directions = parse(lines: lines)
    let matrix = buildMatrix(directions: directions)

    return matrix.map{ row in row.filter{$0}.count }.reduce(0, +)
}

func moves(point: (Int, Int)) -> [(Int, Int)] {
    let directions = ["e", "se", "sw", "w", "nw", "ne"]

    var ret = [(Int, Int)]()
    for dir in directions {
        let p = move(point: point, dir: dir)
        if p.0 >= 0 && p.0 < SIZE && p.1 >= 0 && p.1 < SIZE {
            ret.append(p)
        }
    }

    return ret
}

func prob2(lines:[String]) -> Int {
    let directions = parse(lines: lines)
    var matrix = buildMatrix(directions: directions)

    for _ in 1...100 {
        var newMatrix = matrix
        for i in 0..<SIZE {
            for j in 0..<SIZE {
                let movs = moves(point: (i, j))
                var count = 0

                for m in movs {
                    if matrix[m.0][m.1] {
                        count += 1
                    }
                }
                if matrix[i][j] {
                    if (count == 0 || count > 2) {
                        newMatrix[i][j] = false
                    }
                } else {
                    if count == 2 {
                        newMatrix[i][j] = true
                    }
                }
            }
        }
        matrix = newMatrix
    }

    return matrix.map{ row in row.filter{$0}.count }.reduce(0, +)
}

print(prob2(lines: lines))
