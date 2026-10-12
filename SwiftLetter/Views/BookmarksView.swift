import SwiftUI

struct BookmarksView: View {
    @Environment(NewsletterViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Saved for later").font(.system(size: 36, weight: .bold, design: .serif)).foregroundStyle(SwiftLetterTheme.primaryText).padding(.top, 24)
                    if viewModel.bookmarkedNewsletters.isEmpty {
                        EmptyStateView(title: "Your reading list is quiet", message: "Save an edition from Discover and it will appear here.", systemImage: "bookmark").frame(maxWidth: .infinity)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.bookmarkedNewsletters) { newsletter in
                                NavigationLink(value: newsletter.id) { NewsletterRowView(newsletter: newsletter) }.buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 32)
            }
            .background(SwiftLetterTheme.background.ignoresSafeArea())
            .navigationDestination(for: UUID.self) { id in
                if let newsletter = viewModel.newsletters.first(where: { $0.id == id }) { NewsletterDetailView(newsletter: newsletter) }
            }
        }
    }
}