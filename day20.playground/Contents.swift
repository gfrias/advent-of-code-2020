import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day20.playground/Resources/ex.txt"

let lines = try String(contentsOfFile: filepath)
                        .split(whereSeparator: \.isNewline)
                        .map{String($0)}

typealias MatrixMap = [Int: [[String]]]

struct Transform: CustomStringConvertible {
    let rotation: Int
    let flipRows: Int
    let flipCols: Int

    var description: String {
        return "t(rot: \(rotation), fRow: \(flipRows), fCol: \(flipCols))"
    }
}

struct MatrixData: CustomStringConvertible {
    let id: Int
    let trans: Transform
    var description: String {
        return "MD= id:\(id) trans:\(trans.description)"
    }
}

func splitTiles(lines:[String]) -> MatrixMap {
    var ret = MatrixMap()

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

func getValue(m:[[String]], trans:Transform, i:Int) -> String {
    let cols = m[0].count

    let origins = [(0,0), (cols-1, 0), (cols-1, cols-1), (0, cols-1)]
    let deltas = [(1,0), (0, 1), (-1, 0), (0, -1)]

    let rot = trans.rotation

    let oRow = trans.flipRows == 1 ? origins[rot].0 : cols-1-origins[rot].0
    let oCol = trans.flipCols == 1 ? origins[rot].1 : cols-1-origins[rot].1

    let row = oRow + i*deltas[rot].0*trans.flipRows
    let col = oCol + i*deltas[rot].1*trans.flipCols

    return m[row][col]
}

func fitsToTheSide(matrixMap: MatrixMap, mdLeft: MatrixData, idRight: Int) -> Transform? {
    let left = matrixMap[mdLeft.id]!
    let right = matrixMap[idRight]!

    let (rows, cols) = (left.count, left[0].count)

    for fCol in [-1, 1] {
        for fRow in [-1, 1] {
            for rot in 0..<4 {
                var fits = true
                let trans = Transform(rotation: rot, flipRows: fRow, flipCols: fCol)

                for i in 0..<rows {
                    if left[i][cols-1] != getValue(m: right, trans: trans, i: i) {
                        fits = false
                        break
                    }
                }
                if fits {
                    return trans
                }
            }
        }
    }

    return nil
}

func findCandidates(matrixMap: MatrixMap, availIds:Set<Int>, matrixData: MatrixData) {
    for idCand in availIds {
        if let transform = fitsToTheSide(matrixMap: matrixMap, mdLeft: matrixData, idRight: idCand) {
            print("found", matrixData, idCand, transform)
        }
    }
}

func prob1() {
    let matrixMap = splitTiles(lines: lines)

    let availIds = Set<Int>(matrixMap.map { $0.key })

    for id in availIds {
        var setIds = availIds
        setIds.remove(id)

        let matrixData = MatrixData(id: id, trans: Transform(rotation: 0,
                                                             flipRows: 1,
                                                             flipCols: 1))
//        print("finding candidates \(id)")
        findCandidates(matrixMap: matrixMap, availIds: setIds, matrixData: matrixData)
    }
}

func bla() {
    let left = [["a","b","c"], ["d", "e", "f"], ["g","h","i"]]
    let right = [["j","k","l"], ["m", "n", "o"], ["p","q","r"]]

    let (rows, cols) = (left.count, left[0].count)

//    let origins = [(0,0), (cols-1, 0), (cols-1, cols-1), (0, cols-1)]
//    let deltas = [(1,0), (0, 1), (-1, 0), (0, -1)]
//
//    for j in 0..<deltas.count {
//        for i in 0..<rows {
//            let x = origins[j].0 + i*deltas[j].0
//            let y = origins[j].1 + i*deltas[j].1
//
//            print(left[i][cols-1], right[x][y])
//        }
//        print("")
//    }
    let origins = [(0,0), (cols-1, 0), (cols-1, cols-1), (0, cols-1)]
    let deltas = [(1,0), (0, 1), (-1, 0), (0, -1)]

    let j = 0

    for fV in [-1, 1] {
        for fH in [-1, 1] {
            print("fv: \(fV) fh: \(fH)")
            for i in 0..<rows {
                let ox = fH == 1 ? origins[j].0 : cols-1-origins[j].0
                let oy = fV == 1 ? origins[j].1 : cols-1-origins[j].1

                let x = ox + i*deltas[j].0*fH
                let y = oy + i*deltas[j].1*fV

                print(left[i][cols-1], right[x][y])
            }
            print("")
        }
    }

}

//bla()

prob1()
