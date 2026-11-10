import Foundation

struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int
    let details: String
}

let favoriteItems: [FavoriteItem] = [
    FavoriteItem(title: "1. Black", subtitle: "#000000", imageName: "black", rating: 5,
                 details: "Black is the darkest color and the absence of visible light. It is the classic choice for formal clothing, fonts and modern interfaces. It pairs with almost any other color, which is why it takes first place in this top."),
    FavoriteItem(title: "2. White", subtitle: "#FFFFFF", imageName: "white", rating: 5,
                 details: "White reflects all visible light and looks clean and bright. It is widely used in minimalist design, medicine and everyday clothing. Together with black it forms the strongest contrast possible."),
    FavoriteItem(title: "3. Navy Blue", subtitle: "#1F2A5A", imageName: "navy", rating: 5,
                 details: "Navy blue is a deep dark shade of blue named after the uniforms of naval officers. It looks strict, calm and trustworthy, so it is popular in business style. In many outfits it is a more elegant alternative to black."),
    FavoriteItem(title: "4. Emerald", subtitle: "#0B6E4F", imageName: "emerald", rating: 4,
                 details: "Emerald is a rich green with a slight blue tint, named after the gemstone. It feels expensive and works well in interiors and jewelry. The shade is calm but still looks bright and confident."),
    FavoriteItem(title: "5. Red", subtitle: "#D62828", imageName: "red", rating: 4,
                 details: "Red is the color of fire, energy and attention. It is used for warning signs, sales and brand logos because the eye notices it first. In many cultures it also symbolizes love, luck and celebration."),
    FavoriteItem(title: "6. Burgundy", subtitle: "#800020", imageName: "burgundy", rating: 4,
                 details: "Burgundy is a deep red with a purple undertone, named after the wine region in France. It looks noble and warm, especially in autumn clothing and interiors. Dark backgrounds make it look even richer."),
    FavoriteItem(title: "7. Gray", subtitle: "#808080", imageName: "gray", rating: 4,
                 details: "Gray sits between black and white and has no strong character of its own. It is neutral, calm and easy to combine with brighter accents. Because of that it is common in office design, gadgets and architecture."),
    FavoriteItem(title: "8. Beige", subtitle: "#E8D9B5", imageName: "beige", rating: 4,
                 details: "Beige is a soft pale shade of sand and light brown. It creates a cozy and gentle mood without being boring. Designers often use it as a base for interiors and clothing in a natural style."),
    FavoriteItem(title: "9. Forest Green", subtitle: "#228B22", imageName: "forest", rating: 4,
                 details: "Forest green is a medium dark green that reminds of trees and nature. It calms the eyes and is associated with growth and freshness. Outdoor brands and sports teams like it for its natural look."),
    FavoriteItem(title: "10. Sky Blue", subtitle: "#87CEEB", imageName: "sky", rating: 3,
                 details: "Sky blue is a light and airy blue, the color of a clear day. It feels open, peaceful and friendly. It is a favorite for backgrounds, baby clothes and travel posters."),
    FavoriteItem(title: "11. Purple", subtitle: "#6A0DAD", imageName: "purple", rating: 3,
                 details: "Purple mixes the calm of blue with the energy of red. In history it was a rare and expensive dye, so it became a symbol of royalty. Today it is linked with creativity and imagination."),
    FavoriteItem(title: "12. Orange", subtitle: "#FF8C00", imageName: "orange", rating: 3,
                 details: "Orange is a warm color between red and yellow, named after the fruit. It feels cheerful, active and friendly. It is often used for sports, food brands and safety equipment."),
    FavoriteItem(title: "13. Pink", subtitle: "#FFC0CB", imageName: "pink", rating: 3,
                 details: "Pink is a soft light shade of red mixed with white. It is linked with tenderness, care and spring. Modern design uses it in many shades, from pastel to bright neon."),
    FavoriteItem(title: "14. Coffee Brown", subtitle: "#6F4E37", imageName: "brown", rating: 3,
                 details: "Coffee brown is a deep warm brown that looks like roasted beans. It feels comfortable, natural and reliable. It works well in wooden furniture, leather goods and cozy interiors."),
    FavoriteItem(title: "15. Yellow", subtitle: "#FFD700", imageName: "yellow", rating: 2,
                 details: "Yellow is the brightest color for the human eye and catches attention quickly. It is linked with the sun, summer and good mood. It is also used for taxis and warning signs because it is visible from far away."),
    FavoriteItem(title: "16. Turquoise", subtitle: "#40E0D0", imageName: "turquoise", rating: 2,
                 details: "Turquoise is a mix of blue and green, named after the semi-precious stone. It reminds of a tropical sea and clear water. It is used in jewelry, summer design and relaxing interiors."),
    FavoriteItem(title: "17. Lavender", subtitle: "#B57EDC", imageName: "lavender", rating: 2,
                 details: "Lavender is a light purple with a soft bluish tone, named after the flower. It feels gentle, calm and a bit nostalgic. It is often used in spa design and spring fashion."),
    FavoriteItem(title: "18. Mint", subtitle: "#98FF98", imageName: "mint", rating: 2,
                 details: "Mint is a pale fresh green that reminds of mint leaves and candy. It looks clean, light and modern. Many apps, kitchens and summer drinks use it for a cool feeling."),
    FavoriteItem(title: "19. Olive", subtitle: "#808000", imageName: "olive", rating: 1,
                 details: "Olive is a dull yellow-green that looks like olives and military clothing. It is calm, earthy and practical. Designers often use it for casual outfits and rustic interiors."),
    FavoriteItem(title: "20. Lime", subtitle: "#BFFF00", imageName: "lime", rating: 1,
                 details: "Lime is a very bright yellow-green, close to the color of the citrus fruit. It is loud, energetic and impossible to miss. Sports gear and safety vests use it because it is visible even in low light."),
]
