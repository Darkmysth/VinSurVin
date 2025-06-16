import SwiftData
import SwiftUI

struct SelectVignobleView: View {
    var listeVignoblesRegroupesParProvenance: [Vignoble]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
    @Binding var vignobleSelectionne: Vignoble?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Vignoble] (des vignobles filtrés selon la recherche de l'utilisateur)
    var listeVignoblesFiltree: [Vignoble] {
        if rechercheUtilisateur.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return listeVignoblesRegroupesParProvenance
        }
        return listeVignoblesRegroupesParProvenance.filter { vignoble in // Rechercher sur toutes les occurrences 'vignoble' du tableau [listeVignoblesRegroupesParProvenance]
            vignoble.nomVignoble.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeVignoblesFiltree) { vignoble in
                    Button {
                        vignobleSelectionne = vignoble
                        dismiss()
                    } label: {
                        Text(vignoble.nomVignoble)
                    }
                }
            }
            .navigationTitle("Vignobles")
            .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
