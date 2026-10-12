import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Discover", systemImage: "newspaper") }
            BookmarksView().tabItem { Label("Bookmarks", systemImage: "bookmark") }
        }
        .tint(SwiftLetterTheme.accent)
    }
}