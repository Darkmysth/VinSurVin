import SwiftUI
import SwiftData

@MainActor
class CaveViewModel: ObservableObject {

    struct CouleurRecap: Identifiable {
        let id = UUID()
        let couleur: Couleur
        let quantite: Int
    }
    
    @Published var couleurs: [CouleurRecap] = []
    
    func chargerCouleurs(from context: ModelContext) {
        couleurs = []

        let predicate = #Predicate<Bouteille> { $0.quantite > 0 }
        let fetchDescriptor = FetchDescriptor<Bouteille>(predicate: predicate)

        do {
            let bouteilles = try context.fetch(fetchDescriptor)

            let regroupementParCouleur = Dictionary(grouping: bouteilles) {
                $0.millesime?.vin?.couleur
            }

            let recap = regroupementParCouleur.compactMap { (couleurOptionnelle, bouteilles) -> CouleurRecap? in
                guard let couleur = couleurOptionnelle else { return nil }
                let total = bouteilles.reduce(0) { $0 + $1.quantite }
                return CouleurRecap(couleur: couleur, quantite: total)
            }

            self.couleurs = recap.sorted { $0.couleur.nomCouleur < $1.couleur.nomCouleur }

        } catch {
            print("Erreur lors du chargement des couleurs : \(error)")
            couleurs = []
        }
    }
    
    @Published var listeBouteilles: [Bouteille] = []
    
    // Méthode pour charger les millesimes depuis SwiftData
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
            let couleur = bouteille.millesime?.vin?.couleur.nomCouleur ?? "Couleur inconnue"
            counts[couleur, default: 0] += bouteille.quantite
        }
        
        return counts.map { (typeVin: $0.key, quantite: $0.value) }
    }
}

