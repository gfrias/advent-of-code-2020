import Foundation

//let filepath = Bundle.main.path(forResource: "day14", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day14.playground/Resources/day14.txt"

let operations = try String(contentsOfFile: filepath)
                        .split(whereSeparator: \.isNewline)
                        .compactMap{ Operation.build($0) }

struct Mask {
    let floatMasks: [[UInt64]]

    init(_ str: String) {
        let floats:[UInt64] = str.enumerated().filter{$0.element == "X"}
                                      .map{UInt64(35-$0.offset)}.map {1 << $0}

        let positions = str.enumerated().filter{$0.element == "1"}.map{35-$0.offset}

        let mask1 = positions.reduce(UInt64(0), { (res, pos) -> UInt64 in
            return res | (1<<pos)
        })

        var floatMasks = Array.init(repeating: [mask1, ~UInt64(0)],
                                    count: 1 << floats.count)

        for i in 0..<floatMasks.count {
            for j in 0..<floats.count {
                let pow = 1 << (j+1)
                let val = (i % pow)

                if val < pow/2 {
                    floatMasks[i][0] = floatMasks[i][0] | floats[j]
                } else {
                    floatMasks[i][1] = floatMasks[i][1] & (~floats[j])
                }
            }
        }

        self.floatMasks = floatMasks
    }

    func apply(val:UInt64) -> [UInt64] {
        return floatMasks.map { (val|$0[0]) & $0[1] }
    }
}

enum Operation {
    case mask(Mask)
    case mem(UInt64, UInt64)

    static func build(_ str: String.SubSequence) -> Operation? {
        let parts = str.replacingOccurrences(of: " = ", with: "=")
                        .split(separator: "=")
                        .map{String($0)}

        if parts[0] == "mask" {
            return .mask(Mask(parts[1]))
        } else if parts[0].hasPrefix("mem") {
            let address = String(parts[0].replacingOccurrences(of: "mem[", with: "")
                                         .replacingOccurrences(of: "]", with: ""))
            return .mem(UInt64(address)!, UInt64(parts[1])!)
        } else {
            return nil
        }
    }
}

func prob2() -> UInt64 {
    var mem = [UInt64: UInt64]()
    var mask: Mask? = nil

    for op in operations {
        switch op {
        case .mask(let m):
            mask = m
        case .mem(let addr, let val):
            if let mask = mask {
                for addr in mask.apply(val: addr) {
                    mem[addr] = val
                }
            } else {
                mem[addr] = val
            }
        }
    }

    return mem.map{$0.value}.reduce(0,+)
}

print(prob2())


