import SwiftUI
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var listeBouteilles: [Bouteille] = []
    
    // Méthode pour charger les bouteilles depuis SwiftData
    func chargerBouteilles(depuis context: ModelContext) {
        let fetch = FetchDescriptor<Bouteille>()
        do {
            listeBouteilles = try context.fetch(fetch)
        } catch {
            print("Erreur de chargement des bouteilles : \(error)")
            listeBouteilles = []
        }
    }
    
    // Données transformées pour le graphique
    var dataPourGraphique: [(typeVin: String, quantite: Int)] {
        var counts: [String: Int] = [:]
        
        for bouteille in listeBouteilles {
            let couleur = bouteille.millesime.vin.couleur.nomCouleur
            counts[couleur, default: 0] += bouteille.quantite
        }
        
        return counts.map { (typeVin: $0.key, quantite: $0.value) }
    }
}
