import SwiftUI
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var listeMillesimes: [Millesime] = []
    
    // Méthode pour charger les bouteilles depuis SwiftData
    func chargerMillesimes(depuis context: ModelContext) {
        let fetch = FetchDescriptor<Millesime>()
        do {
            listeMillesimes = try context.fetch(fetch)
        } catch {
            print("Erreur de chargement des millésimes : \(error)")
            listeMillesimes = []
        }
    }
    
    // Données transformées pour le graphique
    var dataPourGraphique: [(typeVin: String, quantite: Int)] {
        var counts: [String: Int] = [:]
        
        for millesime in listeMillesimes {
            let couleur = millesime.vin.couleur.nomCouleur
            counts[couleur, default: 0] += millesime.quantiteBouteilles
        }
        
        return counts.map { (typeVin: $0.key, quantite: $0.value) }
    }
}
