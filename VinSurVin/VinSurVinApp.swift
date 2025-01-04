import SwiftUI
import SwiftData

@main
struct VinSurVinApp: App {
    // Déclaration du container qui sera utilisé pour agir sur la base de données
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Bouteille.self,
            Classification.self,
            Domaine.self,
            Provenance.self,
            Taille.self,
            Vin.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Accueil", systemImage: "house")
                    }
                FonctionnalitesView()
                    .tabItem {
                        Label("Fonctionnalités", systemImage: "square.grid.3x3")
                    }
                ReferentielsView()
                    .tabItem {
                        Label("Référentiels", systemImage: "chart.bar.horizontal.page")
                    }
                ReglagesView()
                    .tabItem {
                        Label("Réglages", systemImage: "gear")
                    }
            }
            .onAppear {
                // Appel de la méthode pour injecter les données
                injectInitialDataIfNeeded()
            }
            // Injection du ModelContainer dans l'environnement <=> donc dans toutes les vues de l'application étant donné qu'elles partent toutes d'ici
            .modelContainer(sharedModelContainer)        }
    }
    
    // Méthode pour injecter les données initiales au lancement de l'application
    private func injectInitialDataIfNeeded() {
        
        let context = sharedModelContainer.mainContext
        JSONDataImporter.insertInitialDataIfNeeded(context: context)
    }
}
