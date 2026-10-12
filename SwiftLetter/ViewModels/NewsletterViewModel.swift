import Foundation
import Observation

@MainActor
@Observable
final class NewsletterViewModel {
    private let repository: NewsletterRepository
    private(set) var newsletters: [Newsletter] = []
    var searchText = ""
    var selectedCategory: NewsletterCategory = .all
    var errorMessage: String?

    init(repository: NewsletterRepository) { self.repository = repository }

    var filteredNewsletters: [Newsletter] {
        newsletters.filter { newsletter in
            let matchesCategory = selectedCategory == .all || newsletter.category == selectedCategory
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let searchableText = "\(newsletter.title) \(newsletter.summary) \(newsletter.articleBody)"
            return matchesCategory && (query.isEmpty || searchableText.localizedCaseInsensitiveContains(query))
        }
    }

    var bookmarkedNewsletters: [Newsletter] { newsletters.filter(\.isBookmarked) }
    var featuredNewsletter: Newsletter? { filteredNewsletters.first }

    func load() {
        do { newsletters = try repository.fetchNewsletters() }
        catch { errorMessage = "Your editions could not be loaded. Please try again." }
    }

    func toggleBookmark(for newsletter: Newsletter) {
        newsletter.isBookmarked.toggle()
        do { try repository.update(newsletter) }
        catch { newsletter.isBookmarked.toggle(); errorMessage = "The bookmark could not be saved." }
    }

    func add(_ draft: NewsletterDraft) -> Bool {
        guard draft.isValid else { return false }
        let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let summary = draft.summary.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = draft.articleBody.trimmingCharacters(in: .whitespacesAndNewlines)
        let newsletter = Newsletter(title: title, summary: summary, articleBody: body, category: draft.category, publicationDate: .now, estimatedReadingTime: readingTime(for: body))
        do { try repository.insert(newsletter); load(); return true }
        catch { errorMessage = "The edition could not be published."; return false }
    }

    func update(_ newsletter: Newsletter, with draft: NewsletterDraft) -> Bool {
        guard draft.isValid else { return false }
        newsletter.title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        newsletter.summary = draft.summary.trimmingCharacters(in: .whitespacesAndNewlines)
        newsletter.articleBody = draft.articleBody.trimmingCharacters(in: .whitespacesAndNewlines)
        newsletter.category = draft.category
        newsletter.estimatedReadingTime = readingTime(for: newsletter.articleBody)
        do { try repository.update(newsletter); load(); return true }
        catch { errorMessage = "The edition could not be updated."; return false }
    }

    func delete(_ newsletter: Newsletter) {
        do { try repository.delete(newsletter); load() }
        catch { errorMessage = "The edition could not be deleted." }
    }

    private func readingTime(for body: String) -> Int {
        max(1, Int(ceil(Double(body.split(whereSeparator: { $0.isWhitespace }).count) / 180.0)))
    }
}