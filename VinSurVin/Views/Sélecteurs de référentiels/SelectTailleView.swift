import SwiftUI
import SwiftData

struct SelectTailleView: View {
    @Query(sort: \Taille.volume) private var listeTailles: [Taille]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
    @Binding var tailleSelectionnee: Taille?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Taille] (des tailles filtrées selon la recherche de l'utilisateur)
    var listeTaillesFiltree: [Taille] {
        if rechercheUtilisateur.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return listeTailles
        }
        return listeTailles.filter { taille in // Rechercher sur toutes les occurrences 'taille' du tableau [tailles]
            taille.nomTaille.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeTaillesFiltree) { taille in
                    Button {
                        tailleSelectionnee = taille
                        dismiss()
                    } label: {
                        HStack {
                            Text(taille.nomTaille)
                            Spacer()
                            Text(numberFormatter.string(from: NSNumber(value: taille.volume)) ?? "\(taille.volume)")
                            Text(taille.uniteVolume)
                        }
                    }
                }
            }
            .navigationTitle("Tailles")
            .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
    
    // Créer un NumberFormatter pour afficher des nombres avec des séparateurs de milliers
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // Utiliser le style décimal
        formatter.groupingSeparator = " " // Séparateur de milliers
        formatter.decimalSeparator = "," // Séparateur décimal
        return formatter
    }
}
