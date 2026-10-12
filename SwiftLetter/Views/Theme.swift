import SwiftUI

enum SwiftLetterTheme {
    static let background = Color(light: Color(red: 0.97, green: 0.95, blue: 0.91), dark: Color(red: 0.10, green: 0.11, blue: 0.13))
    static let card = Color(light: Color(red: 0.985, green: 0.98, blue: 0.96), dark: Color(red: 0.16, green: 0.17, blue: 0.19))
    static let ink = Color(light: Color(red: 0.08, green: 0.12, blue: 0.17), dark: Color(red: 0.82, green: 0.78, blue: 0.69))
    static let primaryText = Color(light: Color(red: 0.08, green: 0.10, blue: 0.13), dark: Color(red: 0.93, green: 0.92, blue: 0.89))
    static let secondaryText = Color(light: Color(red: 0.31, green: 0.33, blue: 0.35), dark: Color(red: 0.70, green: 0.71, blue: 0.70))
    static let tertiaryText = Color(light: Color(red: 0.46, green: 0.47, blue: 0.47), dark: Color(red: 0.55, green: 0.56, blue: 0.56))
    static let border = Color(light: Color.black.opacity(0.08), dark: Color.white.opacity(0.12))
    static let accent = Color(light: Color(red: 0.77, green: 0.27, blue: 0.13), dark: Color(red: 0.95, green: 0.48, blue: 0.28))
    static let serifTitle = Font.system(size: 25, weight: .bold, design: .serif)

    static func categoryColor(_ category: NewsletterCategory) -> Color {
        category == .all ? secondaryText : accent
    }
}

private extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light) })
    }
}