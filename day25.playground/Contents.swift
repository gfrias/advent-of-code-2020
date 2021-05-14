import Foundation

//let filepath = Bundle.main.path(forResource: "ex", ofType: "txt")!
let filepath = "/Users/gfrias/advent/day25.playground/Resources/day25.txt"

let keys = try String(contentsOfFile: filepath).replacingOccurrences(of: " ", with: "")
                        .split(whereSeparator: \.isNewline)
                        .compactMap{ Int($0) }

let mod = 20201227

func getLoopSize(_ key: Int) -> Int {
    let subject = 7
    
    var i = 0
    var val = 1
    while val != key {
        val = val * subject
        val = val % mod
        i += 1
    }
    return i
}

func calcEncryptionKey(key: Int, loopSize: Int) -> Int {
    var val = 1
    for _ in 0..<loopSize {
        val = val * key
        val = val % mod
    }
    return val
}

func prob1(keys: [Int]) -> Int {
    let (cardKey, doorKey) = (keys[0], keys[1])
    let (loopSizeCard, loopSizeDoor) = (getLoopSize(cardKey), getLoopSize(doorKey))

    let encryptKeyDoor = calcEncryptionKey(key: doorKey, loopSize: loopSizeCard)
    let encryptKeyCard = calcEncryptionKey(key: cardKey, loopSize: loopSizeDoor)

    assert(encryptKeyDoor == encryptKeyCard)

    return encryptKeyDoor
}

print(prob1(keys: keys))
