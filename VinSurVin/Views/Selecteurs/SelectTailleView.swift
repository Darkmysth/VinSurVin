import SwiftUI
import SwiftData

struct SelectTailleView: View {
    @Query(sort: \Taille.volume) private var tailles: [Taille]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    @Binding var selectedTaille: Taille?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Taille] (des tailles filtrées selon la recherche de l'utilisateur)
    var filteredTailles: [Taille] {
        if searchQuery.isEmpty { // Si l'utilisateur n'a rien saisi, alors retourne l'intégralité de la query initiale
            return tailles
        }
        return tailles.filter { taille in // Rechercher sur toutes les occurrences 'taille' du tableau [tailles]
            taille.nomTaille.range(of: searchQuery, options: .caseInsensitive) != nil
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredTailles) { taille in
                    Button {
                        selectedTaille = taille
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
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
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
