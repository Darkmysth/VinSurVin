import Charts
import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query private var listeBouteilles: [Bouteille]
    
    // Propriété calculée pour agréger les données par couleur
    private var data: [(typeVin: String, quantite: Int)] {
        var counts: [String: Int] = [:]
        
        // Compter les bouteilles par couleur
        for bouteille in listeBouteilles {
            let couleur = bouteille.vin.couleur.nomCouleur
            counts[couleur, default: 0] += bouteille.quantiteBouteilles
        }
        
        // Convertir en tableau compatible avec `Charts`
        return counts.map { (typeVin: $0.key, quantite: $0.value) }
    }
    
    var body: some View {
        NavigationStack {
            Chart(data, id: \.typeVin) { typeVin, quantite in
                SectorMark(
                    angle: .value("Quantité", quantite),
                    innerRadius: .ratio(0.5),
                    outerRadius: .inset(10),
                    angularInset: 1
                )
                .cornerRadius(4)
                .foregroundStyle(by: .value("Vin", typeVin))
            }
            .chartForegroundStyleScale([
                "Blanc": .yellow,
                "Rouge": .red,
                "Rosé": .pink
            ])
            .chartLegend(position: .topLeading) // Positionne la légende
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Accueil")
                        .font(.largeTitle)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) { // Place le bouton à droite
                    NavigationLink(destination: AddBouteilleView()) {
                        Image(systemName: "plus") // Icône "+"
                    }
                }
            }
        }
    }
}
