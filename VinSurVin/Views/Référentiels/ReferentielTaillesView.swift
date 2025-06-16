import SwiftUI
import SwiftData

struct ReferentielTaillesView: View {
    @Query(sort: \Taille.volume) private var tailles: [Taille]
    @Environment(\.modelContext) var modelContext
    @State private var rechercheUtilisateur: String = ""
 
    // Création d'une propriété calculée qui retourne un tableau de type [Taille] (des tailles filtrées selon la recherche de l'utilisateur)
    var listeTaillesFiltree: [Taille] {
        if rechercheUtilisateur.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return tailles
        }
        // Si la recherche n'est pas vide, alors il n'y a pas encore eu de retour donc on continue le calcul, et retourne le tableau 'tailles' mais filtré avec la méthode '.filter' disponible pour toutes les propriétés de type 'tableau'
        return tailles.filter { taille in // Rechercher sur toutes les occurrences 'taille' du tableau [tailles]
            taille.nomTaille.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listeTaillesFiltree) { taille in
                    HStack {
                        Text(taille.nomTaille)
                        Spacer()
                        Text(numberFormatter.string(from: NSNumber(value: taille.volume)) ?? "\(taille.volume)")
                        Text(taille.uniteVolume)
                    }
                }
            }
            .navigationTitle("Tailles")
            .searchable(text: $rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
