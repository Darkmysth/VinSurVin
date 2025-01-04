import SwiftUI
import SwiftData

struct ReferentielsView: View {
    
    var body: some View {
        NavigationView {
            List {
                // Lien vers la vue de gestion des Provenances
                NavigationLink(destination: ReferentielProvenancesView()) {
                    HStack {
                        Image(systemName: "globe.europe.africa")
                        Text("Provenances")
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
                // Lien vers la vue de gestion des Classifications
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
