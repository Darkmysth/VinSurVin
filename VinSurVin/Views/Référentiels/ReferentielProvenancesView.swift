import SwiftUI
import SwiftData

// Vue principale pour afficher la liste des provenances
struct ReferentielProvenancesView: View {
    // Requête filtrant uniquement les provenances sans provenance parent (<=> uniquement les pays)
    @Query(filter: #Predicate<Provenance> { $0.parent == nil }, sort: \Provenance.nomProvenance) private var provenances: [Provenance]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List(provenances, id: \.nomProvenance) { provenance in
            ProvenanceView(provenance: provenance)
        }.navigationTitle("Provenances")
    }
}

struct ProvenanceView: View {
    var provenance: Provenance
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            // Affiche la provenance courante
            HStack {
                Text(provenance.nomProvenance)
                    .font(.headline)
                    .onTapGesture {
                        isExpanded.toggle() // Toggle pour développer/replier
                    }
                Spacer()
                if !provenance.enfantArray.isEmpty {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut, value: isExpanded)
                }
            }

            // Affiche les enfants si le nœud est développé
            if isExpanded {
                ForEach(provenance.enfantArray.sorted(by: { $0.nomProvenance < $1.nomProvenance }), id: \.nomProvenance) { child in
                    ProvenanceView(provenance: child)
                        .padding(.leading)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
