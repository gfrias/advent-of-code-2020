import Foundation

//let str = "389125467"
let str = "963275481"

class Node:CustomStringConvertible {
    let val: Int
    var next: Node?

    init (val: Int, next: Node? = nil) {
        self.val = val
        self.next = next
    }

    var description: String {
        get {
            if let next = next {
                if next.val == 2 {
                    return "Node(\(val))->back to \(next.val)"
                }
                return "Node(\(val))->\(next)"
            } else {
                return "Node(\(val))"
            }
        }
    }
}

func parse(str: String) -> [Int] {
    str.compactMap { Int(String($0)) }
}

func build(arr:[Int]) -> (Node, [Int:Node]) {
    var next: Node? = nil
    var last: Node? = nil

    var table = [Int:Node]()

    for n in arr.reversed() {
        next = Node(val: n, next: next)
        if last == nil {
            last = next
        }
        table[n] = next
    }
    last?.next = next

    return (next!, table)
}

func extend(_ arr:[Int]) -> [Int] {
    let mx = arr.max()!
    return arr + Array((mx+1...1000000))
}

func prob2(str: String) -> Int {
    var arr = parse(str: str)
    arr = extend(arr)

    let maxVal = arr.max()!
    var (current, table) = build(arr: arr)

    let n = 10000000
//    let n = 100

    for i in 0..<n {
        if i % 100000 == 0 {
            print("\(100*i/n)% (\(i))")
        }
        let picked1 = current.next!
        let picked2 = picked1.next!
        let picked3 = picked2.next!

        current.next = picked3.next

        var targetVal = current.val - 1
        var targetMaxVal = maxVal

        for val in [picked1.val, picked2.val, picked3.val].sorted().reversed() {
            if val == targetVal {
                targetVal -= 1
            }
            if val == targetMaxVal {
                targetMaxVal -= 1
            }
        }
        if targetVal < 1 {
            targetVal = targetMaxVal
        }

        let destination = table[targetVal]!

        let tmp = destination.next
        destination.next = picked1
        picked3.next = tmp

        current = current.next!
    }

    current = table[1]!

    let v1 = current.next!.val
    let v2 = current.next!.next!.val

    return v1*v2
}

print(prob2(str: str))
