import SwiftUI

struct ShoppingRow: View {
    let item: String
    let note: String
    let isChecked: Bool
    let onToggle: () -> Void
    let onDelete: (() -> Void)?

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Theme.cardStroke, lineWidth: 1.2)
                        .frame(width: 22, height: 22)
                    Circle()
                        .fill(isChecked ? Theme.accent : Theme.accent.opacity(0.18))
                        .frame(width: 14, height: 14)
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Color.white)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item)
                        .font(.custom("Avenir Next", size: 16))
                        .foregroundStyle(Theme.textPrimary)
                        .strikethrough(isChecked, color: Theme.textSecondary)
                    Text(note)
                        .font(.custom("Avenir Next", size: 12))
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding(14)
            .background(isChecked ? Theme.cardHighlight.opacity(0.55) : Theme.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Theme.cardStroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            if let onDelete {
                Button("Remove", role: .destructive, action: onDelete)
            }
        }
    }
}
