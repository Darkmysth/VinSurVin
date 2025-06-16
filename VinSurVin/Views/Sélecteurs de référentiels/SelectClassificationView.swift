import SwiftData
import SwiftUI

struct SelectClassificationView: View {
    var listeClassificationsRegroupeesParProvenance: [Classification]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
    @Binding var classificationSelectionnee: Classification?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Classification] des classifications filtrées selon la recherche de l'utilisateur
    var listeClassificationsFiltree: [Classification] {
        if rechercheUtilisateur.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return listeClassificationsRegroupeesParProvenance
        }
        return listeClassificationsRegroupeesParProvenance.filter { classification in // Rechercher sur toutes les occurrences 'classification' du tableau [listeClassificationsRegroupeesParProvenance]
            classification.nomClassification.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeClassificationsFiltree) { classification in
                    Button {
                        classificationSelectionnee = classification
                        dismiss()
                    } label: {
                        Text(classification.nomClassification)
                    }
                }
            }
            .navigationTitle("Classifications")
            .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
