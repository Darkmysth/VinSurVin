import SwiftData
import SwiftUI

class ListeBouteillesModel: ObservableObject {
    @Published var bouteilles: [Bouteille] = [] // Stocke les bouteilles
    @Published var rechercheUtilisateur: String = ""

    // Récupération de tous les bouteilles de la cave
    func listeBouteilles(from modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Bouteille>(
            predicate: #Predicate { bouteille in bouteille.quantite > 0 }
        )
        do {
            bouteilles = try modelContext.fetch(fetchDescriptor) // Récupère les bouteilles
        } catch {
            print("Erreur lors du fetch des bouteilles :", error)
        }
    }
    
    // Filtrage et regroupement
    var bouteillesFiltrees: [Bouteille] {
        if rechercheUtilisateur.isEmpty {
            return bouteilles
        } else {
            return bouteilles.filter { bouteille in
                bouteille.millesime?.vin?.nomVin.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil ||
                bouteille.millesime?.vin?.provenance.nomProvenance.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil ||
                bouteille.millesime?.vin?.provenance.sousRegionParente?.nomProvenance.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil ||
                bouteille.millesime?.vin?.provenance.regionParente?.nomProvenance.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
            }
        }
    }

    var bouteillesFiltreesParRegion: [String: [Bouteille]] {
        Dictionary(grouping: bouteillesFiltrees, by: { bouteille in
            bouteille.millesime?.vin?.provenance.regionParente?.nomProvenance ?? "Inconnue"
        })
    }
    
    
}
