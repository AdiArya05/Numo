import SwiftUI

enum NumoTheme {
    static let background = Color(red: 0.115, green: 0.115, blue: 0.115)
    static let surface = Color(red: 0.18, green: 0.18, blue: 0.18)
    static let elevatedSurface = Color(red: 0.205, green: 0.205, blue: 0.205)
    static let border = Color.white.opacity(0.42)
    static let divider = Color.white.opacity(0.30)
    static let secondaryText = Color.white.opacity(0.48)
    static let mint = Color(red: 0.15, green: 0.89, blue: 0.58)
    static let expense = Color(red: 1.0, green: 0.34, blue: 0.31)
    static let recurring = Color(red: 0.31, green: 0.78, blue: 0.94)
    static let categories = Color(red: 0.72, green: 0.48, blue: 1.0)
    static let activity = Color(red: 1.0, green: 0.70, blue: 0.25)

    static func categoryColor(_ category: String) -> Color {
        switch category {
        case "Housing":
            Color(red: 0.22, green: 0.72, blue: 0.78)
        case "Food":
            Color(red: 0.94, green: 0.76, blue: 0.20)
        case "Shopping":
            Color(red: 0.72, green: 0.55, blue: 0.92)
        case "Subscriptions":
            Color(red: 0.35, green: 0.72, blue: 0.95)
        case "Transport":
            Color(red: 0.98, green: 0.53, blue: 0.24)
        case "Entertainment":
            Color(red: 0.95, green: 0.38, blue: 0.62)
        case "Health":
            Color(red: 0.30, green: 0.84, blue: 0.56)
        default:
            Color(red: 0.48, green: 0.52, blue: 0.90)
        }
    }
}

extension View {
    func numoCard(cornerRadius: CGFloat = 32) -> some View {
        background(NumoTheme.surface, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(NumoTheme.border, lineWidth: 0.8)
            }
    }
}
