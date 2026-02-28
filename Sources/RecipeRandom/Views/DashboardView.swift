import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: AppStore
    @State private var isGeneratePresented = false

    private var todaysPick: Recipe {
        store.todaysPick
    }

    private var trendingRecipes: [Recipe] {
        store.trendingRecipes
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                quickStats
                heroCard
                trendingSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 30)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $isGeneratePresented) {
            GenerateRecipeView()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Hi Aaryaman")
                .font(.custom("Avenir Next", size: 16))
                .foregroundStyle(Theme.textSecondary)
            Text("Randomize dinner")
                .font(.custom("Baskerville", size: 34))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)
        }
    }

    private var quickStats: some View {
        HStack(spacing: 12) {
            StatPill(icon: "clock", value: "25 min", label: "Avg cook time")
            StatPill(icon: "flame", value: "4 new", label: "Fresh ideas")
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Tonight's pick")
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)

            Text(todaysPick.title)
                .font(.custom("Baskerville", size: 26))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            Text(todaysPick.subtitle)
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)

            HStack(spacing: 10) {
                ForEach(todaysPick.tags, id: \.self) { tag in
                    TagPill(text: tag)
                }
            }

            HStack(spacing: 12) {
                NavigationLink {
                    RecipeDetailView(recipe: todaysPick)
                } label: {
                    Text("View recipe")
                        .font(.custom("Avenir Next", size: 14))
                        .fontWeight(.semibold)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Theme.cardHighlight)
                        .foregroundStyle(Theme.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)

                Button(action: { isGeneratePresented = true }) {
                    HStack {
                        Text("Generate another")
                        Image(systemName: "shuffle")
                    }
                    .font(.custom("Avenir Next", size: 14))
                    .fontWeight(.semibold)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Theme.accent)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.92))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
        .shadow(color: Theme.cardShadow, radius: 18, x: 0, y: 10)
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Trending this week", subtitle: "Light, cozy, and under 40 minutes")

            ForEach(trendingRecipes) { recipe in
                NavigationLink {
                    RecipeDetailView(recipe: recipe)
                } label: {
                    RecipeCard(
                        title: recipe.title,
                        subtitle: recipe.subtitle,
                        time: recipe.cookTime,
                        difficulty: recipe.difficulty
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppStore(preview: true))
}
