import Foundation

let filepath = Bundle.main.path(forResource: "day11", ofType: "txt")!

let lines = try String(contentsOfFile: filepath)
    .split(whereSeparator: \.isNewline)
    .map{ $0.map {String($0)} }

//If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
//If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.

func shouldChangeState(seat: String, oc: Int) -> Bool {
    switch seat {
    case "L":
        return oc == 0
    case "#":
        return oc >= 4
    default:
        return false
    }
}

func updateOccs(occs: [[Int]], deltas: [[Int]]) -> [[Int]] {
    var ret = occs

    for i in 0..<occs.count {
        for j in 0..<occs[i].count {
            for k in max(0, i-1)...min(i+1, occs.count-1) {
                for l in max(0, j-1)...min(j+1, occs[i].count-1) {
                    if i != k || j != l {
                        ret[k][l] += deltas[i][j]
                    }
                }
            }
        }
    }

    return ret
}

func simLoop(matrix: inout [[String]], occs: inout [[Int]]) -> Int {
    var changes = 0
    var deltas = occs.map { Array.init(repeating: 0, count: $0.count)}

    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            var seat = matrix[i][j]
            switch(seat) {
            case "L":
                if shouldChangeState(seat: seat, oc: occs[i][j]) {
                    deltas[i][j] = 1
                    seat = "#"
                    changes += 1
                }
            case "#":
                if shouldChangeState(seat: seat, oc: occs[i][j]) {
                    deltas[i][j] = -1
                    seat = "L"
                    changes += 1
                }
            default:
                continue
            }
            matrix[i][j] = seat
        }
    }
    occs = updateOccs(occs: occs, deltas: deltas)

    return changes
}

func updateOccsVisible(occs: [[Int]], deltas: [[Int]], visibility: [[[(Int, Int)]]]) -> [[Int]] {
    var ret = occs

    for i in 0..<occs.count {
        for j in 0..<occs[i].count {
            let visibles = visibility[i][j]
            for v in visibles {
                if i != v.0 || j != v.1 {
                    ret[v.0][v.1] += deltas[i][j]
                }
            }
        }
    }

    return ret
}

func shouldChangeStateVisible(seat: String, oc: Int) -> Bool {
    switch seat {
    case "L":
        return oc == 0
    case "#":
        return oc >= 5
    default:
        return false
    }
}

func simLoopVisible(matrix: inout [[String]], occs: inout [[Int]], visibility: [[[(Int, Int)]]]) -> Int {
    var changes = 0
    var deltas = occs.map { Array.init(repeating: 0, count: $0.count)}

    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            var seat = matrix[i][j]
            switch(seat) {
            case "L":
                if shouldChangeStateVisible(seat: seat, oc: occs[i][j]) {
                    deltas[i][j] = 1
                    seat = "#"
                    changes += 1
                }
            case "#":
                if shouldChangeStateVisible(seat: seat, oc: occs[i][j]) {
                    deltas[i][j] = -1
                    seat = "L"
                    changes += 1
                }
            default:
                continue
            }
            matrix[i][j] = seat
        }
    }
    occs = updateOccsVisible(occs: occs, deltas: deltas, visibility: visibility)

    return changes
}

func buildOccupancyMatrix(matrix: [[String]]) -> [[Int]] {
    var res = matrix.map{ Array.init(repeating: 0, count: $0.count) }

    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            let isOcc = matrix[i][j] == "#"
            if !isOcc {
                continue
            }
            for k in max(i-1, 0)...min(i+1, matrix.count-1) {
                for l in max(j-1, 0)...min(j+1, matrix[i].count-1) {
                    if (i != k || j != l) {
                        res[k][l] += 1
                    }
                }
            }
        }
    }

    return res
}


func prob1() -> Int {
    var (res, changes) = (lines, 1)
    var occs = buildOccupancyMatrix(matrix: res)

    while (changes > 0) {
        changes = simLoop(matrix: &res, occs: &occs)
        print("changes \(changes)")
    }

    return res.reduce(0) { (r, arr) -> Int in
        r + arr.filter{$0 == "#"}.count
    }
}

func buildOccupancyMatrixVisible(matrix: [[String]], visibility: [[[(Int, Int)]]]) -> [[Int]] {
    var res = matrix.map{ Array.init(repeating: 0, count: $0.count) }

    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            if matrix[i][j] != "#" {
                continue
            }
            let visibles = visibility[i][j]

            for v in visibles {
                if i != v.0 || j != v.1 {
                    res[v.0][v.1] += 1
                }
            }
        }
    }

    return res
}

func checkBounds(x: Int, y: Int, lx: Int, ly: Int) -> Bool {
    return x >= 0 && x < lx && y >= 0 && y < ly
}

func buildVisiblity(matrix: [[String]]) -> [[[(Int, Int)]]] {
    var deltas = [(Int, Int)]()
    for i in -1...1 {
        for j in -1...1 {
            if i != 0 || j != 0 {
                deltas.append((i, j))
            }
        }
    }
    var ret = [[[(Int, Int)]]]()
    let (lx, ly) = (matrix.count, matrix[0].count)

    for i in 0..<lx {
        var row = [[(Int, Int)]]()
        for j in 0..<ly {
            var arr = [(Int, Int)]()
            for d in deltas {
                var neighbor = ""
                var (x, y) = (i+d.0, j+d.1)
                while checkBounds(x:x, y:y, lx:lx, ly:ly) {
                    if matrix[x][y] != "." {
                        neighbor = matrix[x][y]
                        break
                    }
                    (x, y) = (x+d.0, y+d.1)
                }
                if neighbor != "" {
                    arr.append((x, y))
                }
            }
            row.append(arr)
        }
        ret.append(row)
    }

    return ret
}

func prob2() -> Int {
    var (res, changes) = (lines, 1)
    let visibility = buildVisiblity(matrix: res)

    var occs = buildOccupancyMatrixVisible(matrix: res, visibility: visibility)

    while (changes > 0) {
        changes = simLoopVisible(matrix: &res, occs: &occs, visibility: visibility)
        print("changes \(changes)")
    }

    return res.reduce(0) { (r, arr) -> Int in
        r + arr.filter{$0 == "#"}.count
    }
}

print(prob2())

