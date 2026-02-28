import SwiftUI

struct ContentView: View {
    @StateObject private var store = AppStore()

    var body: some View {
        TabView {
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "sparkles")
            }

            NavigationStack {
                SavedRecipesView()
            }
            .tabItem {
                Label("Saved", systemImage: "bookmark")
            }

            NavigationStack {
                ShoppingListView()
            }
            .tabItem {
                Label("Shopping", systemImage: "cart")
            }
        }
        .tint(Theme.accent)
        .environmentObject(store)
    }
}

#Preview {
    ContentView()
}
