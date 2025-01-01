import SwiftUI
import SwiftData

@main
struct VinSurVinApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        #if os(iOS)
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Accueil", systemImage: "house")
                    }
                FeaturesView()
                    .tabItem {
                        Label("Fonctionnalités", systemImage: "square.grid.3x3")
                    }
                SettingsView()
                    .tabItem {
                        Label("Réglages", systemImage: "gear")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
        #elseif os(macOS)
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        Settings {
            SettingsView()
        }
        #endif
    }
}
