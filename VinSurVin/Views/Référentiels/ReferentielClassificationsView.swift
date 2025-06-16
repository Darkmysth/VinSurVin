import SwiftUI
import SwiftData

struct ReferentielClassificationsView: View {
    @Query(sort: [
        SortDescriptor(\Classification.nomClassification, order: .forward)
        ]) private var classifications: [Classification]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
    
    var listeClassificationsFiltree: [Classification] {
        if rechercheUtilisateur.isEmpty {
            return classifications
        }
        return classifications.filter { classification in
            classification.nomClassification.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeClassificationsFiltree) {classification in
                    HStack {
                        Text(classification.nomClassification)
                    }
                }
            }
            .navigationTitle("Classifications")
            .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
