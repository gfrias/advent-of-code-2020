import Foundation

let str = "389125467"
//let str = "963275481"

func parse(str: String) -> [Int] {
    str.compactMap { Int(String($0)) }
}

func prob1(str: String) -> Int {
    var arr = parse(str: str)
    let count = arr.count
    var curr = 0

    for _ in 0..<100 {
        print("cups:", terminator:"")
        for i in 0..<arr.count {
            if i == curr {
                print("(\(arr[i])) ", terminator:"")
            } else {
                print("\(arr[i]) ", terminator:"")
            }
        }
        print("")

        let lbl = arr[curr]
        var picked = [Int]()
        for i in 1...3 {
            let idx = (curr+i) % arr.count
            picked.append(arr[idx])
            arr[idx] = 0
        }
        print("pickup: \(picked)")
        arr = arr.filter{$0 != 0}


        let mxIdx = arr.enumerated().max { $0.element < $1.element }!.offset

        let mnIdx = arr.enumerated().filter { $0.element < lbl }
                                    .max { $0.element < $1.element }?.offset

        let destIdx = mnIdx ?? mxIdx

        print("destination: \(arr[destIdx])")

        var aux = [Int]()
        var idx = 0
        for it in arr {
            if it == lbl {
                curr = idx
            }
            aux.append(it)
            if idx == destIdx {
                for el in picked {
                    aux.append(el)
                    idx += 1
                }
            }
            idx += 1
        }
        arr = aux
        print(arr)

        curr = (curr + 1) % count
        print("")
    }

    print(arr)

    return 0
}
func extend(_ arr:[Int]) -> [Int] {
    let mx = arr.max()!
    return arr + Array((mx+1...1000000))
}

func prob2(str: String) -> Int {
    var arr = parse(str: str)

    arr = extend(arr)
//    let n = 10000000
    let n = 100

    let count = arr.count
    var curr = 0
    var picked = Array(repeating: 0, count: 3)
    var aux = Array(repeating: 0, count: count)
    let maxVal = arr.max()!

    for i in 0..<n {
        print(i)
        let lbl = arr[curr]

        for i in 0..<picked.count {
            let idx = (curr+i+1) % arr.count
            picked[i] = arr[idx]
            arr[idx] = 0
        }

        var targetVal = lbl - 1
        var maxTargetVal = maxVal

        for val in picked.sorted().reversed() {
            if val == targetVal {
                targetVal -= 1
            }
            if val == maxTargetVal {
                maxTargetVal -= 1
            }
        }

        var destIdx = arr.firstIndex(of: targetVal > 0 ? targetVal: maxTargetVal)!

        var idx = 0
        for it in arr {
            if it == lbl {
                curr = idx
            }
            if it == 0 {
                destIdx -= 1
                continue
            }
            aux[idx] = it
            if idx == destIdx {
                for el in picked {
                    idx += 1
                    aux[idx] = el
                }
            }
            idx += 1
        }
        arr = aux

        curr = (curr + 1) % count
    }

    print(arr)

    return 0
}

print(prob2(str: str))
