import SwiftUI
import SwiftData

struct ReferentielsView: View {
    
    var body: some View {
        NavigationStack {
            List {
                // Lien vers la vue de gestion des Pays
                NavigationLink(destination: ReferentielPaysView()) {
                    HStack {
                        Image(systemName: "globe.europe.africa")
                        Text("Pays")
                    }
                }
                // Lien vers la vue de gestion des Régions
                NavigationLink(destination: ReferentielRegionsView()) {
                    HStack {
                        Image(systemName: "globe.europe.africa")
                        Text("Régions")
                    }
                }
                // Lien vers la vue de gestion des Sous-régions
                NavigationLink(destination: ReferentielSousRegionsView()) {
                    HStack {
                        Image(systemName: "globe.europe.africa")
                        Text("Sous-régions")
                    }
                }
                // Lien vers la vue de gestion des Appellations
                NavigationLink(destination: ReferentielAppellationsView()) {
                    HStack {
                        Image(systemName: "globe.europe.africa")
                        Text("Appellations")
                    }
                }
                // Lien vers la vue de gestion des Tailles
                NavigationLink(destination: ReferentielTaillesView()) {
                    HStack {
                        Image(systemName: "square.resize.up")
                        Text("Tailles")
                    }
                }
                // Lien vers la vue de gestion des Classifications
                NavigationLink(destination: ReferentielClassificationsView()) {
                    HStack {
                        Image(systemName: "medal")
                        Text("Classifications")
                    }
                }
                // Lien vers la vue de gestion des Vignobles
                NavigationLink(destination: ReferentielVignoblesView()) {
                    HStack {
                        Image(systemName: "star")
                        Text("Vignobles")
                    }
                }
            }.navigationTitle("Référentiels") // Titre de la vue
        }
    }
}

#Preview {
    ReferentielsView()
}
