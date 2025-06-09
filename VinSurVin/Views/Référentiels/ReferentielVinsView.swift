import SwiftData
import SwiftUI

struct ReferentielVinsView: View {
    @Query(sort: \Vin.nomVin) private var vins: [Vin]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    // Propriété qui ne sert que pour appeler 'AddVinView' mais inutile sinon
    @State private var vinTemporaire: Vin? = nil
 
    // Création d'une propriété calculée qui retourne un tableau de type [Vin] (des vins filtrés selon la recherche de l'utilisateur)
    var filteredVins: [Vin] {
        if searchQuery.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return vins
        }
        // Si la recherche n'est pas vide, alors il n'y a pas encore eu de retour donc on continue le calcul, et retourne le tableau 'vins' mais filtré avec la méthode '.filter' disponible pour toutes les propriétés de type 'tableau'
        return vins.filter { vin in // Rechercher sur toutes les occurrences 'vin' du tableau [vins]
            vin.nomVin.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredVins) { vin in
                    Section(header: Text(vin.provenance.regionParente?.nomProvenance ?? "Aucune région")) {
                        Text(vin.nomVin)
                    }
                }
                .onDelete(perform: deleteVin)
            }
            .navigationTitle("Vins")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { // Place le bouton à droite
                    NavigationLink(destination: AddVinView(selectedVin: $vinTemporaire)) {
                        Image(systemName: "plus") // Icône "+"
                    }
                }
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
    
    private func deleteVin(at offsets: IndexSet) {
        for index in offsets {
            let vin = filteredVins[index]
            modelContext.delete(vin) // Supprime l'objet du contexte
        }
        
        do {
            try modelContext.save() // Sauvegarde les changements
        } catch {
            print("Erreur lors de la suppression : \(error)")
        }
    }
}
