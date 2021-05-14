import Foundation

let filepath = Bundle.main.path(forResource: "day5", ofType: "txt")!

let lines = try String(contentsOfFile: filepath)
                .split(whereSeparator: \.isNewline)
                .map { String($0) }

func getSeatID(_ str: String) -> Int {
    var rgRows = 0...127
    var rgCols = 0...7

    for c in str {
        switch(c) {
        case "F":
            rgRows = rgRows.first!...(rgRows.first!+rgRows.count/2)
        case "B":
            rgRows = (rgRows.first!+rgRows.count/2)...rgRows.last!
        case "L":
            rgCols = rgCols.first!...(rgCols.first!+rgCols.count/2)
        case "R":
            rgCols = (rgCols.first!+rgCols.count/2)...rgCols.last!
        default:
            break
        }
    }

    return rgRows.first!*8 + rgCols.first!
}

func prob1() -> Int {
    return lines.map { getSeatID($0) }.max() ?? -1
}

func prob2() -> Int {
    let seats = lines.map { getSeatID($0) }
        .reduce(Set<Int>()) { (res, id) -> Set<Int> in
            var result = res
            result.insert(id)
            return result
        }

    let maxSeat = seats.max() ?? -1

    for i in 0...maxSeat {
        if !seats.contains(i) &&
            seats.contains(i+1) &&
            seats.contains(i-1) {
            return i
        }
    }

    return -1

}

print(prob2())
//print(getSeatID("FBFBBFFRLR"))
