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
        
        let predicate = #Predicate<Millesime> { $0.quantiteBouteilles > 0 }
        let fetchDescriptor = FetchDescriptor<Millesime>(predicate: predicate)
        
        do {
            let millesimes = try context.fetch(fetchDescriptor)
            
            let grouped = Dictionary(grouping: millesimes) { $0.vin.couleur }
            
            for (couleur, millesimesDeLaCouleur) in grouped {
                var regionMap: [Provenance: Int] = [:]
                
                for millesime in millesimesDeLaCouleur {
                    if let region = millesime.vin.provenance.regionParente {
                        regionMap[region, default: 0] += millesime.quantiteBouteilles
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
    
    @Published var listeMillesimes: [Millesime] = []
    
    // Méthode pour charger les millesimes depuis SwiftData
    func chargerMillesimes(depuis context: ModelContext) {
        let fetch = FetchDescriptor<Millesime>()
        do {
            listeMillesimes = try context.fetch(fetch)
        } catch {
            print("Erreur de chargement des millesimes : \(error)")
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

