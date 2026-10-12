import Foundation
import SwiftData

protocol NewsletterRepository {
    func fetchNewsletters() throws -> [Newsletter]
    func insert(_ newsletter: Newsletter) throws
    func update(_ newsletter: Newsletter) throws
    func delete(_ newsletter: Newsletter) throws
    func seedIfNeeded()
}

@MainActor
final class SwiftDataNewsletterRepository: NewsletterRepository {
    private let context: ModelContext

    init(context: ModelContext) { self.context = context }

    func fetchNewsletters() throws -> [Newsletter] {
        try context.fetch(FetchDescriptor<Newsletter>(sortBy: [SortDescriptor(\Newsletter.publicationDate, order: .reverse)]))
    }

    func insert(_ newsletter: Newsletter) throws {
        context.insert(newsletter)
        try context.save()
    }

    func update(_ newsletter: Newsletter) throws { try context.save() }

    func delete(_ newsletter: Newsletter) throws {
        context.delete(newsletter)
        try context.save()
    }

    func seedIfNeeded() {
        do {
            guard try context.fetchCount(FetchDescriptor<Newsletter>()) == 0 else { return }
            SampleNewsletters.all.forEach(context.insert)
            try context.save()
        } catch { print("Sample newsletter seed failed: \(error)") }
    }
}