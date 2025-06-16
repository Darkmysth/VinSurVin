import SwiftUI
import SwiftData

struct ReferentielVignoblesView: View {
    @Query(sort: [
        SortDescriptor(\Vignoble.typeVignoble, order: .forward),
        SortDescriptor(\Vignoble.nomVignoble, order: . forward)
    ]) private var vignobles: [Vignoble]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
    
    var listeVignoblesFiltree: [Vignoble] {
        if rechercheUtilisateur.isEmpty {
            return vignobles
        }
        return vignobles.filter { vignoble in
            vignoble.nomVignoble.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeVignoblesFiltree) { vignoble in
                    Section(header: Text(vignoble.provenance.nomProvenance)) {
                        HStack {
                            Text(vignoble.typeVignoble)
                            Text(vignoble.nomVignoble)
                        }
                    }
                }
            }
            .navigationTitle("Vignobles")
            .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}

#Preview {
    ReferentielVignoblesView()
        .modelContainer(SampleData.shared.modelContainer)
}

