import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject private var store: AppStore
    let recipe: Recipe

    init(recipe: Recipe = SampleData.todaysPick) {
        self.recipe = recipe
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                quickFacts
                ingredients
                steps
                nutrition
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 30)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { store.toggleSaved(recipe) }) {
                    Image(systemName: store.isSaved(recipe) ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(Theme.textPrimary)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(recipe.title)
                .font(.custom("Baskerville", size: 32))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            Text(recipe.subtitle)
                .font(.custom("Avenir Next", size: 15))
                .foregroundStyle(Theme.textSecondary)

            HStack(spacing: 8) {
                ForEach(recipe.tags, id: \.self) { tag in
                    TagPill(text: tag)
                }
            }
        }
    }

    private var quickFacts: some View {
        HStack(spacing: 12) {
            StatPill(icon: "clock", value: recipe.detail.totalTime, label: "Total time")
            StatPill(icon: "person.2", value: recipe.detail.serves, label: "Serves")
        }
    }

    private var ingredients: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Ingredients", subtitle: "\(recipe.detail.ingredients.count) items")

            ForEach(recipe.detail.ingredients) { ingredient in
                IngredientRow(name: ingredient.name, amount: ingredient.amount)
            }
        }
    }

    private var steps: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Steps", subtitle: "\(recipe.detail.steps.count) steps")

            ForEach(Array(recipe.detail.steps.enumerated()), id: \.offset) { index, step in
                StepRow(number: String(format: "%02d", index + 1), text: step)
            }
        }
    }

    private var nutrition: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Nutrition", subtitle: "per serving")

            HStack(spacing: 12) {
                ForEach(recipe.detail.nutrition) { stat in
                    NutritionPill(value: stat.value, label: stat.label)
                }
            }
        }
    }
}

private struct IngredientRow: View {
    let name: String
    let amount: String

    var body: some View {
        HStack {
            Text(name)
                .font(.custom("Avenir Next", size: 16))
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Text(amount)
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(12)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
    }
}

private struct StepRow: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.custom("Avenir Next", size: 12))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textSecondary)
                .padding(8)
                .background(Theme.cardHighlight)
                .clipShape(Circle())

            Text(text)
                .font(.custom("Avenir Next", size: 15))
                .foregroundStyle(Theme.textPrimary)
            Spacer()
        }
        .padding(12)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
    }
}

private struct NutritionPill: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.custom("Baskerville", size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)
            Text(label)
                .font(.custom("Avenir Next", size: 11))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
    }
}

#Preview {
    RecipeDetailView()
        .environmentObject(AppStore(preview: true))
}
