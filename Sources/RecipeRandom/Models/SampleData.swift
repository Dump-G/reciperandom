import Foundation

struct Recipe: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let subtitle: String
    let cookTime: String
    let difficulty: String
    let tags: [String]
    let detail: RecipeDetail

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        cookTime: String,
        difficulty: String,
        tags: [String],
        detail: RecipeDetail
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.cookTime = cookTime
        self.difficulty = difficulty
        self.tags = tags
        self.detail = detail
    }
}

struct RecipeDetail: Codable, Equatable {
    let totalTime: String
    let serves: String
    let ingredients: [Ingredient]
    let steps: [String]
    let nutrition: [NutritionStat]
}

struct Ingredient: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let amount: String

    init(id: UUID = UUID(), name: String, amount: String) {
        self.id = id
        self.name = name
        self.amount = amount
    }
}

struct NutritionStat: Identifiable, Codable, Equatable {
    let id: UUID
    let value: String
    let label: String

    init(id: UUID = UUID(), value: String, label: String) {
        self.id = id
        self.value = value
        self.label = label
    }
}

struct ShoppingSection: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    var items: [ShoppingItem]

    init(id: UUID = UUID(), title: String, items: [ShoppingItem]) {
        self.id = id
        self.title = title
        self.items = items
    }
}

struct ShoppingItem: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let note: String
    var isChecked: Bool

    init(id: UUID = UUID(), name: String, note: String, isChecked: Bool = false) {
        self.id = id
        self.name = name
        self.note = note
        self.isChecked = isChecked
    }
}

enum SampleData {
    static let todaysPick = Recipe(
        title: "Smoky Chickpea Bowls",
        subtitle: "Crispy chickpeas, charred broccoli, citrus yogurt, and warm pita.",
        cookTime: "30 min",
        difficulty: "Vegetarian",
        tags: ["30 min", "Vegetarian", "One pan"],
        detail: RecipeDetail(
            totalTime: "30 min",
            serves: "2 servings",
            ingredients: [
                Ingredient(name: "Chickpeas", amount: "2 cans"),
                Ingredient(name: "Broccoli", amount: "2 heads"),
                Ingredient(name: "Greek yogurt", amount: "1 cup"),
                Ingredient(name: "Lemon", amount: "2"),
                Ingredient(name: "Smoked paprika", amount: "1 tsp")
            ],
            steps: [
                "Toss chickpeas with spices and roast until crisp.",
                "Char broccoli on a hot sheet pan with olive oil.",
                "Whisk yogurt with lemon zest and juice.",
                "Warm pita, assemble bowls, and drizzle sauce.",
                "Finish with herbs and feta."
            ],
            nutrition: [
                NutritionStat(value: "420", label: "kcal"),
                NutritionStat(value: "18g", label: "protein"),
                NutritionStat(value: "12g", label: "fiber")
            ]
        )
    )

    static let trendingRecipes: [Recipe] = [
        Recipe(
            title: "Miso Butter Salmon",
            subtitle: "Crisp skin, sesame greens, and brown rice",
            cookTime: "22 min",
            difficulty: "Easy",
            tags: ["22 min", "Easy"],
            detail: RecipeDetail(
                totalTime: "22 min",
                serves: "2 servings",
                ingredients: [
                    Ingredient(name: "Salmon fillets", amount: "2"),
                    Ingredient(name: "Miso paste", amount: "1 tbsp"),
                    Ingredient(name: "Butter", amount: "2 tbsp"),
                    Ingredient(name: "Bok choy", amount: "2 heads")
                ],
                steps: [
                    "Whisk miso with melted butter and brush over salmon.",
                    "Sear salmon skin-side down until crisp.",
                    "Steam bok choy and toss with sesame oil.",
                    "Serve with rice and extra miso butter."
                ],
                nutrition: [
                    NutritionStat(value: "510", label: "kcal"),
                    NutritionStat(value: "34g", label: "protein"),
                    NutritionStat(value: "20g", label: "fat")
                ]
            )
        ),
        Recipe(
            title: "Harissa Sweet Potato Tacos",
            subtitle: "Cabbage crunch + avocado crema",
            cookTime: "35 min",
            difficulty: "Medium",
            tags: ["35 min", "Medium"],
            detail: RecipeDetail(
                totalTime: "35 min",
                serves: "3 servings",
                ingredients: [
                    Ingredient(name: "Sweet potato", amount: "2"),
                    Ingredient(name: "Harissa", amount: "2 tbsp"),
                    Ingredient(name: "Corn tortillas", amount: "6"),
                    Ingredient(name: "Cabbage", amount: "2 cups")
                ],
                steps: [
                    "Roast sweet potato wedges with harissa and olive oil.",
                    "Warm tortillas on a dry skillet.",
                    "Toss cabbage with lime and salt.",
                    "Assemble tacos with avocado crema."
                ],
                nutrition: [
                    NutritionStat(value: "390", label: "kcal"),
                    NutritionStat(value: "10g", label: "protein"),
                    NutritionStat(value: "9g", label: "fiber")
                ]
            )
        )
    ]

    static let savedRecipes: [Recipe] = [
        Recipe(
            title: "Creamy Lemon Orzo",
            subtitle: "Asparagus, peas, parmesan",
            cookTime: "24 min",
            difficulty: "Vegetarian",
            tags: ["24 min", "Vegetarian"],
            detail: RecipeDetail(
                totalTime: "24 min",
                serves: "2 servings",
                ingredients: [
                    Ingredient(name: "Orzo", amount: "1 cup"),
                    Ingredient(name: "Asparagus", amount: "1 bunch"),
                    Ingredient(name: "Peas", amount: "1 cup"),
                    Ingredient(name: "Parmesan", amount: "1/3 cup")
                ],
                steps: [
                    "Toast orzo in olive oil until lightly golden.",
                    "Simmer with broth until tender and creamy.",
                    "Fold in asparagus and peas to finish.",
                    "Stir in lemon zest and parmesan."
                ],
                nutrition: [
                    NutritionStat(value: "440", label: "kcal"),
                    NutritionStat(value: "16g", label: "protein"),
                    NutritionStat(value: "8g", label: "fiber")
                ]
            )
        ),
        Recipe(
            title: "Soba Noodle Salad",
            subtitle: "Sesame, cucumber, soft egg",
            cookTime: "18 min",
            difficulty: "No cook",
            tags: ["18 min", "No cook"],
            detail: RecipeDetail(
                totalTime: "18 min",
                serves: "2 servings",
                ingredients: [
                    Ingredient(name: "Soba noodles", amount: "6 oz"),
                    Ingredient(name: "Cucumber", amount: "1"),
                    Ingredient(name: "Soft eggs", amount: "2"),
                    Ingredient(name: "Sesame dressing", amount: "1/4 cup")
                ],
                steps: [
                    "Cook soba, rinse cool, and drain well.",
                    "Julienne cucumber and toss with noodles.",
                    "Top with soft eggs and sesame dressing.",
                    "Finish with scallions and sesame seeds."
                ],
                nutrition: [
                    NutritionStat(value: "360", label: "kcal"),
                    NutritionStat(value: "14g", label: "protein"),
                    NutritionStat(value: "6g", label: "fiber")
                ]
            )
        ),
        Recipe(
            title: "Coconut Lentil Stew",
            subtitle: "Ginger, spinach, lime",
            cookTime: "40 min",
            difficulty: "Batch cook",
            tags: ["40 min", "Batch cook"],
            detail: RecipeDetail(
                totalTime: "40 min",
                serves: "4 servings",
                ingredients: [
                    Ingredient(name: "Red lentils", amount: "1 cup"),
                    Ingredient(name: "Coconut milk", amount: "1 can"),
                    Ingredient(name: "Spinach", amount: "3 cups"),
                    Ingredient(name: "Fresh ginger", amount: "1 tbsp")
                ],
                steps: [
                    "Sweat ginger and aromatics in olive oil.",
                    "Simmer lentils in broth until soft.",
                    "Stir in coconut milk and spinach.",
                    "Finish with lime and chili oil."
                ],
                nutrition: [
                    NutritionStat(value: "480", label: "kcal"),
                    NutritionStat(value: "20g", label: "protein"),
                    NutritionStat(value: "11g", label: "fiber")
                ]
            )
        )
    ]

    static let shoppingSections: [ShoppingSection] = [
        ShoppingSection(
            title: "Produce",
            items: [
                ShoppingItem(name: "Broccoli", note: "2 heads"),
                ShoppingItem(name: "Cherry tomatoes", note: "1 pint"),
                ShoppingItem(name: "Lemon", note: "2")
            ]
        ),
        ShoppingSection(
            title: "Pantry",
            items: [
                ShoppingItem(name: "Chickpeas", note: "2 cans"),
                ShoppingItem(name: "Smoked paprika", note: "1 tsp"),
                ShoppingItem(name: "Pita", note: "4 pieces")
            ]
        ),
        ShoppingSection(
            title: "Dairy",
            items: [
                ShoppingItem(name: "Greek yogurt", note: "1 cup"),
                ShoppingItem(name: "Feta", note: "100 g")
            ]
        )
    ]

    static let seedSnapshot = AppStoreSnapshot(
        recipes: [todaysPick] + trendingRecipes + savedRecipes,
        savedRecipeIDs: savedRecipes.map(\.id),
        shoppingSections: shoppingSections,
        todaysPickID: todaysPick.id,
        trendingRecipeIDs: trendingRecipes.map(\.id),
        generatedRecipeIDs: [],
        derivedCheckedIDs: []
    )
}
