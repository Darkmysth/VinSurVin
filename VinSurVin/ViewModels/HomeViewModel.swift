import SwiftUI
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var listBouteilles: [Bouteille] = []
    
    // Méthode pour charger les bouteilles depuis SwiftData
    func chargerBouteilles(depuis context: ModelContext) {
        let fetch = FetchDescriptor<Bouteille>()
        do {
            listBouteilles = try context.fetch(fetch)
        } catch {
            print("Erreur de chargement des bouteilles : \(error)")
            listBouteilles = []
        }
    }
    
    // Données transformées pour le graphique
    var dataPourGraphique: [(typeVin: String, quantite: Int)] {
        var counts: [String: Int] = [:]
        
        for bouteille in listBouteilles {
            let couleur = bouteille.vin.couleur.nomCouleur
            counts[couleur, default: 0] += bouteille.quantiteBouteilles
        }
        
        return counts.map { (typeVin: $0.key, quantite: $0.value) }
    }
}
