import Foundation

let filepath = Bundle.main.path(forResource: "day12", ofType: "txt")!

let lines = try String(contentsOfFile: filepath)
    .split(whereSeparator: \.isNewline)
    .map{ Command($0) }

struct Command {
    let dir: String
    let amount: Int

    init(_ str: String.SubSequence) {
        let s = String(str)

        dir = String(s.prefix(1))
        amount = Int(String(s.replacingOccurrences(of: dir, with: ""))) ?? 0
    }
}

struct Boat {
    var y: Int
    var x: Int

    var waypoint: (Int, Int)

    mutating func move(_ c: Command) {
        switch c.dir {
        case "N":
            waypoint.0 -= c.amount
        case "S":
            waypoint.0 += c.amount
        case "W":
            waypoint.1 -= c.amount
        case "E":
            waypoint.1 += c.amount
        case "F":
            (y, x) = (y+waypoint.0*c.amount,
                      x+waypoint.1*c.amount)
        case "R":
            let times = c.amount/90
            for i in 0..<times {
                waypoint = (waypoint.1, -waypoint.0)
            }
        case "L":
            let times = c.amount/90
            for i in 0..<times {
                waypoint = (-waypoint.1, waypoint.0)
            }
        default:
            print("assert")
            assert(false)
        }
    }
    func dist() -> Int {
        abs(self.x) + abs(self.y)
    }
}

var boat = Boat(y: 0, x: 0, waypoint: (-1, 10))
var i = 0
for c in lines {
    print(c)
    boat.move(c)
    print(i, c, boat)
    i += 1
}

print(boat.dist())


