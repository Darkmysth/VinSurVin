import SwiftUI
import SwiftData

struct ReferentielPaysView: View {
    @Query(filter: #Predicate<Provenance> { $0.typeProvenance == "pays" }, sort: \Provenance.nomProvenance) private var provenances: [Provenance]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    
    var filteredPays: [Provenance] {
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
                ForEach(filteredPays) { provenance in
                    Text(provenance.nomProvenance)
                }
            }
            .navigationTitle("Pays")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}

#Preview {
    ReferentielPaysView()
}
