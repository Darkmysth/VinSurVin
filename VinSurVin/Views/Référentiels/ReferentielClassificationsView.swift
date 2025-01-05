import SwiftUI
import SwiftData

struct ReferentielClassificationsView: View {
    @Query private var classifications: [Classification]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    
    var filteredClassifications: [Classification] {
        if searchQuery.isEmpty {
            return classifications
        }
        return classifications.filter { classification in
            classification.nomClassification.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredClassifications) {classification in
                    Text(classification.nomClassification)
                }
            }
            .navigationTitle("Classifications")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}

#Preview {
    ReferentielClassificationsView()
}
