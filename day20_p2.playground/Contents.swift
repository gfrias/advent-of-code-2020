import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day20_p2.playground/Resources/ex.txt"

let lines = try String(contentsOfFile: filepath)
                        .split(whereSeparator: \.isNewline)
                        .map{String($0)}

struct Transform: CustomStringConvertible {
    let rotation: Int
    let flipRows: Int
    let flipCols: Int

    var description: String {
        return "t(rot: \(rotation), fRow: \(flipRows), fCol: \(flipCols))"
    }
}

typealias Matrix = [[String]]

func getTiles(lines:[String]) -> [Matrix] {
    var ret = [Matrix]()

    var matrix:Matrix? = nil

    for ln in lines {
        if ln.contains("Tile") {
            if let matrix = matrix {
                ret.append(matrix)
            }
            matrix = [[String]]()
        } else {
            matrix!.append(ln.map{String($0)})
        }
    }
    ret.append(matrix!)

    return ret
}

func removeBorder(matrix: Matrix) -> Matrix {
    var ret = Array(repeating: Array(repeating: "", count: matrix[0].count-2), count: matrix.count-2)

    for i in 1..<matrix.count-1 {
        for j in 1..<matrix[0].count-1 {
            ret[i-1][j-1] = matrix[i][j]
        }
    }
    return ret
}

func mergeMatrices(matrices:[Matrix]) -> Matrix {
    var ret = Matrix()
    let count = matrices.count
    let rowColCount = Int(sqrt(Double(count)))

    for i in 0..<rowColCount {
        for r in 0..<matrices[0].count {
            var arr = [String]()
            for j in 0..<rowColCount {
                let idx = i*rowColCount + j
                print(i,r,j, idx)
                arr.append(contentsOf: matrices[idx][r])
            }
            ret.append(arr)
        }
    }

    return ret
}

func printMatrix(_ m: Matrix) {
    for r in m {
        print(r.joined())
    }
    print("")
}

func prob2() {
    let matrices = getTiles(lines: lines).map { removeBorder(matrix: $0) }
    for m in matrices {
        printMatrix(m)
    }

    let m = mergeMatrices(matrices: matrices)
    printMatrix(m)
}


prob2()
