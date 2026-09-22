// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================

// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · Decoding Telemetry

// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let (sensor, text) = splitOnce(raw, by: ":"),
          !sensor.isEmpty,
          let value = Int(text),
          value >= 0 || sensor == "TEMP"
    else { return nil }
    return (sensor: sensor, value: value)
}

print("--- 1.1 parseReading ---")
print("parseReading(O2:87) ->", parseReading("O2:87") as Any)
print("parseReading(TEMP:-12) ->", parseReading("TEMP:-12") as Any)
print("parseReading(RAD:-1) ->", parseReading("RAD:-1") as Any)
print("parseReading(:55) ->", parseReading(":55") as Any)
print("parseReading(hello) ->", parseReading("hello") as Any)

// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0
    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }
    return (valid, invalidCount)
}

print("--- 1.2 parseLog ---")
let smallLog = parseLog(["O2:50", "bad", "TEMP:-5"])
print("small log: \(smallLog.valid.count) valid, \(smallLog.invalidCount) invalid")
let parsed = parseLog(rawLog)
print("raw log: \(parsed.valid.count) valid, \(parsed.invalidCount) invalid")

let A = parsed.invalidCount


// MARK: Level 2 · Analysis

// 2.1
func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result: [Reading] = []
    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }
    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []
    for reading in readings {
        result.append(reading.value)
    }
    return result
}

print("--- 2.1 select / values ---")
let o2Readings = select(parsed.valid) { $0.sensor == "O2" }
print("O2 readings: \(o2Readings)")
print("O2 values: \(values(of: o2Readings))")
let bigReadings = select(parsed.valid) { $0.value > 90 }
print("readings above 90: \(bigReadings)")

// 2.2
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let first = values.first else { return nil }
    var lowest = first
    var highest = first
    var sum = 0
    for value in values {
        if value < lowest { lowest = value }
        if value > highest { highest = value }
        sum += value
    }
    return (lowest, highest, Double(sum) / Double(values.count))
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

print("--- 2.2 stats ---")
print("stats(3, 8, 1) ->", stats(3, 8, 1) as Any)
print("stats() ->", stats() as Any)
print("stats(of: [10, -4, 6, 0]) ->", stats(of: [10, -4, 6, 0]) as Any)
print("stats(of: []) ->", stats(of: []) as Any)

let o2Stats = stats(of: values(of: o2Readings))
let B = Int(o2Stats?.average ?? 0)

// 2.3 · The Closure Ladder
let sorted1 = parsed.valid.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})
let sorted2 = parsed.valid.sorted(by: { a, b in
    return a.value > b.value
})
let sorted3 = parsed.valid.sorted(by: { a, b in a.value > b.value })
let sorted4 = parsed.valid.sorted(by: { $0.value > $1.value })
let sorted5 = parsed.valid.sorted { $0.value > $1.value }

func sameReadings(_ first: [Reading], _ second: [Reading]) -> Bool {
    guard first.count == second.count else { return false }
    for index in first.indices {
        if first[index].sensor != second[index].sensor || first[index].value != second[index].value {
            return false
        }
    }
    return true
}

print("--- 2.3 closure ladder ---")
print("sorted: \(values(of: sorted5))")
print("1 == 5: \(sameReadings(sorted1, sorted5))")
print("2 == 5: \(sameReadings(sorted2, sorted5))")
print("3 == 5: \(sameReadings(sorted3, sorted5))")
print("4 == 5: \(sameReadings(sorted4, sorted5))")


// MARK: Level 3 · Temperature Stabilization

let safeRange = 18...24

// 3.1
func heatUp(_ t: Int) -> Int { t + 5 }
func coolDown(_ t: Int) -> Int { t - 3 }
func hold(_ t: Int) -> Int { t }

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < safeRange.lowerBound {
        return heatUp
    } else if temp > safeRange.upperBound {
        return coolDown
    } else {
        return hold
    }
}

print("--- 3.1 protocols ---")
print("heatUp(10) = \(heatUp(10)), coolDown(10) = \(coolDown(10)), hold(10) = \(hold(10))")
print("protocol for 10 gives \(chooseProtocol(for: 10)(10))")
print("protocol for 30 gives \(chooseProtocol(for: 30)(30))")
print("protocol for 20 gives \(chooseProtocol(for: 20)(20))")

// 3.2
func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temp = start
    var steps = 0
    while !safeRange.contains(temp) && steps < maxSteps {
        let action = chooseProtocol(for: temp)
        temp = action(temp)
        steps += 1
    }
    return (temp, steps, safeRange.contains(temp))
}

print("--- 3.2 runUntilStable ---")
print(runUntilStable(from: 31))
print(runUntilStable(from: -100, maxSteps: 5))
print(runUntilStable(from: 20))

let tempReadings = select(parsed.valid) { $0.sensor == "TEMP" }
let lowestTemp = stats(of: values(of: tempReadings))?.min
// the log has valid TEMP readings, so the fallback 20 (already stable) is never used
let C = runUntilStable(from: lowestTemp ?? 20).steps


// MARK: Level 4 · The Crew

// 4.1
func oxygenLevel(of member: CrewMember) -> Int? { member.module?.oxygenTank?.level }

print("--- 4.1 oxygenLevel ---")
for member in crew {
    print("\(member.name): \(oxygenLevel(of: member) ?? -1)")
}

// 4.2
func status(of member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        let place = member.module?.name ?? "open space"
        return "\(member.name): no data (\(place))"
    }
    if level < 20 {
        return "\(member.name): \(level)% CRITICAL"
    }
    return "\(member.name): \(level)% OK"
}

print("--- 4.2 status ---")
for member in crew {
    print(status(of: member))
}

// 4.3
@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    guard amount > 0 else { return 0 }
    let moved = max(0, min(amount, source, 100 - target))
    source -= moved
    target += moved
    return moved
}

print("--- 4.3 transferOxygen ---")
var tankX = 50
var tankY = 90
print("moved \(transferOxygen(from: &tankX, to: &tankY, amount: 30)), x = \(tankX), y = \(tankY)")
print("moved \(transferOxygen(from: &tankX, to: &tankY, amount: -5)), x = \(tankX), y = \(tankY)")
print("moved \(transferOxygen(from: &tankY, to: &tankX, amount: 500)), x = \(tankX), y = \(tankY)")

if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
    let moved = transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
    print("Lab -> Hab: moved \(moved), Lab = \(labTank.level), Hab = \(habTank.level)")
}

let D = hab.oxygenTank?.level ?? 0

// 4.4
func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var found: [CrewMember] = []
    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }
        found.append(member)
    }
    let byPriority = found.sorted { $0.priority < $1.priority }
    var result: [String] = []
    for member in byPriority {
        result.append(member.name)
    }
    return result
}

print("--- 4.4 evacuationOrder ---")
print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))
print(evacuationOrder("Nurlan", "Timur", roster: roster))
print(evacuationOrder(roster: roster))


// MARK: Level 5 · The Saboteur's Logbook

/*
func reportOxygen(for member: CrewMember) -> String {
    let tank = member.module!.oxygenTank!
    return "\(member.name): \(tank.level)%"
}

func firstCritical(in crew: [CrewMember]) -> String {
    var result: String?
    for member in crew {
        if oxygenLevel(of: member)! < 20 {
            result = member.name
        }
    }
    return result!
}
*/

// Problems in reportOxygen:
// 1. member.module! crashes when the module is nil (Nurlan is in open space).
// 2. oxygenTank! crashes when the module has no tank (Dana in the Dock).
//    In both cases the app dies with "Unexpectedly found nil" instead of saying "no data".
//
// Problems in firstCritical:
// 3. oxygenLevel(of: member)! crashes for the first member with no oxygen data (Dana, Nurlan).
// 4. result! crashes when nobody is critical, because result is still nil.
// 5. Logic bug: the loop never stops, so result gets overwritten by every critical member
//    and the function returns the LAST critical one, not the first.
//    With the starter data only Aigerim is critical, so this is not visible.
// 6. Return type String has no way to say "nobody is critical", that is why it needs String?.

func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }
    return "\(member.name): \(level)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        guard let level = oxygenLevel(of: member) else { continue }
        if level < 20 {
            return member.name
        }
    }
    return nil
}

print("--- 5 saboteur fixes ---")
for member in crew {
    print(reportOxygen(for: member))
}

// Two critical members: the old version would return "Second", the fixed one returns "First"
let critical1 = Module(name: "T1", oxygenTank: Tank(level: 5))
let critical2 = Module(name: "T2", oxygenTank: Tank(level: 9))
let testCrew = [
    CrewMember(name: "NoData", role: "Test", priority: 1, module: nil),
    CrewMember(name: "First", role: "Test", priority: 2, module: critical1),
    CrewMember(name: "Second", role: "Test", priority: 3, module: critical2)
]
print("first critical in testCrew: \(firstCritical(in: testCrew) ?? "nobody")")
print("test passed: \(firstCritical(in: testCrew) == "First")")
print("first critical in empty crew: \(firstCritical(in: []) ?? "nobody")")


// MARK: Finale · Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var count = 0
    return { level in
        guard level < threshold else { return false }
        count += 1
        print("Alarm #\(count)")
        return true
    }
}

print("--- Bonus makeAlarm ---")
let alarm = makeAlarm(threshold: 20)
print(alarm(12))
print(alarm(40))
print(alarm(5))
let otherAlarm = makeAlarm(threshold: 50)
print(otherAlarm(30))


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:
    With guard let the unwrapped value stays available after the guard, in the whole
    rest of the function. With if let it exists only inside the braces. Also, the else
    branch of guard must leave the scope (return, continue, break, throw), so the
    compiler forces me to handle the bad case right away.
    if let is worse when there are several optionals: every next one adds a new level
    of nesting and the real work ends up deep inside.

        if let (sensor, text) = splitOnce(raw, by: ":") {
            if !sensor.isEmpty {
                if let value = Int(text) {
                    // real work is here, three levels deep
                }
            }
        }

    With guard it is a flat list of conditions, like in parseReading.

 2. Why can't you pass [Int] to stats(_ values: Int...)?
    A variadic parameter wants separate values: stats(1, 2, 3). Only inside the function
    they are packed into an array. Swift has no way to "spread" an array into separate
    arguments at the call site, so stats(someArray) is a type mismatch: [Int] is not Int.
    That is why the first version stats(of:) takes an array, and the variadic one
    just calls it.

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?
    Both inout parameters would point to the same variable at the same time. Swift's
    exclusivity rule does not allow overlapping access to one variable when at least one
    access is a write (error: "inout arguments are not allowed to alias each other").
    It prevents a bug where source and
    target are the same memory: the function would subtract and add to one variable, and
    the result would depend on which value is written back last.

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?
    oxygenLevel returns Int?, so ?? needs a default of the same type, Int.
    "no data" is a String, and ?? can't change the type of the result.
    It works with a number (?? 0), or I can use guard let and build the String myself,
    like I did in status(of:).

 5. Full type of chooseProtocol and how to read it:
    (Int) -> (Int) -> Int
    Read it from left to right: it takes an Int (temp) and returns a function.
    That returned function takes an Int and returns an Int. The arrow is
    right-associative, so it is the same as (Int) -> ((Int) -> Int).
    The argument label "for:" is part of the name chooseProtocol(for:), not of the type.

 Bonus. Where does the alarm counter live after makeAlarm returns?
    The closure captures the variable count. Because the closure is still alive after
    makeAlarm returns, Swift moves count from the stack to the heap and the closure keeps a
    reference to it. It lives as long as the closure lives. Every makeAlarm call creates
    its own count, so alarm and otherAlarm count separately.

*/
