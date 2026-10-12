import SwiftUI
import SwiftData

@main
struct SwiftLetterApp: App {
    private let modelContainer: ModelContainer
    private let viewModel: NewsletterViewModel

    init() {
        let container = ModelContainerSetup.makeContainer()
        let repository = SwiftDataNewsletterRepository(context: container.mainContext)
        self.modelContainer = container
        self.viewModel = NewsletterViewModel(repository: repository)
        repository.seedIfNeeded()
        viewModel.load()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .modelContainer(modelContainer)
    }
}