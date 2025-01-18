import SwiftData
import SwiftUI

struct SelectDomaineView: View {
    let selectedRegion: Provenance?
    @Query(sort: \Domaine.nomDomaine) private var allDomaines: [Domaine]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    @State private var isPresentingAddDomaineView = false
    @Binding var selectedDomaine: Domaine?
    @Environment(\.dismiss) private var dismiss
    
    // Domaine filtré par région et recherche
    var filteredDomaines: [Domaine] {
        var domaines = allDomaines
        
        // Filtrer par région si une région est sélectionnée
        if let region = selectedRegion {
            domaines = domaines.filter { $0.provenance == region }
        }
        
        // Appliquer le filtre de recherche
        if !searchQuery.isEmpty {
            domaines = domaines.filter { domaine in
                domaine.nomDomaine.range(of: searchQuery, options: .caseInsensitive) != nil
            }
        }
        
        return domaines
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredDomaines) { domaine in
                    Button {
                        selectedDomaine = domaine
                        dismiss()
                    } label: {
                        Text(domaine.nomDomaine)
                    }
                }
            }
        }
        .navigationTitle("Domaines")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isPresentingAddDomaineView = true // Présenter la vue
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresentingAddDomaineView) {
            AddDomaineView(selectedRegion: selectedRegion)
        }
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
    }
    
    
}
