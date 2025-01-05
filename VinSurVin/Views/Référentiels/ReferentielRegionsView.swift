import SwiftUI
import SwiftData

struct ReferentielRegionsView: View {
    @Query(filter: #Predicate<Provenance> { $0.typeProvenance == "region" }, sort: \Provenance.nomProvenance) private var provenances: [Provenance]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    
    var filteredRegions: [Provenance] {
        if searchQuery.isEmpty {
            return provenances
        }
        return provenances.filter { provenance in
            provenance.nomProvenance.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredRegions) { provenance in
                    Text(provenance.nomProvenance)
                }
            }
            .navigationTitle("Régions")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}

#Preview {
    ReferentielRegionsView()
}
