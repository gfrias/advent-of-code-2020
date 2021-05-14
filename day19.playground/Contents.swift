import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day19.playground/Resources/day19.txt"

let lines = try String(contentsOfFile: filepath)
                        .split(whereSeparator: \.isNewline)
                        .map{String($0)}

class Rule {
    func compile() -> String {
        assert(false, "not implemented")
        return ""
    }
}

class OrRule: Rule {
    var rules: [Rule] = []

    func setRules(rules: [Rule]) {
        self.rules = rules
    }
    override func compile() -> String {
        return "(" + rules.map { $0.compile() }.joined(separator: "|") + ")"
    }
}

class AndRule: Rule {
    let parent: Rule?
    let rules: [Rule]

    init(parent: Rule, rules: [Rule]) {
        self.parent = parent
        self.rules = rules
    }

    override func compile() -> String {
        let isRec = self.rules.contains{$0 === self.parent}

        if !isRec {
            return self.rules.map { $0.compile() }.reduce("", +)
        }

        var ret = [""]
        var idx = 0

        for i in 0..<rules.count {
            if rules[i] === self.parent {
                idx += 1
                ret.append("")
            } else {
                ret[idx] += rules[i].compile()
            }
        }

        ret = ret.filter{$0 != ""}
        var arr = [String]()

        for i in 2..<10 {
            var s = "("
            for r in ret {
                s += "((\(r)){\(i)})"
            }
            s += ")"
            arr.append(s)
        }
        let str = arr.joined(separator: "|")

        return "(\(str))"
    }
}

class LiteralRule: Rule {
    let str: String

    init(str: String) {
        self.str = str
    }
    override func compile() -> String {
        return str
    }
}

func buildRules(strRulesDict: [Int : [[String]]]) -> String {
    var rulesDict = [Int: OrRule]()

    for (id, _) in strRulesDict {
        rulesDict[id] = OrRule()
    }

    for (id, strRulesArr) in strRulesDict {
        var orArr = [Rule]()
        for strRulArr in strRulesArr {
            var andArr = [Rule]()
            for str in strRulArr {
                if let val = Int(str) {
                    andArr.append(rulesDict[val]!)
                } else {
                    andArr.append(LiteralRule(str: str))
                }
            }
            orArr.append(AndRule(parent: rulesDict[id]!, rules: andArr))
        }
        rulesDict[id]!.setRules(rules: orArr)
    }

    return "^" + rulesDict[0]!.compile() + "$"
}

func splitLines(lines:[String]) -> ([String], [String]) {
    let strRules = lines.filter{$0.contains(":")}
    let words = lines.filter{!$0.contains(":")}

    return (strRules, words)
}

func parseRuleLines(lnStrRules:[String]) -> [Int:[[String]]] {
    var ret = [Int:[[String]]]()

    for ln in lnStrRules {
        let comp = ln.components(separatedBy: ": ")
        let id = Int(comp[0])!

        let compRules = comp[1].components(separatedBy: " | ")

        var rules = [[String]]()
        for c in compRules {
            rules.append(c.replacingOccurrences(of: "\"", with: "")
                            .split(separator: " ").map { String($0) })
        }
        ret[id] = rules
    }

    return ret
}

func prob1(lines: [String]) -> Int {
    let (lnStrRules, words) = splitLines(lines: lines)
    let strRulesDict = parseRuleLines(lnStrRules: lnStrRules)
    let pttrn = buildRules(strRulesDict: strRulesDict)

    let regex = try! NSRegularExpression(pattern: pttrn)

    var count = 0
    for w in words {
        let range = NSRange(location: 0, length: w.utf16.count)
        if regex.firstMatch(in: w, options: [], range: range) != nil {
            print(w)
            count += 1
        }

    }
    return count
}

print(prob1(lines: lines))
