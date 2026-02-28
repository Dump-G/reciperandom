import SwiftUI

struct GenerateRecipeView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedVibe = "Cozy"
    @State private var selectedTime = "30 min"
    @State private var selectedDiet = "Vegetarian"
    @State private var selectedMethod = "One pan"
    @State private var showResult = false
    @State private var generatedRecipe: Recipe?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    preferences
                    generateButton
                    if let recipe = generatedRecipe, showResult {
                        resultCard(for: recipe)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.custom("Avenir Next", size: 15))
                    .foregroundStyle(Theme.textSecondary)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Generate a recipe")
                .font(.custom("Baskerville", size: 30))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            Text("Pick a mood and a few constraints. We will spin up something fresh.")
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private var preferences: some View {
        VStack(alignment: .leading, spacing: 18) {
            preferenceSection(title: "Tonight's vibe", options: ["Cozy", "Bright", "Comfort"], selection: $selectedVibe)
            preferenceSection(title: "Time on hand", options: ["15 min", "30 min", "45 min"], selection: $selectedTime)
            preferenceSection(title: "Diet focus", options: ["Vegetarian", "Seafood", "Protein"], selection: $selectedDiet)
            preferenceSection(title: "Cook style", options: ["One pan", "No cook", "Batch cook"], selection: $selectedMethod)
        }
        .padding(18)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
    }

    private var generateButton: some View {
        Button(action: generateRecipe) {
            HStack {
                Image(systemName: "sparkles")
                Text("Generate recipe")
            }
            .font(.custom("Avenir Next", size: 16))
            .fontWeight(.semibold)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Theme.accent)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func resultCard(for recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your match")
                .font(.custom("Avenir Next", size: 13))
                .foregroundStyle(Theme.textSecondary)

            RecipeCard(
                title: recipe.title,
                subtitle: recipe.subtitle,
                time: recipe.cookTime,
                difficulty: recipe.difficulty
            )

            NavigationLink {
                RecipeDetailView(recipe: recipe)
            } label: {
                Text("Open recipe")
                    .font(.custom("Avenir Next", size: 15))
                    .fontWeight(.semibold)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Theme.cardHighlight)
                    .foregroundStyle(Theme.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
        .shadow(color: Theme.cardShadow, radius: 14, x: 0, y: 8)
    }

    private func generateRecipe() {
        generatedRecipe = store.generateRecipe(
            vibe: selectedVibe,
            time: selectedTime,
            diet: selectedDiet,
            method: selectedMethod
        )
        showResult = true
    }

    private func preferenceSection(title: String, options: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)

            HStack(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    OptionPill(
                        title: option,
                        isSelected: selection.wrappedValue == option
                    ) {
                        selection.wrappedValue = option
                    }
                }
            }
        }
    }
}

private struct OptionPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Avenir Next", size: 13))
                .fontWeight(.semibold)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(isSelected ? Theme.accent : Theme.cardHighlight)
                .foregroundStyle(isSelected ? Color.white : Theme.textPrimary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    GenerateRecipeView()
        .environmentObject(AppStore(preview: true))
}
