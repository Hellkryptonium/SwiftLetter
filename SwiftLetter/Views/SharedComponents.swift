import SwiftUI

struct FeaturedNewsletterView: View {
    @Environment(NewsletterViewModel.self) private var viewModel
    let newsletter: Newsletter

    var body: some View {
        NavigationLink(value: newsletter.id) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("FEATURED EDITION")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.1)
                        .foregroundStyle(SwiftLetterTheme.accent)
                    Spacer()
                    CategoryBadge(category: newsletter.category)
                }
                Text(newsletter.title)
                    .font(.system(size: 27, weight: .bold, design: .serif))
                    .foregroundStyle(SwiftLetterTheme.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
                Text(newsletter.summary)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(SwiftLetterTheme.secondaryText)
                    .lineLimit(2)
                HStack {
                    Text(newsletter.publicationDate.formatted(date: .abbreviated, time: .omitted))
                    Text("·")
                    Text("\(newsletter.estimatedReadingTime) min read")
                    Spacer()
                    Button { viewModel.toggleBookmark(for: newsletter) } label: { Image(systemName: newsletter.isBookmarked ? "bookmark.fill" : "bookmark") }
                        .buttonStyle(.plain)
                        .accessibilityLabel(newsletter.isBookmarked ? "Remove bookmark" : "Bookmark newsletter")
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(SwiftLetterTheme.tertiaryText)
            }
            .padding(.vertical, 4)
        }.buttonStyle(.plain)
    }
}

struct CategoryFilterView: View {
    @Binding var selection: NewsletterCategory
    var body: some View {
        HStack {
            Text("Browse")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(SwiftLetterTheme.tertiaryText)
            Spacer()
            Menu {
                ForEach(NewsletterCategory.allCases) { category in
                    Button { selection = category } label: {
                        Label(category.rawValue, systemImage: category.icon)
                    }
                }
            } label: {
                HStack(spacing: 5) {
                    Text(selection.rawValue)
                    Image(systemName: "chevron.down").font(.system(size: 10, weight: .bold))
                }
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(SwiftLetterTheme.primaryText)
            }
        }
        .padding(.vertical, 3)
    }
}

struct SearchField: View {
    @Binding var text: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(SwiftLetterTheme.tertiaryText)
            TextField("Search editions", text: $text).textInputAutocapitalization(.never)
            if !text.isEmpty { Button { text = "" } label: { Image(systemName: "xmark.circle.fill") }.foregroundStyle(SwiftLetterTheme.tertiaryText).accessibilityLabel("Clear search") }
        }
        .padding(.vertical, 11)
        .overlay(alignment: .bottom) { Rectangle().fill(SwiftLetterTheme.border).frame(height: 1) }
    }
}

struct CategoryBadge: View {
    let category: NewsletterCategory
    var body: some View { Text(category.rawValue.uppercased()).font(.system(size: 10, weight: .bold, design: .rounded)).tracking(0.8).foregroundStyle(SwiftLetterTheme.categoryColor(category)) }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage).font(.system(size: 28)).foregroundStyle(SwiftLetterTheme.accent)
            Text(title).font(.system(size: 20, weight: .bold, design: .serif)).foregroundStyle(SwiftLetterTheme.primaryText)
            Text(message).font(.system(size: 14, design: .rounded)).foregroundStyle(SwiftLetterTheme.secondaryText).multilineTextAlignment(.center)
        }.padding(28).frame(maxWidth: .infinity).background(SwiftLetterTheme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ValidationMessage: View {
    let message: String?
    var body: some View { if let message { Text(message).font(.caption).foregroundStyle(.red) } }
}