import Foundation

let filepath = Bundle.main.path(forResource: "day6", ofType: "txt")!

let lines = try String(contentsOfFile: filepath)
                        .replacingOccurrences(of: "\n\n", with: "@")
                        .replacingOccurrences(of: "\n", with: " ")
                        .split(separator: "@")
                        .map { String($0) }

func yesPerGroup(_ str: String) -> Int {
    var answers = [Character:Int]()
    let group = str.split(separator: " ")

    for person in group {
        for c in person {
            answers[c] = (answers[c] ?? 0) + 1
        }
    }

    return answers.filter{$0.value == group.count}.count
}

func prob1() -> Int {
    return lines.map { yesPerGroup($0) }.reduce(0, +)
}

//print(yesPerGroup("abc"))
//print(yesPerGroup("a b c"))
//print(yesPerGroup("ab ac"))
//print(yesPerGroup("a a a a"))
//print(yesPerGroup("b"))

print(prob1())

