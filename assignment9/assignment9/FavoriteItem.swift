import Foundation

struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int
}

let favoriteItems: [FavoriteItem] = [
    FavoriteItem(title: "1. Black", subtitle: "#000000", imageName: "black", rating: 5),
    FavoriteItem(title: "2. White", subtitle: "#FFFFFF", imageName: "white", rating: 5),
    FavoriteItem(title: "3. Navy Blue", subtitle: "#1F2A5A", imageName: "navy", rating: 5),
    FavoriteItem(title: "4. Emerald", subtitle: "#0B6E4F", imageName: "emerald", rating: 4),
    FavoriteItem(title: "5. Red", subtitle: "#D62828", imageName: "red", rating: 4),
    FavoriteItem(title: "6. Burgundy", subtitle: "#800020", imageName: "burgundy", rating: 4),
    FavoriteItem(title: "7. Gray", subtitle: "#808080", imageName: "gray", rating: 4),
    FavoriteItem(title: "8. Beige", subtitle: "#E8D9B5", imageName: "beige", rating: 4),
    FavoriteItem(title: "9. Forest Green", subtitle: "#228B22", imageName: "forest", rating: 4),
    FavoriteItem(title: "10. Sky Blue", subtitle: "#87CEEB", imageName: "sky", rating: 3),
    FavoriteItem(title: "11. Purple", subtitle: "#6A0DAD", imageName: "purple", rating: 3),
    FavoriteItem(title: "12. Orange", subtitle: "#FF8C00", imageName: "orange", rating: 3),
    FavoriteItem(title: "13. Pink", subtitle: "#FFC0CB", imageName: "pink", rating: 3),
    FavoriteItem(title: "14. Coffee Brown", subtitle: "#6F4E37", imageName: "brown", rating: 3),
    FavoriteItem(title: "15. Yellow", subtitle: "#FFD700", imageName: "yellow", rating: 2),
    FavoriteItem(title: "16. Turquoise", subtitle: "#40E0D0", imageName: "turquoise", rating: 2),
    FavoriteItem(title: "17. Lavender", subtitle: "#B57EDC", imageName: "lavender", rating: 2),
    FavoriteItem(title: "18. Mint", subtitle: "#98FF98", imageName: "mint", rating: 2),
    FavoriteItem(title: "19. Olive", subtitle: "#808000", imageName: "olive", rating: 1),
    FavoriteItem(title: "20. Lime", subtitle: "#BFFF00", imageName: "lime", rating: 1),
]
