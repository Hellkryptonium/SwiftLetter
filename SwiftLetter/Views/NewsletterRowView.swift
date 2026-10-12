import SwiftUI

struct NewsletterRowView: View {
    @Environment(NewsletterViewModel.self) private var viewModel
    let newsletter: Newsletter

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                CategoryBadge(category: newsletter.category)
                Text(newsletter.title)
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundStyle(SwiftLetterTheme.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
                Text(newsletter.summary)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(SwiftLetterTheme.secondaryText)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(newsletter.publicationDate.formatted(date: .abbreviated, time: .omitted))
                    Text("·")
                    Text("\(newsletter.estimatedReadingTime) min read")
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(SwiftLetterTheme.tertiaryText)
            }
            Spacer(minLength: 4)
            Button { viewModel.toggleBookmark(for: newsletter) } label: {
                Image(systemName: newsletter.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(SwiftLetterTheme.accent)
                    .frame(width: 30, height: 30)
            }.buttonStyle(.plain).accessibilityLabel(newsletter.isBookmarked ? "Remove bookmark" : "Bookmark newsletter")
        }
        .padding(.vertical, 15)
        .overlay(alignment: .bottom) { Rectangle().fill(SwiftLetterTheme.border).frame(height: 1) }
    }
}