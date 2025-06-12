import SwiftData
import SwiftUI

class ListeMillesimesModel: ObservableObject {
    @Published var millesimes: [Millesime] = [] // Stocke les millésimes
    @Published var rechercheUtilisateur: String = ""

    // Récupération de tous les millésimes de la cave
    func listeMillésimes(from modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Millesime>(
            predicate: #Predicate { millesime in millesime.quantiteBouteilles > 0 }
        )
        do {
            millesimes = try modelContext.fetch(fetchDescriptor) // Récupère les millésimes
        } catch {
            print("Erreur lors du fetch des millésimes :", error)
        }
    }
    
    // Filtrage et regroupement
    var millesimesFiltres: [Millesime] {
        if rechercheUtilisateur.isEmpty {
            return millesimes
        } else {
            return millesimes.filter { millesime in
                millesime.vin.nomVin.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil ||
                millesime.vin.provenance.nomProvenance.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil ||
                millesime.vin.provenance.sousRegionParente?.nomProvenance.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil ||
                millesime.vin.provenance.regionParente?.nomProvenance.range(of: rechercheUtilisateur, options: .caseInsensitive) != nil
            }
        }
    }

    var millesimesFiltresParRegion: [String: [Millesime]] {
        Dictionary(grouping: millesimesFiltres, by: { millesime in
            millesime.vin.provenance.regionParente?.nomProvenance ?? "Inconnue"
        })
    }
    
    
}
