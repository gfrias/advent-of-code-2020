import Foundation

let filepath = Bundle.main.path(forResource: "day13", ofType: "txt")!

let lines = try String(contentsOfFile: filepath)
    .split(whereSeparator: \.isNewline)
    .map{ String($0) }

let timestamp = Int(lines[0])!
let busIDs = lines[1].split(separator: ",").filter{$0 != "x"}.compactMap{Int($0)}

let busSeq = lines[1].split(separator: ",").enumerated().filter{$0.element != "x"}.map{($0.0, Int($0.1)!)}

func prob1() -> Int {
    var mn = Int.max
    var mnBus = -1

    for id in busIDs {
        let time = ((timestamp/id+1)*id-timestamp)%id

        if time < mn {
            mn = time
            mnBus = id
        }
    }
    return mnBus*mn
}

func prob2() -> Int {
    var count = 0
    var startTime = 0

    while count != busSeq.count {
        count = 0
        var delta = 1
        for bus in busSeq {
            let (delay, id) = bus
            if (startTime+delay)%id == 0 {
                count += 1
                delta *= id
            }
        }
        
        if count == 0 {
            startTime += busSeq.first!.1
        } else if count < busSeq.count {
            startTime += delta
        }
    }

    return startTime
}

print(prob2())
