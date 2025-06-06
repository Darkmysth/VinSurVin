import SwiftUI
import SwiftData

struct SelectVinView: View {
    @Query(sort: \Vin.nomVin) private var vins: [Vin]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    @State private var isPresentingAddVinView = false
    @Binding var selectedVin: Vin?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Vin] (des vins filtrés selon la recherche de l'utilisateur)
    var filteredVins: [Vin] {
        if searchQuery.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return vins
        }
        return vins.filter { vin in // Rechercher sur toutes les occurrences 'vin' du tableau [vins]
            vin.nomVin.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredVins) { vin in
                    Button {
                        selectedVin = vin
                    } label: {
                        Text(vin.nomVin)
                    }
                }
                .onDelete(perform: deleteVin)
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
                AddVinView(selectedVin: $selectedVin)
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
        .onChange(of: selectedVin) {
            if selectedVin != nil {
                dismiss()
            }
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
