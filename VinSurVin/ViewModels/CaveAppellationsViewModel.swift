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
        
        let predicate = #Predicate<Millesime> { $0.quantiteBouteilles > 0 }
        let fetchDescriptor = FetchDescriptor<Millesime>(predicate: predicate)
        
        do {
            let listeMillesimes = try context.fetch(fetchDescriptor)
            let listeMillesimesFiltres = listeMillesimes.filter {
                $0.vin.couleur == couleurFiltre && $0.vin.provenance.regionParente == regionFiltre
            }
            
            let millesimesGroupes = Dictionary(grouping: listeMillesimesFiltres) { $0.vin.provenance.sousRegionParente }
            
            for (sousRegion, millesimesDeLaSousRegion) in millesimesGroupes {
                var appellationMap: [Provenance: Int] = [:]
                
                for millesime in millesimesDeLaSousRegion {
                    let appellation = millesime.vin.provenance
                    appellationMap[appellation, default: 0] += millesime.quantiteBouteilles
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

