import SwiftUI

enum Theme {
    static let background = LinearGradient(
        colors: [Color(red: 0.98, green: 0.95, blue: 0.90), Color(red: 0.95, green: 0.97, blue: 0.98)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accent = Color(red: 0.26, green: 0.45, blue: 0.32)
    static let textPrimary = Color(red: 0.16, green: 0.18, blue: 0.19)
    static let textSecondary = Color(red: 0.38, green: 0.41, blue: 0.43)

    static let cardSurface = Color.white.opacity(0.86)
    static let cardHighlight = Color(red: 0.93, green: 0.89, blue: 0.83)
    static let cardStroke = Color.black.opacity(0.08)
    static let cardShadow = Color.black.opacity(0.08)
}
