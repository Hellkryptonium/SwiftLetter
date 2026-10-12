import SwiftUI

struct HomeView: View {
    @Environment(NewsletterViewModel.self) private var viewModel
    @State private var showingAddNewsletter = false

    var body: some View {
        @Bindable var viewModel = viewModel
        let remainingNewsletters = Array(viewModel.filteredNewsletters.dropFirst())
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Swift Coding Club")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(SwiftLetterTheme.accent)
                        Text("Ideas worth opening.")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                            .foregroundStyle(SwiftLetterTheme.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Thoughtful notes for curious builders.")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundStyle(SwiftLetterTheme.secondaryText)
                    }
                    SearchField(text: $viewModel.searchText)
                    CategoryFilterView(selection: $viewModel.selectedCategory)
                    if let featured = viewModel.featuredNewsletter { FeaturedNewsletterView(newsletter: featured) }
                    if !remainingNewsletters.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(alignment: .firstTextBaseline) {
                                Text("More editions").font(SwiftLetterTheme.serifTitle)
                                Spacer()
                                Text("\(remainingNewsletters.count)")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(SwiftLetterTheme.tertiaryText)
                            }
                            LazyVStack(spacing: 0) {
                                ForEach(remainingNewsletters) { newsletter in
                                    NavigationLink(value: newsletter.id) { NewsletterRowView(newsletter: newsletter) }.buttonStyle(.plain)
                                }
                            }
                        }
                    } else if viewModel.filteredNewsletters.isEmpty {
                            EmptyStateView(title: "No editions found", message: "Try another search or category.", systemImage: "magnifyingglass")
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 32)
            }
            .background(SwiftLetterTheme.background.ignoresSafeArea())
            .navigationTitle("SwiftLetter")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: UUID.self) { id in
                if let newsletter = viewModel.newsletters.first(where: { $0.id == id }) { NewsletterDetailView(newsletter: newsletter) }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddNewsletter = true } label: { Image(systemName: "plus") }.accessibilityLabel("Add newsletter")
                }
            }
            .sheet(isPresented: $showingAddNewsletter) { AddNewsletterView() }
            .alert("Something went wrong", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: { Text(viewModel.errorMessage ?? "Please try again.") }
        }
    }
}