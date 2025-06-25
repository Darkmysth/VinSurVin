import SwiftData
import SwiftUI

@MainActor
class CaveBouteillesViewModel: ObservableObject {
    
    struct RegionEtAppellations: Identifiable {
        let id = UUID()
        let region: Provenance?
        let appellations: [AppellationEtBouteilles]
    }
    
    struct AppellationEtBouteilles: Identifiable {
        let id = UUID()
        let appellation: Provenance?
        let bouteilles: [BouteilleRecap]
    }

    struct BouteilleRecap: Identifiable {
        let id = UUID()
        let bouteille: Bouteille
        let quantite: Int
    }
    
    @Published var regionsEtAppellations: [RegionEtAppellations] = []
    @Published var appellationsEtBouteilles: [AppellationEtBouteilles] = []
    
    func chargerBouteilles(couleurFiltre: Couleur, from context: ModelContext) {
        regionsEtAppellations = []

        let predicate = #Predicate<Bouteille> { $0.quantite > 0 }
        let fetchDescriptor = FetchDescriptor<Bouteille>(predicate: predicate)

        do {
            let toutesLesBouteilles = try context.fetch(fetchDescriptor)
            let bouteillesFiltrees = toutesLesBouteilles.filter {
                $0.millesime?.vin?.couleur == couleurFiltre
            }

            let groupesParRegion = Dictionary(grouping: bouteillesFiltrees) {
                $0.millesime?.vin?.provenance.regionParente
            }

            var resultat: [RegionEtAppellations] = []

            for (region, bouteillesDeRegion) in groupesParRegion {
                let groupesParAppellation = Dictionary(grouping: bouteillesDeRegion) {
                    $0.millesime?.vin?.provenance
                }

                let sousSections: [AppellationEtBouteilles] = groupesParAppellation.map { (appellation, bouteilles) in
                    let recap = bouteilles.map {
                        BouteilleRecap(bouteille: $0, quantite: $0.quantite)
                    }
                    return AppellationEtBouteilles(appellation: appellation, bouteilles: recap)
                }

                resultat.append(RegionEtAppellations(region: region, appellations: sousSections))
            }

            self.regionsEtAppellations = resultat.sorted {
                ($0.region?.nomProvenance ?? "") < ($1.region?.nomProvenance ?? "")
            }

        } catch {
            print("Erreur de chargement des bouteilles : \(error)")
        }
    }
    
}

