import SwiftUI
import SwiftData

@MainActor
class CaveAppellationsViewModel: ObservableObject {
    
    struct SousRegionEtAppellations: Identifiable {
        let id = UUID()
        let sousRegion: Provenance?
        let appellations: [AppellationRecap]
    }

    struct AppellationRecap: Identifiable {
        let id = UUID()
        let appellation: Provenance
        let quantite: Int
    }
    
    @Published var sousRegionsEtAppellations: [SousRegionEtAppellations] = []
    
    func chargerSousRegionsEtAppellations(couleurFiltre: Couleur, regionFiltre: Provenance, from context: ModelContext) {
        sousRegionsEtAppellations = []
        
        let predicate = #Predicate<Bouteille> { $0.quantite > 0 }
        let fetchDescriptor = FetchDescriptor<Bouteille>(predicate: predicate)
        
        do {
            let listeBouteilles = try context.fetch(fetchDescriptor)
            let listeBouteillesFiltrees = listeBouteilles.filter {
                $0.millesime.vin.couleur == couleurFiltre && $0.millesime.vin.provenance.regionParente == regionFiltre
            }
            
            let bouteillesGroupees = Dictionary(grouping: listeBouteillesFiltrees) { $0.millesime.vin.provenance.sousRegionParente }
            
            for (sousRegion, bouteillesDeLaSousRegion) in bouteillesGroupees {
                var appellationMap: [Provenance: Int] = [:]
                
                for bouteille in bouteillesDeLaSousRegion {
                    let appellation = bouteille.millesime.vin.provenance
                    appellationMap[appellation, default: 0] += bouteille.quantite
                }
                
                let appellations = appellationMap.map { AppellationRecap(appellation: $0.key, quantite: $0.value) }
                    .sorted { $0.appellation.nomProvenance < $1.appellation.nomProvenance }
                
                sousRegionsEtAppellations.append(SousRegionEtAppellations(sousRegion: sousRegion, appellations: appellations))
            }
            
            sousRegionsEtAppellations.sort { $0.sousRegion?.nomProvenance ?? "Aucune sous-région" < $1.sousRegion?.nomProvenance ?? "Aucune sous-région" }

        } catch {
            print("Erreur : \(error)")
        }
    }
}

