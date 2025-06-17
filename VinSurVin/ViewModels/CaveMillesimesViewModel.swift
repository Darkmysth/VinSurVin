import SwiftData
import SwiftUI

@MainActor
class CaveBouteillesViewModel: ObservableObject {
    
    struct VinEtBouteilles: Identifiable {
        let id = UUID()
        let vin: Vin?
        let bouteilles: [BouteilleRecap]
    }

    struct BouteilleRecap: Identifiable {
        let id = UUID()
        let bouteille: Bouteille
        let quantite: Int
    }
    
    @Published var vinsEtBouteilles: [VinEtBouteilles] = []
    
    func chargerVinsEtBouteilles(couleurFiltre: Couleur, appellationFiltre: Provenance, from context: ModelContext) {
        vinsEtBouteilles = []
        
        let predicate = #Predicate<Bouteille> { $0.quantite > 0 }
        let fetchDescriptor = FetchDescriptor<Bouteille>(predicate: predicate)
        
        do {
            let listeBouteilles = try context.fetch(fetchDescriptor)
            let listeBouteillesFiltrees = listeBouteilles.filter {
                $0.millesime?.vin?.couleur == couleurFiltre && $0.millesime?.vin?.provenance == appellationFiltre
            }
            
            let bouteillesGroupees = Dictionary(grouping: listeBouteillesFiltrees) { $0.millesime?.vin }
            
            for (vin, bouteillesDuVin) in bouteillesGroupees {
                var bouteilleMap: [Bouteille: Int] = [:]
                
                for bouteille in bouteillesDuVin {
                    bouteilleMap[bouteille, default: 0] += bouteille.quantite
                }
                
                let bouteilles = bouteilleMap.map { BouteilleRecap(bouteille: $0.key, quantite: $0.value) }
                    .sorted { $0.bouteille.millesime?.anneeMillesime ?? 0 < $1.bouteille.millesime?.anneeMillesime ?? 0 }
                
                vinsEtBouteilles.append(VinEtBouteilles(vin: vin, bouteilles: bouteilles))
            }
            
            vinsEtBouteilles.sort { $0.vin?.nomVin ?? "Aucun vin" < $1.vin?.nomVin ?? "Aucun vin" }

        } catch {
            print("Erreur : \(error)")
        }
    }
}

