import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day22.playground/Resources/day22.txt"

let lines = try String(contentsOfFile: filepath)
                        .split(whereSeparator: \.isNewline)
                        .map{String($0)}

func splitDecks(lines:[String]) -> [[Int]] {
    var ret = [[Int]]()

    var arr = [Int]()

    for ln in lines {
        if ln.contains("Player") {
            if arr.count > 0 {
                ret.append(arr)
            }
            arr = [Int]()
        } else {
            arr.append(Int(ln)!)
        }
    }
    ret.append(arr)

    return ret
}

func prob1(lines: [String]) -> Int {
    let decks = splitDecks(lines: lines)
    var (d1, d2) = (decks[0], decks[1])

    while d1.count > 0 && d2.count > 0 {
        let top1 = d1.removeFirst()
        let top2 = d2.removeFirst()

        if top1 > top2 {
            d1.append(top1)
            d1.append(top2)
        } else if top2 > top1 {
            d2.append(top2)
            d2.append(top1)
        } else {
            assert(false, "both player's cards are equal \(top1) \(top2)")
        }
    }

    var d = d1
    if d1.count > 0 {
        d = d1
    } else if d2.count > 0 {
        d = d2
    } else {
        assert(false, "both players are out of cards")
    }

    return deckScore(deck: d)
}

func deckScore(deck:[Int]) -> Int {
    deck.enumerated().map { (deck.count - $0.offset)*$0.element }.reduce(0, +)
}

func deckToStr(deck:[Int]) -> String {
    deck.map { String($0) }.joined(separator: ",")
}

func decksToConfig(deck1: [Int], deck2: [Int]) -> String {
    deckToStr(deck: deck1) + " : " + deckToStr(deck: deck2)
}

func recursiveCombatGame(deck1:[Int], deck2:[Int]) -> (Int) {
    var (d1, d2) = (deck1, deck2)

    var localHistory = Set<String>()

    while d1.count > 0 && d2.count > 0 {
        let conf = decksToConfig(deck1: d1, deck2: d2)
        if localHistory.contains(conf) {
            return -deckScore(deck: d1)
        }
        let top1 = d1.removeFirst()
        let top2 = d2.removeFirst()

        var winner = 0
        if d1.count >= top1 && d2.count >= top2 {
            let arr1 = Array(d1.prefix(top1))
            let arr2 = Array(d2.prefix(top2))
            winner = recursiveCombatGame(deck1: arr1, deck2: arr2) < 0 ? 1: 2
        } else {
            if top1 > top2 {
                winner = 1
            } else if top2 > top1 {
                winner = 2
            } else {
                assert(false)
            }
        }

        assert(winner != 0)
        if winner == 1 {
            d1.append(top1)
            d1.append(top2)
        } else {
            d2.append(top2)
            d2.append(top1)
        }

        localHistory.insert(conf)
    }

    if d1.count > 0 {
        return -deckScore(deck: d1)
    } else {
        return deckScore(deck: d2)
    }
}

func prob2(lines: [String]) -> Int {
    let decks = splitDecks(lines: lines)
    let (d1, d2) = (decks[0], decks[1])

    return recursiveCombatGame(deck1: d1, deck2: d2)
}

print(prob2(lines: lines))
