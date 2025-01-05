import SwiftUI
import SwiftData

struct ReferentielAppellationsView: View {
    @Query(filter: #Predicate<Provenance> { $0.typeProvenance == "appellation" }, sort: \Provenance.nomProvenance) private var provenances: [Provenance]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    
    var filteredAppellations: [Provenance] {
        if searchQuery.isEmpty {
            return provenances
        }
        return provenances.filter {provenance in
            provenance.nomProvenance.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredAppellations) { provenance in
                    Text(provenance.nomProvenance)
                }
            }
            .navigationTitle("Appellations")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}

#Preview {
    ReferentielAppellationsView()
}
