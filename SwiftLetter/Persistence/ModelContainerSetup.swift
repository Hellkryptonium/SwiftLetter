import Foundation
import SwiftData

enum ModelContainerSetup {
    static func makeContainer() -> ModelContainer {
        let schema = Schema([Newsletter.self])
        let fileManager = FileManager.default
        let supportDirectory = URL.applicationSupportDirectory.appendingPathComponent("SwiftLetter", isDirectory: true)

        do {
            try fileManager.createDirectory(at: supportDirectory, withIntermediateDirectories: true)
            let storeURL = supportDirectory.appendingPathComponent("SwiftLetter.store")
            let configuration = ModelConfiguration("SwiftLetter", schema: schema, url: storeURL, cloudKitDatabase: .none)
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            print("SwiftData persistent store unavailable: \(error). Falling back to an in-memory store.")
            let fallback = ModelConfiguration("SwiftLetterPreview", schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [fallback])
            } catch {
                fatalError("Unable to create even the in-memory SwiftData store: \(error)")
            }
        }
    }
}