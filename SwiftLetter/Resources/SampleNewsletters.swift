import Foundation

enum SampleNewsletters {
    static let all: [Newsletter] = [
        make("The Shape of a Thought", "How SwiftUI turns state into a calm, expressive interface.", .swift, 10, 8, 4),
        make("Concurrency Without the Drama", "A practical mental model for async work that keeps apps responsive.", .swift, 9, 29, 5),
        make("Designing for the Thumb", "Small interface decisions that make an iPhone app feel considered.", .ios, 9, 18, 4),
        make("Accessibility Is a Feature", "A field guide to making everyday SwiftUI controls easier to use.", .ios, 9, 9, 4),
        make("A Smaller AI Footprint", "What on-device intelligence changes about privacy, latency, and product design.", .ai, 8, 27, 5),
        make("The Responsible Prompt", "A student team's checklist for building useful AI features with care.", .ai, 8, 14, 4),
        make("Shipping the Small Thing", "A club project retrospective on finishing a useful app before adding scope.", .clubUpdates, 8, 2, 4),
        make("Notes From the Build Room", "A fictional club update about collaboration, critique, and momentum.", .clubUpdates, 7, 21, 3)
    ]

    private static func make(_ title: String, _ summary: String, _ category: NewsletterCategory, _ month: Int, _ day: Int, _ readingTime: Int) -> Newsletter {
        let body = "This fictional SwiftLetter edition explores \(title.lowercased()) through practical choices and thoughtful craft. It is demonstration content for the Swift Coding Club reader, not an official publication.\n\nThe strongest work begins with a clear promise. Keep the interface understandable, make the important state visible, and let the implementation support the user's real goal instead of adding noise.\n\nA small, dependable release creates better conversations than an ambitious unfinished one. Share the working slice, listen carefully, and improve the part that matters most."
        let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2026, month: month, day: day)) ?? .now
        return Newsletter(title: title, summary: summary, articleBody: body, category: category, publicationDate: date, estimatedReadingTime: readingTime, isSeeded: true)
    }
}