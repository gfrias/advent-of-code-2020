import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day20b.playground/Resources/day20.txt"

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

func splitTiles(lines:[String]) -> [Int:Matrix] {
    var ret = [Int:Matrix]()

    var id: Int? = nil

    var matrix = [[String]]()
    for ln in lines {
        if ln.contains("Tile") {
            if let id = id {
                ret[id] = matrix
                matrix = [[String]]()
            }

            let str = ln.replacingOccurrences(of: ":", with: "").split(separator: " ")[1]
            id = Int(str)
        } else {
            matrix.append(ln.map{String($0)})
        }
    }
    if let id = id {
        ret[id] = matrix
    }

    return ret
}

func getTransforms() -> [Transform] {
    var ret = [Transform]()
    for fCol in [-1, 1] {
        for fRow in [-1, 1] {
            for rot in 0..<4 {
                ret.append(Transform(rotation: rot,
                                     flipRows: fRow,
                                     flipCols: fCol))
            }
        }
    }
    return ret
}

func generateVariant(matrix: Matrix, trans: Transform) -> Matrix {
    let (rows, cols) = (matrix.count, matrix[0].count)
    var ret = Array(repeating: Array(repeating: "", count: cols), count: rows)

    let offsets = [[0, 0], [0, cols - 1], [rows - 1, cols - 1], [rows - 1, 0]]
    let delta = [ [[1,0],[0,1]], [[0,1],[-1,0]], [[-1,0],[0,-1]], [[0,-1],[1,0]] ]

    let (rot, fR, fC) = (trans.rotation, trans.flipRows, trans.flipCols)

    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            var c = offsets[rot][1] + delta[rot][1][0]*i + delta[rot][1][1]*j
            var r = offsets[rot][0] + delta[rot][0][0]*i + delta[rot][0][1]*j

            r = fC == 1 ? r: rows-1 - r
            c = fR == 1 ? c: cols-1 - c
            ret[r][c] = matrix[i][j]
        }
    }

    return ret
}

func generateVariants(matrix:Matrix) -> [Matrix] {
    var ret = [Matrix]()

    for trans in getTransforms() {
        ret.append(generateVariant(matrix: matrix, trans: trans))
    }

    return ret
}

func nextFit(ids: [Int], availIds:Set<Int>) ->[Int] {
    let totalBlocks = mM.keys.count
    let rowColMatrixCount = Int(sqrt(Double(totalBlocks)))

    var left: Matrix? = nil
    var top: Matrix? = nil

    let idx = ids.count

    let mRow = idx / rowColMatrixCount
    let mCol = idx % rowColMatrixCount
    
    if mRow > 0 {
        let i = (mRow-1)*rowColMatrixCount+mCol
        top = matrices[ids[i]]
    }
    if mCol > 0 {
        let i = mRow*rowColMatrixCount+mCol-1
        left = matrices[ids[i]]
    }

    let prev = matrices[ids.last!]
    let (rowCount, colCount) = (prev.count, prev[0].count)

    for idNext in availIds {
        let next = matrices[idNext]

        var fit = true
        for i in 0..<rowCount {
            if let left = left, left[i][colCount-1] != next[i][0] {
                fit = false
                break
            }
            if let top = top, top[colCount-1][i] != next[0][i] {
                fit = false
                break
            }
        }
        if fit {
            let newIds = ids + [idNext]
            if newIds.count == totalBlocks {
                return newIds
            } else {
                var newAvailIds = availIds
                let ids = childrenIds[parentIds[idNext]!]!
                for id in ids {
                    newAvailIds.remove(id)
                }

                return nextFit(ids: newIds, availIds: newAvailIds)
            }
        }
    }
    return []
}

func printMatrix(_ m: Matrix) {
    for r in m {
        print(r.joined())
    }
    print("")
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
                arr.append(contentsOf: matrices[idx][r])
            }
            ret.append(arr)
        }
    }

    return ret
}

func prob1() -> [Int] {
    let totalBlocks = mM.keys.count
    let rowColMatrixCount = Int(sqrt(Double(totalBlocks)))

    for id in availIds {
        var newAvailIds = availIds
        let ids = childrenIds[parentIds[id]!]!
        for i in ids {
            newAvailIds.remove(i)
        }

        let res = nextFit(ids: [id], availIds: newAvailIds)
        if res.count > 0 {
            let resIds = res.map{ parentIds[$0]! }

            let val = resIds[0] * resIds[rowColMatrixCount-1] * resIds[(rowColMatrixCount-1)*rowColMatrixCount] *
                resIds[(rowColMatrixCount-1)*rowColMatrixCount+rowColMatrixCount-1]
            print(val)
            return res
        }
    }
    return []
}

var parentIds = [Int:Int]()
var childrenIds = [Int:[Int]]()
var availIds = Set<Int>()

let mM = splitTiles(lines: lines)

var matrices = [Matrix]()


for k in mM.keys.sorted() {
    let m = mM[k]!
    for n in generateVariants(matrix: m) {
        matrices.append(n)

        let k2 = matrices.count - 1
        parentIds[k2] = k
        var children = childrenIds[k] ?? [Int]()
        children.append(k2)
        childrenIds[k] = children
        availIds.insert(k2)
    }
}

func findMatches(matrix: Matrix) {
    let strMask = "                  # \n#    ##    ##    ###\n #  #  #  #  #  #   "
    let mask = strMask.split(separator: "\n")
                      .map { s in s.map { $0 == "#" } }

    let counts:[Int] = mask.map({ $0.count })
    let totalMaskCount = counts.reduce(0, +)

    var matches = 0
    var matchesHash = 0
    var monsters = 0
    var monsHash = 0

    var idx = 0
    for i in 0..<matrix.count-2 {
        while idx + counts[0] < matrix[0].count {
            matches = 0
            monsHash = 0

            for j in idx..<(idx + counts[0]) {
                if ((mask[0][j-idx] && matrix[i][j] == "#") || (!mask[0][j-idx])) &&
                   ((mask[1][j-idx] && matrix[i+1][j] == "#") || (!mask[1][j-idx])) &&
                    ((mask[2][j-idx] && matrix[i+2][j] == "#") || (!mask[2][j-idx])) {
                    matches += 3

                    for k in 0..<3 {
                        if mask[k][j-idx] && matrix[i+k][j] == "#" {
                            monsHash += 1
                        }
                    }
                } else {
                    matches = 0
                    monsHash = 0
                    break
                }

                if matches == totalMaskCount {
                    matches = 0
                    monsters += 1
                    matchesHash += monsHash
                    monsHash = 0
                }
            }
            idx += 1
        }
        idx = 0
    }

    let countHashes = matrix.map { $0.filter { $0 == "#" }.count }.reduce(0, +)

    print(monsters, countHashes-matchesHash)

}

func prob2() {
    let ids = prob1()
    let ms = ids.map { matrices[$0] }

    let ns = ms.map { removeBorder(matrix: $0) }

    let mergeMat = mergeMatrices(matrices: ns)

    let allImages = generateVariants(matrix: mergeMat)

    for im in allImages {
        findMatches(matrix: im)
    }
}

prob2()


