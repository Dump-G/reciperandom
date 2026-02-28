import SwiftUI

struct RecipeCard: View {
    let title: String
    let subtitle: String
    let time: String
    let difficulty: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Baskerville", size: 22))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            Text(subtitle)
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)

            HStack(spacing: 10) {
                TagPill(text: time)
                TagPill(text: difficulty)
            }
        }
        .padding(18)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
        .shadow(color: Theme.cardShadow, radius: 16, x: 0, y: 8)
    }
}
