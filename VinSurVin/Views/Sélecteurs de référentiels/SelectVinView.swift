import SwiftUI
import SwiftData

struct SelectVinView: View {
    @Query(sort: \Vin.nomVin) private var listeVins: [Vin]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
    @State private var isPresentingAddVinView = false
    @Binding var vinSelectionne: Vin?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Vin] (des vins filtrés selon la recherche de l'utilisateur)
    var listeVinsFiltree: [Vin] {
        if rechercheUtilisateur.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return listeVins
        }
        return listeVins.filter { vin in // Rechercher sur toutes les occurrences 'vin' du tableau [vins]
            vin.nomVin.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeVinsFiltree) { vin in
                    Button {
                        vinSelectionne = vin
                    } label: {
                        Text(vin.nomVin)
                    }
                }
                .onDelete(perform: supprimerVin)
            }
            .navigationTitle("Vins")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingAddVinView = true // Présenter la vue
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddVinView) {
                AjoutVinView(vinSelectionne: $vinSelectionne)
            }
            .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
        .onChange(of: vinSelectionne) {
            if vinSelectionne != nil {
                dismiss()
            }
        }
    }
    
    private func supprimerVin(at offsets: IndexSet) {
        for index in offsets {
            let vin = listeVinsFiltree[index]
            modelContext.delete(vin) // Supprime l'objet du contexte
        }
        
        do {
            try modelContext.save() // Sauvegarde les changements
        } catch {
            print("Erreur lors de la suppression : \(error)")
        }
    }
}
