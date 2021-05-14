import Foundation

let filepath = Bundle.main.path(forResource: "day7", ofType: "txt")!

let lines = try String(contentsOfFile: filepath)
                .split(whereSeparator: \.isNewline)
                .map { String($0) }

func removeRegex(str: String, pattern:String) -> String {
    if let regex = try? NSRegularExpression(pattern: pattern) {
        let range = NSRange(location: 0, length: str.count)
        return regex.stringByReplacingMatches(in: str, options: [], range: range, withTemplate: "")
    }
    return str
}

struct Bag: Hashable {
    let count: Int
    let color: String

    private init(count: Int, color: String) {
        self.count = count
        self.color = color
    }

    init?(_ subSeq: String.SubSequence) {
        var count = 1
        let s = removeRegex(str: String(subSeq), pattern: " bags?\\.?")

        let stringArray = s.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for item in stringArray {
            if let number = Int(item) {
                count = number
            }
        }
        let t = removeRegex(str: s, pattern: "\\s*(\\d+)\\s+")

        if t == "no other" {
            return nil
        }
        self.color = t
        self.count = count
    }

    func unit() -> Bag {
        Bag(count: 1, color: self.color)
    }
    func mult(_ m: Int) -> Bag {
        Bag(count: self.count*m, color: self.color)
    }
}

func bagColor(_ subSeq: String.SubSequence) -> String {
    let s = removeRegex(str: String(subSeq), pattern: "\\s*\\d+\\s+")
    return removeRegex(str: s, pattern: " bags?\\.?")
}

func splitBagColors(_ str: String) -> [String] {
    let bags = str.replacingOccurrences(of: " contain ", with: ">")
                  .split(separator: ">")
    assert(bags.count == 2)

    return [bagColor(bags[0])] + bags[1].split(separator: ",").map { bagColor($0) }
}

func buildInvDict() -> [String:[String]] {
    var invDic = [String:[String]]()

    for ln in lines {
        let colors = splitBagColors(ln)
        for c in colors.dropFirst() {
            var lst = (invDic[c] ?? [])
            lst.append(colors.first!)
            invDic[c] = lst
        }
    }
    return invDic
}

func prob1() -> Int {
    let invDic = buildInvDict()

    var queue = ["shiny gold"]
    var containers = Set<String>()

    while !queue.isEmpty {
        let color = queue.removeFirst()
        for c in (invDic[color] ?? []) {
            if !containers.contains(c) {
                containers.insert(c)
                queue.append(c)
            }
        }
    }

    return containers.count
}

func splitBags(_ str: String) -> [Bag] {
    let bags = str.replacingOccurrences(of: " contain ", with: ">")
                  .split(separator: ">")
    assert(bags.count == 2)

    return [Bag(bags[0])!] + bags[1].split(separator: ",").compactMap{ Bag($0) }
}

func buildDict() -> [Bag:[Bag]] {
    var dic = [Bag:[Bag]]()

    for ln in lines {
        let bags = splitBags(ln)
        let first = bags.first!
        for b in bags.dropFirst() {
            var lst = (dic[first] ?? [])
            lst.append(b)
            dic[first] = lst
        }
    }
    return dic
}

func prob2(_ str: String.SubSequence) -> Int {
    let dic = buildDict()

    func find(_ bag: Bag) -> Int {
        print(bag)
        guard let bags = dic[bag.unit()], bags.count > 0 else {
            return bag.count
        }
        var count = bag.count
        for b in bags {
            count += find(b.mult(bag.count))
        }
        return count
    }

    return find(Bag(str)!)-1
}

print(prob2("1 shiny gold bag"))
//print(Bag("21 clear indigo bags."))
