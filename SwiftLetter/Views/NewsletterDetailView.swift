import SwiftUI

struct NewsletterDetailView: View {
    @Environment(NewsletterViewModel.self) private var viewModel
    let newsletter: Newsletter
    @State private var showingEdit = false
    @State private var showingDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                CategoryBadge(category: newsletter.category)
                Text(newsletter.title).font(.system(size: 40, weight: .bold, design: .serif)).foregroundStyle(SwiftLetterTheme.primaryText).fixedSize(horizontal: false, vertical: true)
                Text(newsletter.summary).font(.system(size: 19, weight: .medium, design: .rounded)).foregroundStyle(SwiftLetterTheme.secondaryText)
                HStack { Text(newsletter.publicationDate.formatted(date: .long, time: .omitted)); Text("·"); Text("\(newsletter.estimatedReadingTime) min read") }.font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(SwiftLetterTheme.tertiaryText)
                Divider().overlay(SwiftLetterTheme.border)
                ForEach(Array(newsletter.articleBody.components(separatedBy: "\n\n").enumerated()), id: \.offset) { _, paragraph in
                    Text(paragraph).font(.system(size: 18, design: .serif)).foregroundStyle(SwiftLetterTheme.primaryText).lineSpacing(7)
                }
            }.padding(20).padding(.bottom, 32)
        }
        .background(SwiftLetterTheme.background.ignoresSafeArea()).navigationTitle("Reader").navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button { viewModel.toggleBookmark(for: newsletter) } label: { Image(systemName: newsletter.isBookmarked ? "bookmark.fill" : "bookmark") }.accessibilityLabel(newsletter.isBookmarked ? "Remove bookmark" : "Bookmark newsletter")
                if !newsletter.isSeeded {
                    Button { showingEdit = true } label: { Image(systemName: "pencil") }.accessibilityLabel("Edit newsletter")
                    Button(role: .destructive) { showingDeleteConfirmation = true } label: { Image(systemName: "trash") }.accessibilityLabel("Delete newsletter")
                }
            }
        }
        .sheet(isPresented: $showingEdit) { AddNewsletterView(newsletter: newsletter) }
        .confirmationDialog("Delete this edition?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.delete(newsletter) }
            Button("Cancel", role: .cancel) { }
        } message: { Text("This action cannot be undone.") }
    }
}