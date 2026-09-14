// Easy 1: array creation and access
let fruits = ["apple", "banana", "cherry", "orange", "kiwi"]
print("Third fruit: \(fruits[2])")

// Easy 2: set creation and manipulation
var favoriteNumbers: Set = [7, 13, 21, 42]
favoriteNumbers.insert(99)
print("Favorite numbers: \(favoriteNumbers)")

// Easy 3: dictionary creation and access
let releaseYears = ["Swift": 2014, "Python": 1991, "Java": 1995]
print("Swift was released in \(releaseYears["Swift"] ?? 0)")

// Easy 4: array element update
var colors = ["red", "green", "blue", "yellow"]
colors[1] = "purple"
print("Updated colors: \(colors)")

// Medium 1: set intersection
let firstSet: Set = [1, 2, 3, 4]
let secondSet: Set = [3, 4, 5, 6]
print("Intersection: \(firstSet.intersection(secondSet))")

// Medium 2: dictionary update
var scores = ["Aigerim": 85, "Timur": 72, "Dana": 90]
scores.updateValue(95, forKey: "Timur")
print("Updated scores: \(scores)")

// Medium 3: array merge
let firstFruits = ["apple", "banana"]
let secondFruits = ["cherry", "date"]
let allFruits = firstFruits + secondFruits
print("Merged array: \(allFruits)")

// Hard 1: dictionary key addition
var populations = ["Kazakhstan": 20_000_000, "Japan": 124_000_000, "Norway": 5_500_000]
populations["Germany"] = 84_000_000
print("Updated populations: \(populations)")

// Hard 2: set union and subtract
let pets: Set = ["cat", "dog"]
let animals: Set = ["dog", "mouse"]
let result = pets.union(animals).subtracting(animals)
print("Final set: \(result)")

// Hard 3: nested collection
let grades = ["Aigerim": [90, 85, 100], "Timur": [70, 88, 76]]
print("Timur's second grade: \(grades["Timur"]?[1] ?? 0)")
