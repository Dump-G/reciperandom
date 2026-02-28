import SwiftUI

struct StatPill: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.custom("Avenir Next", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                Text(label)
                    .font(.custom("Avenir Next", size: 11))
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Theme.cardSurface)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
    }
}
