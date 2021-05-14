import Foundation

//let filepath = Bundle.main.path(forResource: "ex2", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day17.playground/Resources/day17.txt"

let lines = try String(contentsOfFile: filepath)
                        .split(whereSeparator: \.isNewline)
                        //.map{ Array($0).map { [String($0)]} }
                        .map{Array($0).map { $0 == "#" ? 1: 0}}
typealias Grid2D = [[Int]]
typealias Grid = [[[[Int]]]]
typealias Size = (Int, Int, Int, Int) //y, x, z, w
typealias Coord = (Int, Int, Int, Int) //y, x, z, w
let STEP = 1

func sizeOf(grid: Grid) -> Size {
    return (grid.count, grid[0].count, grid[0][0].count, grid[0][0][0].count)
}

func initGrid(size:Size) -> Grid {
    Array.init(repeating: Array.init(repeating: Array.init(repeating: Array.init(repeating: 0,
                                                                                 count: size.3),
                                                           count: size.2),
                                     count: size.1),
               count: size.0)
}

func buildGrid(grid2D:Grid2D) -> Grid {
    var ret = grid2D.map({ row in
        row.map { _ in [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]] }
    })


    for i in 0..<grid2D.count {
        for j in 0..<grid2D[0].count {
            ret[i][j][1][1] = grid2D[i][j]
        }
    }

    assert(grid2D.count == ret.count)
    assert(grid2D[0].count == ret[0].count)
    assert(4 == ret[0][0].count)
    assert(4 == ret[0][0][0].count)


    return ret
}

func expandGrid(grid: Grid) -> Grid {
    let (size_y, size_x, size_z, size_w) = sizeOf(grid: grid)

    var ret = initGrid(size: (size_y+STEP*2, size_x+STEP*2, size_z+STEP*2, size_w+STEP*2))

    for i in STEP..<ret.count-STEP {
        for j in STEP..<ret[i].count-STEP {
            for k in STEP..<ret[i][j].count-STEP {
                for l in STEP..<ret[i][j].count-STEP {
                    ret[i][j][k][l] = grid[i-STEP][j-STEP][k-STEP][l-STEP]
                }
            }
        }
    }

    return ret
}

func activeNeighbours(grid:Grid, size:Size, coord: Coord) -> Int {
    let (size_y, size_x, size_z, size_w) = size
    let (y, x, z, w) = coord

    var ret = 0

    for i in max(y-1, 0)...min(y+1, size_y-1) {
        for j in max(x-1,0)...min(x+1, size_x-1) {
            for k in max(z-1,0)...min(z+1, size_z-1) {
                for l in max(w-1,0)...min(w+1, size_w-1) {
                    if (y != i || x != j || z != k || w != l) && grid[i][j][k][l] == 1 {
                        ret += 1
                    }
                }
            }
        }
    }
    return ret
}

func buildActiveCountGrid(grid: Grid) -> Grid {
    let size = sizeOf(grid: grid)
    let (size_y, size_x, size_z, size_w) = size

    var ret = initGrid(size: size)

    for i in 0..<size_y {
        for j in 0..<size_x {
            for k in 0..<size_z {
                for l in 0..<size_w {
                    ret[i][j][k][l] = activeNeighbours(grid: grid,
                                                    size: size,
                                                    coord: (i,j,k, l))
                }
            }
        }
    }

    return ret
}

func printGrid(grid:Grid) {
    let size = sizeOf(grid: grid)
    let (size_y, size_x, size_z, size_w) = size

    let middle = (size_z+1)/2-1
    for z in 0..<size_z {
        for w in 0..<size_w {
            var ret = [String]()
            var count = 0

            for y in 0..<size_y {
                var s = ""
                for x in 0..<size_x {
                    s += grid[y][x][z][w] == 1 ? "#" : "."
                    count += grid[y][x][z][w]
                }
                ret.append(s)
            }

            if count > 0 {
                print("z=\(z-middle) w=\(w-middle)")
                for l in ret {
                    print(l)
                }
                print(" ")
            }
        }
    }
}

func isActiveEdge(grid:Grid, coord:Coord) -> Bool {
    let (i, j, k, l) = coord
    return (i == 0 || j == 0 || k == 0 || l == 0 ||
                i == grid.count-1 || j == grid[0].count-1 || k == grid[0][0].count-1 || l == grid[0][0][0].count-1)
                && grid[i][j][k][l] == 1
}

func prob1() -> Int {
    var grid = expandGrid(grid: buildGrid(grid2D:lines))
    var countGrid = buildActiveCountGrid(grid: grid)
    var actives = 0

    print("lines")
    for l in lines {
        print(l)
    }

    for i in 0..<6 {
        actives = 0
        print("i=\(i)")
        print("------")
        printGrid(grid: grid)

        var newGrid = initGrid(size: sizeOf(grid: grid))

        var expand = false
        //calculate updates
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                for k in 0..<grid[0][0].count {
                    for l in 0..<grid[0][0][0].count {
                        newGrid[i][j][k][l] = grid[i][j][k][l]
                        if grid[i][j][k][l] == 1 {
                            newGrid[i][j][k][l] = (countGrid[i][j][k][l] == 2 || countGrid[i][j][k][l] == 3) ? 1: 0
                        } else {
                            newGrid[i][j][k][l] = (countGrid[i][j][k][l] == 3) ? 1: 0
                        }
                        if isActiveEdge(grid:newGrid, coord:(i,j,k,l)) {
                            expand = true
                        }
                        actives += newGrid[i][j][k][l]
                    }
                }
            }
        }

        if expand {
            grid = expandGrid(grid: newGrid)
        } else {
            grid = newGrid
        }
        countGrid = buildActiveCountGrid(grid: grid)
    }

    print("Final")
    print("-----")
    printGrid(grid: grid)

    return actives
}

print(prob1())
