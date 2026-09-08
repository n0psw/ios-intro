// Step 1: personal information
let firstName = "Adilkhan"
let lastName = "Bulatov"
let birthYear = 2005
let currentYear = 2026
let age = currentYear - birthYear
let isStudent = true
let height = 1.75
let city = "Almaty"
let university = "KBTU"
let yearOfStudy = 4

// Step 2: hobbies and interests
let hobby = "sport"
let numberOfHobbies = 1
let favoriteNumber = 7
let isHobbyCreative = true
let favoriteLanguage = "Python"
let hoursOfCodingPerDay = 3
let likesCoffee = true

// Bonus: future goals and emoji
let futureGoals = "become a professional iOS developer"
let 🎯 = "build my own app and publish it in the App Store"
let mood = "😀"
let favoriteEmoji = "🚀"

// Step 3: life story with string interpolation
let lifeStory = "My name is \(firstName) \(lastName). I am \(age) years old, born in \(birthYear). "
    + "I am currently \(isStudent ? "a student" : "not a student") at \(university) in \(city), year \(yearOfStudy). "
    + "My height is \(height) m. "
    + "I enjoy \(hobby), which is \(isHobbyCreative ? "a creative" : "not a creative") hobby. "
    + "I have \(numberOfHobbies) hobbies in total, and my favorite number is \(favoriteNumber). "
    + "My favorite language is \(favoriteLanguage), and I code about \(hoursOfCodingPerDay) hours a day. "
    + "\(likesCoffee ? "I love coffee. " : "")"
    + "In the future, I want to \(futureGoals) and \(🎯). \(mood) \(favoriteEmoji)"

// Step 4: print the result
print(lifeStory)
