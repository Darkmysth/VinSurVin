import SwiftData
import SwiftUI

struct ReferentielDomainesView: View {
    @Query(sort: \Domaine.nomDomaine) private var domaines: [Domaine]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    // Propriété qui ne sert que pour appeler 'AddDomaineView' mais inutile sinon
    @State private var domaineTemporaire: Domaine? = nil
 
    // Création d'une propriété calculée qui retourne un tableau de type [Domaine] (des domaines filtrés selon la recherche de l'utilisateur)
    var filteredDomaines: [Domaine] {
        if searchQuery.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return domaines
        }
        // Si la recherche n'est pas vide, alors il n'y a pas encore eu de retour donc on continue le calcul, et retourne le tableau 'domaines' mais filtré avec la méthode '.filter' disponible pour toutes les propriétés de type 'tableau'
        return domaines.filter { domaine in // Rechercher sur toutes les occurrences 'domaine' du tableau [domaines]
            domaine.nomDomaine.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredDomaines) { domaine in
                    Section(header: Text(domaine.provenance.nomProvenance)) {
                        Text(domaine.nomDomaine)
                    }
                }
                .onDelete(perform: deleteDomaine)
            }
            .navigationTitle("Domaines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddDomaineView(selectedRegion: nil, selectedDomaine: $domaineTemporaire)) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
    
    private func deleteDomaine(at offsets: IndexSet) {
        for index in offsets {
            let domaine = filteredDomaines[index]
            modelContext.delete(domaine) // Supprime l'objet du contexte
        }
        
        do {
            try modelContext.save() // Sauvegarde les changements
        } catch {
            print("Erreur lors de la suppression : \(error)")
        }
    }
}
