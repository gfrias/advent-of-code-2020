import Foundation

let filepath = Bundle.main.path(forResource: "day10", ofType: "txt")!

let lines = try String(contentsOfFile: filepath)
                .split(whereSeparator: \.isNewline)
                .compactMap{ Int($0) }

func prob1() -> (Int, Int) {
    let max = lines.max() ?? 0
    let adapters = lines.reduce(Set<Int>()) { (res, val) -> Set<Int> in
        var result = res
        result.insert(val)
        return result
    }

    var diffs = [0, 0, 0]
    var jolts = 0

    for i in 0...max {
        if adapters.contains(i) && i-jolts > 0 && i-jolts <= 3 {
            diffs[i-jolts-1] += 1
            jolts = i
        }
    }

    return (diffs[0]*(diffs[2]+1), jolts)
}

func prob2() -> Int {
    let adapters = lines.sorted()

    var counts = [Int:Int]()

    func find(last:Int, i: Int) -> Int {
        if i >= adapters.count {
            return 1
        }

        var ret = 0

        var j = i
        while j < adapters.count && adapters[j] <= last+3 {
            if let cnt = counts[j+1] {
                ret += cnt
            } else {
                counts[j+1] = find(last: adapters[j], i: j+1)
                ret += counts[j+1]!
            }
            j += 1
        }

        return ret
    }

    return find(last: 0, i: 0)
}

print(prob2())
