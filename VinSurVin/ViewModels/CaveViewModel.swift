import SwiftUI
import SwiftData

@MainActor
class CaveViewModel: ObservableObject {
    
    struct CouleurEtRegions: Identifiable {
        let id = UUID()
        let couleur: Couleur
        let regions: [RegionRecap]
    }

    struct RegionRecap: Identifiable {
        let id = UUID()
        let region: Provenance
        let quantite: Int
    }
    
    @Published var couleursEtRegions: [CouleurEtRegions] = []
    
    func chargerCouleursEtRegions(from context: ModelContext) {
        couleursEtRegions = []
        
        let predicate = #Predicate<Bouteille> { $0.quantite > 0 }
        let fetchDescriptor = FetchDescriptor<Bouteille>(predicate: predicate)
        
        do {
            let listeBouteilles = try context.fetch(fetchDescriptor)
            
            let listeBouteillesGroupees = Dictionary(grouping: listeBouteilles) { $0.millesime.vin.couleur }
            
            for (couleur, bouteillesDeLaCouleur) in listeBouteillesGroupees {
                var regionMap: [Provenance: Int] = [:]
                
                for bouteille in bouteillesDeLaCouleur {
                    if let region = bouteille.millesime.vin.provenance.regionParente {
                        regionMap[region, default: 0] += bouteille.quantite
                    }
                }
                
                let regions = regionMap.map { RegionRecap(region: $0.key, quantite: $0.value) }
                    .sorted { $0.region.nomProvenance < $1.region.nomProvenance }
                
                couleursEtRegions.append(CouleurEtRegions(couleur: couleur, regions: regions))
            }
            
            couleursEtRegions.sort { $0.couleur.nomCouleur < $1.couleur.nomCouleur }

        } catch {
            print("Erreur : \(error)")
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
            let couleur = bouteille.millesime.vin.couleur.nomCouleur
            counts[couleur, default: 0] += bouteille.quantite
        }
        
        return counts.map { (typeVin: $0.key, quantite: $0.value) }
    }
}

