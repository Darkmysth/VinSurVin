import SwiftData
import SwiftUI

struct SelectClassificationView: View {
    var classificationsByProvenance: [Classification]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    @Binding var selectedClassification: Classification?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Classification] des classifications filtrées selon la recherche de l'utilisateur
    var filteredClassifications: [Classification] {
        if searchQuery.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return classificationsByProvenance
        }
        return classificationsByProvenance.filter { classification in // Rechercher sur toutes les occurrences 'classification' du tableau [classificationsByProvenance]
            classification.nomClassification.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredClassifications) { classification in
                    Button {
                        selectedClassification = classification
                        dismiss()
                    } label: {
                        Text(classification.nomClassification)
                    }
                }
            }
            .navigationTitle("Classifications")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
