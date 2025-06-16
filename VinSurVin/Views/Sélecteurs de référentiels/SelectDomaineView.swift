import SwiftData
import SwiftUI

struct SelectDomaineView: View {
    let regionSelectionnee: Provenance?
    @Query(sort: \Domaine.nomDomaine) private var listeDomaines: [Domaine]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
    @State private var isPresentingAddDomaineView = false
    @Binding var domaineSelectionne: Domaine?
    @Environment(\.dismiss) private var dismiss
    
    // Domaine filtré par région et recherche
    var listeDomainesFiltree: [Domaine] {
        var domaines = listeDomaines
        
        // Filtrer par région si une région est sélectionnée
        if let region = regionSelectionnee {
            domaines = domaines.filter { $0.provenance == region }
        }
        
        // Appliquer le filtre de recherche
        if !rechercheUtilisateur.isEmpty {
            domaines = domaines.filter { domaine in
                domaine.nomDomaine.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
            }
        }
        
        return domaines
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeDomainesFiltree) { domaine in
                    Button {
                        domaineSelectionne = domaine
                    } label: {
                        Text(domaine.nomDomaine)
                    }
                }
                .onDelete(perform: supprimerDomaine)
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
            AjoutDomaineView(regionSelectionnee: regionSelectionnee, domaineSelectionne: $domaineSelectionne)
        }
        .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        .onChange(of: domaineSelectionne) {
            if domaineSelectionne != nil {
                dismiss()
            }
        }
    }
    
    private func supprimerDomaine(at offsets: IndexSet) {
        for index in offsets {
            let domaine = listeDomainesFiltree[index]
            modelContext.delete(domaine) // Supprime l'objet du contexte
        }
        
        do {
            try modelContext.save() // Sauvegarde les changements
        } catch {
            print("Erreur lors de la suppression : \(error)")
        }
    }
    
}
