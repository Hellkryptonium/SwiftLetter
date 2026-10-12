import Foundation

enum NewsletterCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case swift = "Swift"
    case ios = "iOS"
    case ai = "AI"
    case clubUpdates = "Club Updates"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .swift: return "swift"
        case .ios: return "iphone"
        case .ai: return "sparkles"
        case .clubUpdates: return "person.3"
        }
    }
}