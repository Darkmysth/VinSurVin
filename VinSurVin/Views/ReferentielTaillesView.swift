import SwiftUI
import SwiftData

struct ReferentielTaillesView: View {
    @Query private var tailles: [Taille]
    @Environment(\.modelContext) var modelContext
    
    // Créer un NumberFormatter pour afficher des nombres avec des séparateurs de milliers
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // Utiliser le style décimal
        formatter.groupingSeparator = " " // Séparateur de milliers
        formatter.decimalSeparator = "," // Séparateur décimal
        return formatter
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tailles) { taille in
                    HStack {
                        Text(taille.nomTaille)
                        Text(numberFormatter.string(from: NSNumber(value: taille.volume)) ?? "\(taille.volume)")
                        Text(taille.uniteVolume)
                    }
                }
            }.navigationTitle("Tailles")
        }
    }
}

#Preview {
    ReferentielTaillesView()
}
