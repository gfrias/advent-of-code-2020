import Foundation

//let filepath = Bundle.main.path(forResource: "day16", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day16.playground/Resources/day16.txt"

let lines = try String(contentsOfFile: filepath)
                    .split(whereSeparator: \.isNewline)
                    .map { String($0) }

typealias Rule = (String, [ClosedRange<Int>])

func splitLines(lines:[String]) -> ([String], String, [String]) {
    var rules = [String]()
    var idx = 0
    for i in 0..<lines.count {
        if lines[i].hasPrefix("your ticket:") {
            idx = i+1
            break
        }
        rules.append(lines[i])
    }
    let myTicket = lines[idx]

    assert(lines[idx+1].hasPrefix("nearby tickets:"))

    var tickets = [String]()
    for i in idx+2..<lines.count {
        tickets.append(lines[i])
    }

    return (rules, myTicket, tickets)
}

func parseRules(strRules:[String]) -> [Rule] {
    var ret = [Rule]()

    for s in strRules {
        let parts = s.components(separatedBy: ": ")
        let field = parts[0]
        let strRanges = parts[1].components(separatedBy: " or ")

        var ranges = [ClosedRange<Int>]()
        for t in strRanges {
            let bounds = t.split(separator: "-").compactMap{ Int($0) }
            let r = bounds[0]...bounds[1]
            ranges.append(r)
        }

        ret.append((field, ranges))
    }

    return ret
}

func parseTicket(str: String) -> [Int] {
    return str.split(separator: ",").compactMap { Int($0) }
}

func isValInRule(val: Int, rule: Rule) -> Bool {
    let (_, ranges) = rule

    for range in ranges {
        if range.contains(val) {
            return true
        }
    }
    return false
}

func isValInRules(val: Int, rules:[Rule]) -> Bool {
    for rule in rules {
        if isValInRule(val: val, rule: rule) {
            return true
        }
    }
    return false
}

func errRate(ticket:[Int], rules:[Rule]) -> Int? {
    let errors = ticket.filter{!isValInRules(val: $0, rules: rules)}

    if errors.count == 0 {
        return nil
    }
    return errors.reduce(0, +)
}

func prob1() -> Int {
    let (strRules, _, strTickets) = splitLines(lines: lines)
    let rules = parseRules(strRules: strRules)
    let tickets = strTickets.map { parseTicket(str: $0) }

    return tickets.compactMap { errRate(ticket: $0, rules: rules) }.reduce(0, +)
}

func prob2() -> Int {
    print("parsing")
    let (strRules, strMyTicket, strTickets) = splitLines(lines: lines)
    let rules = parseRules(strRules: strRules)
    let myTicket = parseTicket(str: strMyTicket)
    let tickets = strTickets.map { parseTicket(str: $0) }

    print("filtering tickets")
    let validTickets = tickets.filter { errRate(ticket: $0, rules: rules) == nil }

    var rulesByVal = Array.init(repeating: Set<Int>(0..<rules.count), count: myTicket.count)

    print("filtering rules")
    for ticket in validTickets {
        for idxVal in 0..<ticket.count {
            var tmpRulesByThisVal = rulesByVal[idxVal]
            for idxRule in rulesByVal[idxVal] {
                let rule = rules[idxRule]
                if !isValInRule(val: ticket[idxVal], rule: rule) {
                    tmpRulesByThisVal.remove(idxRule)
                }
            }
            rulesByVal[idxVal] = tmpRulesByThisVal
        }
    }

    assert(rulesByVal.map { $0.count }.allSatisfy { $0 >= 1 } )
    print("removing single rules from set")
    var availRules = Set<Int>(0..<rules.count)
    for set in rulesByVal {
        if set.count == 1 {
            availRules.remove(set.first!)
            print("rule removed")
        }
    }

    print("removing rules by intersection")
    var changes = true
    while changes {
        changes = false
        for i in 0..<rulesByVal.count {
            var set = rulesByVal[i]
            if set.count > 1 {
                set = set.intersection(availRules)
                if set.count == 1 {
                    print("intersect")
                    availRules.remove(set.first!)
                } else {
                    changes = true
                }
            }
            rulesByVal[i] = set
        }
    }
    assert(rulesByVal.map { $0.count }.filter { $0 == 1 }.count == rules.count )

    let fieldRulesIdxs = rulesByVal.map { $0.first! }.map { $0 }
    print("multiplying")
    return myTicket.enumerated().filter {
        rules[fieldRulesIdxs[$0.offset]].0.hasPrefix("departure")
    }.map{$0.element}.reduce(1, *)
}

print(prob2())
