import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day21.playground/Resources/day21.txt"

let lines = try String(contentsOfFile: filepath)
                        .split(whereSeparator: \.isNewline)
                        .map{String($0)}

func splitLines(lines:[String]) -> [([String], [String])] {
    var ret = [ ([String], [String]) ]()

    for ln in lines {
        let comp = ln.replacingOccurrences(of: ")", with: "").components(separatedBy: " (contains ")
        let ingredients = comp[0].components(separatedBy: " ")
        let allergens = comp[1].components(separatedBy: ", ")

        ret.append( (allergens, ingredients) )
    }

    return ret
}

func prob1(lines: [String]) -> Int {
    let arr = splitLines(lines: lines)

    var ingsByAl = [String:Set<String>]()
    var allIngredients = [String: Int]()

    for (allergens, ingredients) in arr {
        for al in allergens {
            let ings = Set<String>(ingredients)
            ingsByAl[al] = (ingsByAl[al] ?? ings).intersection(ings)
        }
        for ing in ingredients {
            allIngredients[ing] = (allIngredients[ing] ?? 0) + 1
        }
    }

    var total = 0
    var inertIngredients = Set<String>()
    for (ing, count) in allIngredients {
        if !ingsByAl.values.contains(where: {$0.contains(ing)}) {
            total += count
            inertIngredients.insert(ing)
        }
    }

    var changes = true

    while changes {
        changes = false
        for al in ingsByAl.keys {
            if let ings = ingsByAl[al], ings.count == 1, let ing = ings.first {
                for al2 in ingsByAl.keys.filter({$0 != al}) {
                    let oldCount = ingsByAl[al2]?.count ?? 0
                    ingsByAl[al2] = ingsByAl[al2]?.filter { $0 != ing }
                    let newCount = ingsByAl[al2]?.count ?? 0

                    if newCount < oldCount {
                        changes = true
                    }
                }
            }
        }
    }

    print(ingsByAl.keys.sorted().compactMap { ingsByAl[$0]?.first }.joined(separator: ","))

    return total
}

print(prob1(lines: lines))
