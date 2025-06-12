import SwiftUI
import SwiftData

let gradientColors: [Color] = [
    .gradientTop,
    .gradientBottom
]

@main
struct VinSurVinApp: App {
    // Déclaration du container qui sera utilisé pour agir sur la base de données
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Millesime.self,
            Classification.self,
            Domaine.self,
            Provenance.self,
            Taille.self,
            Vin.self,
            Vignoble.self
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
            ZStack {
                LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Accueil", systemImage: "house")
                        }
                    MillesimesCaveView(viewModel: ConservationViewModel(statut: nil))
                        .tabItem {
                            Label("Ma cave", systemImage: "wineglass")
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
                .background(Gradient(colors: gradientColors))
                .onAppear {
                    // Appel de la méthode pour injecter les données
                    injectInitialDataIfNeeded()
                }
                // Injection du ModelContainer dans l'environnement <=> donc dans toutes les vues de l'application étant donné qu'elles partent toutes d'ici
                .modelContainer(sharedModelContainer)
            }
        }
    }
    
    // Méthode pour injecter les données initiales au lancement de l'application
    private func injectInitialDataIfNeeded() {
        
        let context = sharedModelContainer.mainContext
        //JSONDataImporter.deleteAllEntities(context: context)
        JSONDataImporter.insertInitialDataIfNeeded(context: context)
    }
}
