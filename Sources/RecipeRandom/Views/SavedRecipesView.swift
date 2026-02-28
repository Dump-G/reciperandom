import SwiftUI

struct SavedRecipesView: View {
    @EnvironmentObject private var store: AppStore

    private var savedRecipes: [Recipe] {
        store.savedRecipes
    }

    private var savedCount: Int {
        savedRecipes.count
    }

    private var vegetarianCount: Int {
        savedRecipes.filter { recipe in
            recipe.tags.contains { $0.lowercased().contains("vegetarian") }
                || recipe.difficulty.lowercased().contains("vegetarian")
        }.count
    }

    private var quickCount: Int {
        savedRecipes.filter { recipe in
            guard let minutes = minutesValue(for: recipe.cookTime) else { return false }
            return minutes <= 25
        }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                grid
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 30)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Saved recipes")
                .font(.custom("Baskerville", size: 30))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            HStack(spacing: 10) {
                TagPill(text: "\(savedCount) saved")
                TagPill(text: "\(vegetarianCount) vegetarian")
                TagPill(text: "\(quickCount) quick")
            }
        }
    }

    private var grid: some View {
        VStack(spacing: 16) {
            if savedRecipes.isEmpty {
                EmptySavedState()
            } else {
                ForEach(savedRecipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        SavedRecipeTile(
                            title: recipe.title,
                            subtitle: recipe.subtitle,
                            tags: recipe.tags
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func minutesValue(for cookTime: String) -> Int? {
        guard let firstChunk = cookTime.split(separator: " ").first else { return nil }
        return Int(firstChunk)
    }
}

private struct SavedRecipeTile: View {
    let title: String
    let subtitle: String
    let tags: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Baskerville", size: 22))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            Text(subtitle)
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)

            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    TagPill(text: tag)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
        .shadow(color: Theme.cardShadow, radius: 14, x: 0, y: 8)
    }
}

private struct EmptySavedState: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("No saved recipes yet")
                .font(.custom("Baskerville", size: 22))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            Text("Tap the bookmark on a recipe to keep it here for later.")
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
    }
}

#Preview {
    SavedRecipesView()
        .environmentObject(AppStore(preview: true))
}
