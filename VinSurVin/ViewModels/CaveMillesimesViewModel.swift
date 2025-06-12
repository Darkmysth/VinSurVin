import SwiftData
import SwiftUI

@MainActor
class CaveMillesimesViewModel: ObservableObject {
    
    struct VinEtMillesimes: Identifiable {
        let id = UUID()
        let vin: Vin?
        let millesimes: [MillesimeRecap]
    }

    struct MillesimeRecap: Identifiable {
        let id = UUID()
        let millesime: Millesime
        let quantite: Int
    }
    
    @Published var vinsEtMillesimes: [VinEtMillesimes] = []
    
    func chargerVinsEtMillesimes(couleurFiltre: Couleur, appellationFiltre: Provenance, from context: ModelContext) {
        vinsEtMillesimes = []
        
        let predicate = #Predicate<Millesime> { $0.quantiteBouteilles > 0 }
        let fetchDescriptor = FetchDescriptor<Millesime>(predicate: predicate)
        
        do {
            let listeMillesimes = try context.fetch(fetchDescriptor)
            let listeMillesimesFiltres = listeMillesimes.filter {
                $0.vin.couleur == couleurFiltre && $0.vin.provenance == appellationFiltre
            }
            
            let millesimesGroupes = Dictionary(grouping: listeMillesimesFiltres) { $0.vin }
            
            for (vin, millesimesDuVin) in millesimesGroupes {
                var millesimeMap: [Millesime: Int] = [:]
                
                for millesime in millesimesDuVin {
                    let millesime = millesime
                    millesimeMap[millesime, default: 0] += millesime.quantiteBouteilles
                }
                
                let millesimes = millesimeMap.map { MillesimeRecap(millesime: $0.key, quantite: $0.value) }
                    .sorted { $0.millesime.anneeMillesime < $1.millesime.anneeMillesime }
                
                vinsEtMillesimes.append(VinEtMillesimes(vin: vin, millesimes: millesimes))
            }
            
            vinsEtMillesimes.sort { $0.vin?.nomVin ?? "Aucun vin" < $1.vin?.nomVin ?? "Aucun vin" }

        } catch {
            print("Erreur : \(error)")
        }
    }
}

