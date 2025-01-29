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
            GraphiqueHomeView(data: data)
        }
    }
}
