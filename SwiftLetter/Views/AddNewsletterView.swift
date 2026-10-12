import SwiftUI

struct AddNewsletterView: View {
    @Environment(NewsletterViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    let newsletter: Newsletter?
    @State private var draft: NewsletterDraft
    @State private var isSaving = false

    init(newsletter: Newsletter? = nil) {
        self.newsletter = newsletter
        _draft = State(initialValue: NewsletterDraft(title: newsletter?.title ?? "", summary: newsletter?.summary ?? "", articleBody: newsletter?.articleBody ?? "", category: newsletter?.category ?? .swift))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Edition") {
                    TextField("Title", text: $draft.title)
                    ValidationMessage(message: draft.validationErrors["title"])
                    TextField("Short summary", text: $draft.summary, axis: .vertical)
                    ValidationMessage(message: draft.validationErrors["summary"])
                    Picker("Category", selection: $draft.category) {
                        ForEach(NewsletterCategory.allCases.dropFirst()) { category in Text(category.rawValue).tag(category) }
                    }
                }
                Section("Article") {
                    TextField("Write the complete article", text: $draft.articleBody, axis: .vertical).lineLimit(8...18)
                    ValidationMessage(message: draft.validationErrors["articleBody"])
                }
            }
            .navigationTitle(newsletter == nil ? "New edition" : "Edit edition")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button(newsletter == nil ? "Publish" : "Save") {
                        guard !isSaving else { return }
                        isSaving = true
                        let saved = newsletter.map { viewModel.update($0, with: draft) } ?? viewModel.add(draft)
                        if saved { dismiss() } else { isSaving = false }
                    }
                    .disabled(isSaving)
                }
            }
        }
    }
}