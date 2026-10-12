import Foundation
import SwiftData

@Model
final class Newsletter {
    @Attribute(.unique) var id: UUID
    var title: String
    var summary: String
    var articleBody: String
    var categoryRawValue: String
    var publicationDate: Date
    var creationDate: Date
    var estimatedReadingTime: Int
    var isBookmarked: Bool
    var isSeeded: Bool

    var category: NewsletterCategory {
        get { NewsletterCategory(rawValue: categoryRawValue) ?? .swift }
        set { categoryRawValue = newValue.rawValue }
    }

    init(id: UUID = UUID(), title: String, summary: String, articleBody: String, category: NewsletterCategory, publicationDate: Date, creationDate: Date = .now, estimatedReadingTime: Int, isBookmarked: Bool = false, isSeeded: Bool = false) {
        self.id = id
        self.title = title
        self.summary = summary
        self.articleBody = articleBody
        self.categoryRawValue = category.rawValue
        self.publicationDate = publicationDate
        self.creationDate = creationDate
        self.estimatedReadingTime = estimatedReadingTime
        self.isBookmarked = isBookmarked
        self.isSeeded = isSeeded
    }
}

struct NewsletterDraft {
    var title = ""
    var summary = ""
    var articleBody = ""
    var category: NewsletterCategory = .swift

    var validationErrors: [String: String] {
        var errors: [String: String] = [:]
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors["title"] = "Add a title." }
        if summary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors["summary"] = "Add a short summary." }
        if articleBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors["articleBody"] = "Add the complete article." }
        return errors
    }

    var isValid: Bool { validationErrors.isEmpty }
}