import Foundation
import SwiftUI

struct AppStoreSnapshot: Codable {
    let recipes: [Recipe]
    let savedRecipeIDs: [UUID]
    let shoppingSections: [ShoppingSection]
    let todaysPickID: UUID
    let trendingRecipeIDs: [UUID]
    let generatedRecipeIDs: [UUID]
    let derivedCheckedIDs: [String]

    init(
        recipes: [Recipe],
        savedRecipeIDs: [UUID],
        shoppingSections: [ShoppingSection],
        todaysPickID: UUID,
        trendingRecipeIDs: [UUID],
        generatedRecipeIDs: [UUID],
        derivedCheckedIDs: [String]
    ) {
        self.recipes = recipes
        self.savedRecipeIDs = savedRecipeIDs
        self.shoppingSections = shoppingSections
        self.todaysPickID = todaysPickID
        self.trendingRecipeIDs = trendingRecipeIDs
        self.generatedRecipeIDs = generatedRecipeIDs
        self.derivedCheckedIDs = derivedCheckedIDs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recipes = try container.decode([Recipe].self, forKey: .recipes)
        savedRecipeIDs = try container.decode([UUID].self, forKey: .savedRecipeIDs)
        shoppingSections = try container.decode([ShoppingSection].self, forKey: .shoppingSections)
        todaysPickID = try container.decode(UUID.self, forKey: .todaysPickID)
        trendingRecipeIDs = try container.decode([UUID].self, forKey: .trendingRecipeIDs)
        generatedRecipeIDs = try container.decode([UUID].self, forKey: .generatedRecipeIDs)
        derivedCheckedIDs = try container.decodeIfPresent([String].self, forKey: .derivedCheckedIDs) ?? []
    }
}

struct DerivedShoppingItem: Identifiable {
    let id: String
    let name: String
    let note: String
    let isChecked: Bool
}

@MainActor
final class AppStore: ObservableObject {
    @Published private(set) var recipes: [Recipe]
    @Published private(set) var savedRecipeIDs: Set<UUID>
    @Published var shoppingSections: [ShoppingSection]
    @Published var todaysPickID: UUID
    @Published var trendingRecipeIDs: [UUID]
    @Published var generatedRecipeIDs: [UUID]
    @Published private(set) var derivedCheckedIDs: Set<String>

    private let fileURL: URL

    init(preview: Bool = false) {
        let fileManager = FileManager.default
        fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("app_store_snapshot.json")

        if preview {
            let snapshot = SampleData.seedSnapshot
            recipes = snapshot.recipes
            savedRecipeIDs = Set(snapshot.savedRecipeIDs)
            shoppingSections = snapshot.shoppingSections
            todaysPickID = snapshot.todaysPickID
            trendingRecipeIDs = snapshot.trendingRecipeIDs
            generatedRecipeIDs = snapshot.generatedRecipeIDs
            derivedCheckedIDs = Set(snapshot.derivedCheckedIDs)
            return
        }

        if let data = try? Data(contentsOf: fileURL),
           let snapshot = try? JSONDecoder().decode(AppStoreSnapshot.self, from: data) {
            recipes = snapshot.recipes
            savedRecipeIDs = Set(snapshot.savedRecipeIDs)
            shoppingSections = snapshot.shoppingSections
            todaysPickID = snapshot.todaysPickID
            trendingRecipeIDs = snapshot.trendingRecipeIDs
            generatedRecipeIDs = snapshot.generatedRecipeIDs
            derivedCheckedIDs = Set(snapshot.derivedCheckedIDs)
        } else {
            let snapshot = SampleData.seedSnapshot
            recipes = snapshot.recipes
            savedRecipeIDs = Set(snapshot.savedRecipeIDs)
            shoppingSections = snapshot.shoppingSections
            todaysPickID = snapshot.todaysPickID
            trendingRecipeIDs = snapshot.trendingRecipeIDs
            generatedRecipeIDs = snapshot.generatedRecipeIDs
            derivedCheckedIDs = Set(snapshot.derivedCheckedIDs)
            persist()
        }
    }

    var todaysPick: Recipe {
        recipe(for: todaysPickID) ?? recipes.first ?? SampleData.todaysPick
    }

    var trendingRecipes: [Recipe] {
        trendingRecipeIDs.compactMap { recipe(for: $0) }
    }

    var savedRecipes: [Recipe] {
        recipes.filter { savedRecipeIDs.contains($0.id) }
    }

    var recentGenerated: [Recipe] {
        generatedRecipeIDs.compactMap { recipe(for: $0) }
    }

    var derivedShoppingItems: [DerivedShoppingItem] {
        savedRecipes.flatMap { recipe in
            recipe.detail.ingredients.map { ingredient in
                let id = "\(recipe.id.uuidString)|\(ingredient.name)|\(ingredient.amount)"
                return DerivedShoppingItem(
                    id: id,
                    name: ingredient.name,
                    note: "\(ingredient.amount) · \(recipe.title)",
                    isChecked: derivedCheckedIDs.contains(id)
                )
            }
        }
    }

    func recipe(for id: UUID) -> Recipe? {
        recipes.first { $0.id == id }
    }

    func isSaved(_ recipe: Recipe) -> Bool {
        savedRecipeIDs.contains(recipe.id)
    }

    func toggleSaved(_ recipe: Recipe) {
        if savedRecipeIDs.contains(recipe.id) {
            savedRecipeIDs.remove(recipe.id)
        } else {
            savedRecipeIDs.insert(recipe.id)
        }
        persist()
    }

    func toggleDerivedItem(id: String) {
        if derivedCheckedIDs.contains(id) {
            derivedCheckedIDs.remove(id)
        } else {
            derivedCheckedIDs.insert(id)
        }
        persist()
    }

    func generateRecipe(vibe: String, time: String, diet: String, method: String) -> Recipe {
        let titleOptions = ["Skillet", "Bowl", "Plate", "Skewers", "Salad"]
        let flavorOptions = ["Citrus", "Smoky", "Herb", "Ginger", "Miso"]
        let accents = ["charred greens", "warm grains", "tahini drizzle", "chili crunch", "lemon yogurt"]

        let title = "\(vibe) \(diet) \(titleOptions.randomElement() ?? "Bowl")"
        let subtitle = "\(flavorOptions.randomElement() ?? "Citrus") notes, \(accents.randomElement() ?? "lemon yogurt")"

        let ingredients = [
            Ingredient(name: "Primary protein", amount: "2 portions"),
            Ingredient(name: "Seasoning blend", amount: "1 tbsp"),
            Ingredient(name: "Fresh herb", amount: "1/2 cup"),
            Ingredient(name: "Citrus", amount: "1"),
            Ingredient(name: "Base grain", amount: "1 cup")
        ]

        let steps = [
            "Prep ingredients and season generously.",
            "Cook the base using the \(method.lowercased()) method.",
            "Sear the main components until golden.",
            "Toss everything together with citrus and herbs.",
            "Finish with a final drizzle and serve warm."
        ]

        let recipe = Recipe(
            title: title,
            subtitle: subtitle,
            cookTime: time,
            difficulty: diet,
            tags: [time, diet, method],
            detail: RecipeDetail(
                totalTime: time,
                serves: "2 servings",
                ingredients: ingredients,
                steps: steps,
                nutrition: [
                    NutritionStat(value: "460", label: "kcal"),
                    NutritionStat(value: "22g", label: "protein"),
                    NutritionStat(value: "8g", label: "fiber")
                ]
            )
        )

        recipes.insert(recipe, at: 0)
        generatedRecipeIDs.insert(recipe.id, at: 0)
        generatedRecipeIDs = Array(generatedRecipeIDs.prefix(6))
        persist()
        return recipe
    }

    func addShoppingItem(name: String, note: String, sectionID: UUID) {
        guard let index = shoppingSections.firstIndex(where: { $0.id == sectionID }) else { return }
        let item = ShoppingItem(name: name, note: note)
        shoppingSections[index].items.append(item)
        persist()
    }

    func toggleShoppingItem(sectionID: UUID, itemID: UUID) {
        guard let sectionIndex = shoppingSections.firstIndex(where: { $0.id == sectionID }) else { return }
        guard let itemIndex = shoppingSections[sectionIndex].items.firstIndex(where: { $0.id == itemID }) else { return }
        shoppingSections[sectionIndex].items[itemIndex].isChecked.toggle()
        persist()
    }

    func removeShoppingItem(sectionID: UUID, itemID: UUID) {
        guard let sectionIndex = shoppingSections.firstIndex(where: { $0.id == sectionID }) else { return }
        shoppingSections[sectionIndex].items.removeAll { $0.id == itemID }
        persist()
    }

    private func persist() {
        let snapshot = AppStoreSnapshot(
            recipes: recipes,
            savedRecipeIDs: Array(savedRecipeIDs),
            shoppingSections: shoppingSections,
            todaysPickID: todaysPickID,
            trendingRecipeIDs: trendingRecipeIDs,
            generatedRecipeIDs: generatedRecipeIDs,
            derivedCheckedIDs: Array(derivedCheckedIDs)
        )

        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }
}
