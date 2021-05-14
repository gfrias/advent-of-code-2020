import Foundation

struct Document {
    static let fields = Set<String>(["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"])
    static let eyes = Set<String>(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

    let byr: Int //(Birth Year) - four digits; at least 1920 and at most 2002.
    let iyr: Int //(Issue Year) - four digits; at least 2010 and at most 2020.
    let eyr: Int //(Expiration Year) - four digits; at least 2020 and at most 2030.
    let hgt: Height //(Height) - a number followed by either cm or in:
    //  If cm, the number must be at least 150 and at most 193.
    //  If in, the number must be at least 59 and at most 76.

    let hcl: String //(Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    let ecl: String //(Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    let pid: String //a nine-digit number, including leading zeroes.

    init?(_ dict: Dictionary<String, String>) {
        if dict.count != Document.fields.count {
            return nil
        }
        guard let byr = Int(dict["byr"] ?? ""), byr >= 1920, byr <= 2002 else {
            return nil
        }
        guard let iyr = Int(dict["iyr"] ?? ""), iyr >= 2010, iyr <= 2020 else {
            return nil
        }
        guard let eyr = Int(dict["eyr"] ?? ""), eyr >= 2020, eyr <= 2030 else {
            return nil
        }
        guard let hgt = Height(dict["hgt"] ?? "") else {
            return nil
        }
        guard let hcl = dict["hcl"], Document.regMatch(string: hcl, pattern: "^#([0-9]|[a-f]){6}$") else {
            return nil
        }
        guard let ecl = dict["ecl"], Document.eyes.contains(ecl) else {
            return nil
        }
        guard let pid = dict["pid"], Document.regMatch(string: pid, pattern: "^[0-9]{9}$") else {
            return nil
        }

        self.pid = pid
        self.ecl = ecl
        self.hcl = hcl
        self.hgt = hgt

        self.byr = byr
        self.iyr = iyr
        self.eyr = eyr
    }

    static private func regMatch(string:String, pattern:String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: string, options: [], range: range) != nil
    }

    struct Height {
        let val: Int
        let unit: String

        init?(_ str: String) {
            if str.hasSuffix("in"),
               let num = Int(String(str.replacingOccurrences(of: "in", with: ""))),
                    num >= 59, num <= 76 {
                self.val = num
                self.unit = "in"
            } else if str.hasSuffix("cm"),
                    let num = Int(String(str.replacingOccurrences(of: "cm", with: ""))),
                    num >= 150, num <= 193 {
                self.val = num
                self.unit = "cm"
            } else {
                return nil
            }
        }
    }
}

let filepath = Bundle.main.path(forResource: "day4", ofType: "txt")!

let lines = try String(contentsOfFile: filepath).replacingOccurrences(of: "\n\n", with: "@").replacingOccurrences(of: "\n", with: " ").split(separator: "@").map { String($0) }

func prob2() -> Int {
    var valid = 0
    for ln in lines {
        var doc = Dictionary<String, String>()
        let parts = ln.split(separator: " ")

        for p in parts {
            let values = p.split(separator: ":")
            if values.count == 2 {
                let key = String(values[0]), val = String(values[1])
                if Document.fields.contains(key) {
                    doc[key] = val
                }
            }
        }
        if let _ = Document(doc) {
            valid += 1
        }
    }
    return valid
}

func prob1b() -> Int {
    lines.map {
        $0.split(separator: " ").map {
            String($0.split(separator: ":").first ?? "")
        }.filter{Document.fields.contains($0)}.count
    }.filter{$0 == Document.fields.count}.count
}

print(prob2())
