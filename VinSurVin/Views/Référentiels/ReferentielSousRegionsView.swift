import SwiftUI
import SwiftData

struct ReferentielSousRegionsView: View {
    @Query(filter: #Predicate<Provenance> { $0.typeProvenance == "sousRegion" }, sort: \Provenance.nomProvenance) private var provenances: [Provenance]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    
    var filteredSousRegions: [Provenance] {
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
                ForEach(filteredSousRegions) { provenance in
                    Text(provenance.nomProvenance)
                }
            }
            .navigationTitle("Sous-régions")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}

#Preview {
    ReferentielSousRegionsView()
}
