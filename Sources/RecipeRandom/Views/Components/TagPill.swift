import SwiftUI

struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.custom("Avenir Next", size: 12))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Theme.cardHighlight)
            .clipShape(Capsule())
            .foregroundStyle(Theme.textPrimary)
    }
}
