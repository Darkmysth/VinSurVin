import SwiftData
import SwiftUI

struct SelectAppellationView: View {
    @Query(
        filter: #Predicate { provenance in
            provenance.typeProvenance == "appellation"
        },
        sort: \Provenance.nomProvenance
    ) private var appellations: [Provenance]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
    @Binding var appellationSelectionnee: Provenance?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Provenance] (des appellations issues de Provenance filtrées selon la recherche de l'utilisateur)
    var listeAppellationsFiltree: [Provenance] {
        if rechercheUtilisateur.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return appellations
        }
        return appellations.filter { appellation in // Rechercher sur toutes les occurrences 'appellation' du tableau [appellations]
            appellation.nomProvenance.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeAppellationsFiltree) { appellation in
                    Button {
                        appellationSelectionnee = appellation
                        dismiss()
                    } label: {
                        Text(appellation.nomProvenance)
                    }
                }
            }
            .navigationTitle("Appellations")
            .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
