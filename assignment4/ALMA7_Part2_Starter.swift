// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge, lab, cargo, medbay, engine

    var evacuationPriority: Int {
        switch self {
        case .bridge: return 1
        case .medbay: return 2
        case .lab: return 3
        case .engine: return 4
        case .cargo: return 5
        }
    }
}

print("--- 1.1 Deck ---")
for deck in Deck.allCases {
    print("\(deck.rawValue): priority \(deck.evacuationPriority)")
}

// 1.2
enum AlarmLevel: Int {
    case green = 0
    case yellow, orange, red

    static func level(forTotalMass mass: Int) -> AlarmLevel {
        // every full 500 kg is one step, capped at 3 (red)
        let step = max(0, min(mass / 500, 3))
        return AlarmLevel(rawValue: step) ?? .red
    }
}

print("--- 1.2 AlarmLevel ---")
print("0 kg: \(AlarmLevel.level(forTotalMass: 0))")
print("940 kg: \(AlarmLevel.level(forTotalMass: 940))")
print("1500 kg: \(AlarmLevel.level(forTotalMass: 1500))")
print("4000 kg: \(AlarmLevel.level(forTotalMass: 4000))")


// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

// 2.2
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)
    guard let tag = parts.first else { return .unknown(raw: line) }

    switch tag {
    case "crate":
        guard parts.count == 3, let id = Int(parts[1]), let massKg = Int(parts[2]) else {
            return .unknown(raw: line)
        }
        return .crate(id: id, massKg: massKg)
    case "container":
        guard parts.count == 3, let massKg = Int(parts[2]) else {
            return .unknown(raw: line)
        }
        return .container(code: parts[1], massKg: massKg)
    case "livestock":
        guard parts.count == 4, let count = Int(parts[2]), let massPerUnit = Int(parts[3]) else {
            return .unknown(raw: line)
        }
        return .livestock(species: parts[1], count: count, massPerUnitKg: massPerUnit)
    default:
        return .unknown(raw: line)
    }
}

print("--- 2.2 parseEntry ---")
print(parseEntry("crate:101:120"))
print(parseEntry("livestock:lab mice:12:2"))
print(parseEntry("crate:104:abc"))

// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}

print("--- 2.3 mass ---")
var totalMass = 0
var unknownCount = 0
for line in rawManifest {
    let entry = parseEntry(line)
    totalMass += mass(of: entry)
    if case .unknown = entry {
        unknownCount += 1
    }
}
print("Total mass: \(totalMass) kg")
print("Unknown lines: \(unknownCount)")

let A = totalMass


// MARK: Level 3 · Crew Snapshots

// 3.1
// No init written: a struct gets a memberwise initializer automatically.
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(_ amount: Int) {
        oxygen = max(0, oxygen - amount)
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

print("--- 3.1 CrewSnapshot ---")
var testSnapshot = CrewSnapshot.rookie(named: "Test")
print("rookie: \(testSnapshot)")
testSnapshot.breathe(30)
testSnapshot.move(to: .engine)
print("after breathe(30) and move: \(testSnapshot)")
testSnapshot.breathe(500)
print("after breathe(500): oxygen = \(testSnapshot.oxygen)")
testSnapshot.reviveInMedbay()
print("after revive: \(testSnapshot)")

// 3.2
func makeRoster(from records: [(name: String, deck: String, oxygen: Int)]) -> [CrewSnapshot] {
    var roster: [CrewSnapshot] = []
    for record in records {
        guard let deck = Deck(rawValue: record.deck) else {
            print("Warning: \(record.name) is on unknown deck '\(record.deck)', skipped")
            continue
        }
        roster.append(CrewSnapshot(name: record.name, deck: deck, oxygen: record.oxygen))
    }
    return roster
}

print("--- 3.2 roster ---")
let crewRoster = makeRoster(from: crewData)
for member in crewRoster {
    print("\(member.name): \(member.deck.rawValue), oxygen \(member.oxygen)")
}
let checkedRoster = makeRoster(from: crewData + [(name: "Ghost", deck: "greenhouse", oxygen: 50)])
print("checked roster has \(checkedRoster.count) members")

// 3.3
func drainedCopy(_ snapshot: CrewSnapshot) -> Int {
    var local = snapshot
    local.breathe(30)
    return local.oxygen
}

func drain(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(30)
}

print("--- 3.3 value semantics ---")
var original = CrewSnapshot.rookie(named: "Aigerim")
var copy = original
print("1. before: original = \(original.deck), copy = \(copy.deck)")
copy.move(to: .cargo)
print("1. after moving the copy: original = \(original.deck), copy = \(copy.deck)")

print("2. before plain function: original oxygen = \(original.oxygen)")
let insideFunction = drainedCopy(original)
print("2. inside the function oxygen was \(insideFunction), original oxygen = \(original.oxygen)")

print("3. before inout function: original oxygen = \(original.oxygen)")
drain(&original)
print("3. after inout function: original oxygen = \(original.oxygen)")


// MARK: Level 4 · The Teleport Pod

// 4.1
// Class because a pod is one physical object with its own identity: every part
// of the station that holds a pod must see the same charge and the same occupant.
final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    // A struct gets a memberwise init for free, but a class does not: the compiler
    // can't know how I want the properties set up (occupant has to start as nil), so I write it.
    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    deinit {
        print("Pod \(id) is destroyed")
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        guard occupant == nil, chargeLevel >= 20 else { return false }
        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let passenger = occupant else { return nil }
        chargeLevel -= 20
        occupant = nil
        return passenger
    }
}

// 4.2
print("--- 4.2 charge ledger ---")
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
let timur = crewRoster[0]
let dana = crewRoster[1]
let nurlan = crewRoster[3]

func loadAndFire(_ crew: CrewSnapshot, in pod: TeleportPod) {
    let loaded = pod.load(crew)
    let sent = pod.fire()
    print("\(crew.name): loaded = \(loaded), fired = \(sent?.name ?? "nobody"), charge = \(pod.chargeLevel)")
}

loadAndFire(timur, in: pod)
loadAndFire(dana, in: pod)
loadAndFire(nurlan, in: pod)
let emptyShot = pod.fire()
print("empty pod: fired = \(emptyShot?.name ?? "nobody"), charge = \(pod.chargeLevel)")

let C = pod.chargeLevel

// 4.3
print("--- 4.3 reference semantics ---")
let podOne = TeleportPod(id: "P-2", chargeLevel: 100)
let podTwo = podOne
podTwo.chargeLevel = 10
print("pods: podOne = \(podOne.chargeLevel), podTwo = \(podTwo.chargeLevel)")

var snapshotOne = CrewSnapshot.rookie(named: "Nurlan")
var snapshotTwo = snapshotOne
snapshotTwo.oxygen = 10
print("snapshots: snapshotOne = \(snapshotOne.oxygen), snapshotTwo = \(snapshotTwo.oxygen)")
// Rule: assigning a class instance copies the reference (one object), assigning a struct copies the value (two objects).


// MARK: Level 5 · Station Systems

// 5.1
// Class because the station is one shared live state that many parts of the program read and change.
final class Station {
    let callSign: String
    var oxygenByDeck: [Deck: Int]

    var hullIntegrity: Int {
        willSet {
            print("Hull integrity: \(hullIntegrity) -> \(newValue)")
        }
        didSet {
            hullIntegrity = min(max(hullIntegrity, 0), 100)
        }
    }

    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "\(callSign): hull \(hullIntegrity)%, total oxygen \(totalOxygen)"
    }()

    var totalOxygen: Int {
        var sum = 0
        for level in oxygenByDeck.values {
            sum += level
        }
        return sum
    }

    var averageOxygen: Int {
        get {
            guard !oxygenByDeck.isEmpty else { return 0 }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in oxygenByDeck.keys {
                oxygenByDeck[deck] = newValue
            }
        }
    }

    init(callSign: String, readings: [(deck: String, oxygen: Int)]) {
        self.callSign = callSign
        self.hullIntegrity = 100
        var levels: [Deck: Int] = [:]
        for reading in readings {
            guard let deck = Deck(rawValue: reading.deck) else {
                print("Skipped reading for unknown deck '\(reading.deck)'")
                continue
            }
            levels[deck] = reading.oxygen
        }
        self.oxygenByDeck = levels
    }
}

print("--- 5.1 Station ---")
let station = Station(callSign: "ALMA-7", readings: deckReadings)
print("call sign: \(station.callSign)")
print("total oxygen: \(station.totalOxygen)")
print("average oxygen at start-up: \(station.averageOxygen)")

let B = station.averageOxygen

print("diagnostics not touched yet, no scan so far")
print("first access: \(station.fullDiagnostics)")
print("second access: \(station.fullDiagnostics)")

station.averageOxygen = 50
print("after setting the average to 50: total = \(station.totalOxygen), average = \(station.averageOxygen)")

// 5.2
print("--- 5.2 clamp trap ---")
station.hullIntegrity = 130
print("hull: \(station.hullIntegrity)")
station.hullIntegrity = -40
print("hull: \(station.hullIntegrity)")
station.hullIntegrity = 55
print("hull: \(station.hullIntegrity)")
// The clamp does not loop because assigning to a property inside its own observer does not call the observers again.


// MARK: Level 6 · Incident Reports
// Three of these compile and are wrong. One does not compile.

/*
// Report 1
var roster = crewRoster
for var member in roster {
    member.oxygen -= 10
}
print(roster[0].oxygen)   // author expected the crew to have lost oxygen

// Report 2
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = podA
podB.chargeLevel = 0
print(podA.chargeLevel)   // author expected 100

// Report 3
struct Logbook {
    var entries: [String] = []
    func add(_ entry: String) {
        entries.append(entry)
    }
}

// Report 4
let snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let pod = TeleportPod(id: "B", chargeLevel: 50)
pod.chargeLevel = 10
*/

// Report 1 (compiles, wrong result)
// Expected: every crew member loses 10 oxygen.
// Actual: roster[0].oxygen is still 62. `for var member in roster` gives a copy of each
// snapshot, and CrewSnapshot is a struct (value type), so only the copy is changed.
// Rule: value semantics, every assignment or loop variable is an independent copy.
// Fix: change the elements through the array itself, using the index.
var fixedRoster = crewRoster
for index in fixedRoster.indices {
    fixedRoster[index].oxygen -= 10
}
print("Report 1 fixed: \(fixedRoster[0].oxygen)")

// Report 2 (compiles, wrong result)
// Expected: podB is an independent pod, so podA stays at 100.
// Actual: podA.chargeLevel is 0. TeleportPod is a class, `let podB = podA` copies only the
// reference, so both names point to the same pod.
// Rule: reference semantics, classes are shared, not copied.
// Fix: create a second pod object with the same data.
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = TeleportPod(id: podA.id, chargeLevel: podA.chargeLevel)
podB.chargeLevel = 0
print("Report 2 fixed: podA = \(podA.chargeLevel), podB = \(podB.chargeLevel)")

// Report 3 (does not compile)
// Error: "cannot use mutating member on immutable value: 'self' is immutable".
// Methods of a struct can't change the struct's properties unless they are marked mutating,
// because self is a constant inside a normal method.
// Rule: methods that change a value type must be `mutating`.
// Fix:
struct Logbook {
    var entries: [String] = []
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}
var logbook = Logbook()
logbook.add("Teleporter installed")
logbook.add("Day ten incident")
print("Report 3 fixed: \(logbook.entries)")

// Report 4 (only the struct line does not compile)
// `snapshot.oxygen = 40` is an error: "cannot assign to property: 'snapshot' is a 'let' constant".
// For a struct, let freezes the whole value, including all of its properties.
// `pod.chargeLevel = 10` is fine. For a class, let freezes only the reference: the constant
// can't point to another pod, but the object it points to can still change its var properties.
// Fix: declare the struct as var (the pod can stay let).
var snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40
let podB2 = TeleportPod(id: "B", chargeLevel: 50)
podB2.chargeLevel = 10
print("Report 4 fixed: oxygen = \(snapshot.oxygen), charge = \(podB2.chargeLevel)")


// MARK: Level 7 · Sealing the Black Box

// The leaky original:
//
// class FlightRecorder {
//     var entries: [String] = []
//     var isSealed = false
// }

// Class because there is one recorder and everyone must write into the same log and see the same seal.
final class FlightRecorder {
    // private: blocks outside code from replacing, clearing or editing the entry list.
    private var entries: [String] = []

    // private(set): outside code can read isSealed, but can't set it back to false.
    private(set) var isSealed = false

    // read-only, so nobody outside can change how many entries there are
    var entryCount: Int {
        entries.count
    }

    var transcript: String {
        var text = ""
        for line in numberedLines() {
            text += line + "\n"
        }
        return text
    }

    // adds an entry only while the recorder is open
    @discardableResult
    func add(_ entry: String) -> Bool {
        guard !isSealed else { return false }
        entries.append(entry)
        return true
    }

    func seal() {
        isSealed = true
    }

    // fileprivate: hides the formatting helper from other files, but lets the free function below use it.
    fileprivate func numberedLines() -> [String] {
        var lines: [String] = []
        for (index, entry) in entries.enumerated() {
            lines.append("\(index + 1). \(entry)")
        }
        return lines
    }
}

func auditTranscript(of recorder: FlightRecorder) -> String {
    let state = recorder.isSealed ? "sealed" : "open"
    return "Audit (\(state), \(recorder.entryCount) entries):\n" + recorder.numberedLines().joined(separator: "\n")
}

print("--- 7 FlightRecorder ---")
let recorder = FlightRecorder()
recorder.add("Teleporter installed")
recorder.add("Day ten incident")
print("entries: \(recorder.entryCount), sealed: \(recorder.isSealed)")
print(recorder.transcript, terminator: "")
recorder.seal()
print("add after seal: \(recorder.add("Fake entry"))")
print("entries: \(recorder.entryCount), sealed: \(recorder.isSealed)")
print(auditTranscript(of: recorder))

// Attempts to break it from outside the type (all fail to compile):
// recorder.entries = []
//   error: 'entries' is inaccessible due to 'private' protection level
// recorder.isSealed = false
//   error: cannot assign to property: 'isSealed' setter is inaccessible


// MARK: Finale · Integrity Code

let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")


// MARK: Bonus

// 1. deinit is in the TeleportPod class body, it prints the pod's id.

// 3. compares two pod references
func compare(_ first: TeleportPod, _ second: TeleportPod) -> String {
    if first === second {
        return "same pod"
    }
    if first.id == second.id && first.chargeLevel == second.chargeLevel && first.occupant?.name == second.occupant?.name {
        return "two pods with equal contents"
    }
    return "different pods"
}

print("--- Bonus ---")
let sameA = TeleportPod(id: "S-1", chargeLevel: 70)
let sameB = sameA
let twin = TeleportPod(id: "S-1", chargeLevel: 70)
let other = TeleportPod(id: "S-2", chargeLevel: 30)
print("sameA vs sameB: \(compare(sameA, sameB))")
print("sameA vs twin: \(compare(sameA, twin))")
print("sameA vs other: \(compare(sameA, other))")

// 2. lifetime experiment
var keeper: TeleportPod?
print("before the block")
do {
    let temporary = TeleportPod(id: "P-3", chargeLevel: 60)
    keeper = temporary
    print("inside the block: created \(temporary.id)")
}
print("after the block: the pod is alive, keeper points to it")
keeper = nil
print("after keeper = nil")


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?
    A struct gets a memberwise initializer, the compiler makes it from the stored properties.
    A class gets only an empty init() and only if every property has a default value.
    TeleportPod has properties without defaults (id, chargeLevel), so I must write init myself.
    Classes can't have a memberwise init because of inheritance and because they may need
    extra setup, so Swift doesn't guess.

 2. What does `mutating` do to self, and why do classes never need it?
    Inside a struct method self is a constant copy of the value, so it can't be changed.
    `mutating` makes self behave like an inout parameter: the method can change properties or
    assign a whole new value to self (like reviveInMedbay), and the caller must have a var.
    In a class, self is only a reference. Changing a property does not change the reference,
    so there is nothing to protect, and a class can't replace self at all.

 3. In Report 4, both values are declared with let. What exactly does let freeze?
    For a struct, the value itself lives in the constant, so let freezes the whole value:
    no property can be changed. For a class, the constant holds only the reference: it
    can't point to another object, but the var properties of the object can still change.

 4. Why must a lazy property be var? When does lazy change behaviour?
    A lazy property has no value when the object is created and gets it later, on first access.
    That is a change of the object after init, and a let can't be changed, so it must be var.
    Behaviour changes when the calculation has side effects or depends on state that changes:
    in Station, fullDiagnostics prints "Running full scan..." and reads hullIntegrity.
    If nobody touches it, nothing is printed. If hullIntegrity changes before the first access,
    the string shows the new value. A normal property would print at init and keep the old value.

 5. private vs fileprivate in FlightRecorder:
    numberedLines() is used by the free function auditTranscript(of:), which is outside the
    class but in the same file. private would hide it from that function and the code would
    not compile. fileprivate allows the access inside this file only, so other files still
    can't use it.

 Bonus. On which line does deinit fire, and why can't === be used on CrewSnapshot?
    deinit fires on the line `keeper = nil`. Leaving the do block only removed the name
    `temporary`, but keeper still held a reference, so the reference count did not reach zero.
    After keeper = nil the count is 0 and the pod is destroyed.
    === checks if two references point to the same object. A struct has no reference and no
    identity, every variable holds its own copy, so there is nothing to compare.

*/
