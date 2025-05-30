import SwiftData
import SwiftUI

struct SelectVignobleView: View {
    var vignoblesByProvenance: [Vignoble]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    @Binding var selectedVignoble: Vignoble?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Vignoble] (des vignobles filtrés selon la recherche de l'utilisateur)
    var filteredVignobles: [Vignoble] {
        if searchQuery.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return vignoblesByProvenance
        }
        return vignoblesByProvenance.filter { vignoble in // Rechercher sur toutes les occurrences 'vignoble' du tableau [vignoblesByProvenance]
            vignoble.nomVignoble.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredVignobles) { vignoble in
                    Button {
                        selectedVignoble = vignoble
                        dismiss()
                    } label: {
                        Text(vignoble.nomVignoble)
                    }
                }
            }
            .navigationTitle("Vignobles")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
