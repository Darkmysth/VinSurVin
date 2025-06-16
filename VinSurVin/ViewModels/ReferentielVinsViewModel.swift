import SwiftData
import SwiftUI

@MainActor
class ReferentielVinsViewModel: ObservableObject {
    
    // Structure regroupant les vins par région
    struct ListeVinsParRegion: Identifiable {
        let id = UUID()
        let region: String
        let listeVins: [Vin]
    }
    
    // Liste qui sera exposée à la vue
    @Published var rechercheUtilisateur: String = ""
    @Published var listeVinsParRegion: [ListeVinsParRegion] = []
    
    // Méthode de chargement des vins
    func chargerVins(from context: ModelContext) {
        do {
            let listeVins = try context.fetch(FetchDescriptor<Vin>())
            // Regroupement des vins par région
            let listeVinsRegroupesParRegion = Dictionary(grouping: listeVins) { vin in
                vin.provenance.regionParente?.nomProvenance ?? "Région inconnue"
            }
            // Conversion en tableau structuré et trié
            let listeVinsParRegion = listeVinsRegroupesParRegion
                .map { (region, vins) in
                    ListeVinsParRegion(region: region, listeVins: vins.sorted { $0.nomVin < $1.nomVin })
                }
                .sorted { $0.region < $1.region }
            self.listeVinsParRegion = listeVinsParRegion
        } catch {
            print("Erreur lors du chargement des vins : \(error)")
            self.listeVinsParRegion = []
        }
    }
    
    // Propriété calculée qui sera renvoyée
    var listeVinsParRegionFiltree: [ListeVinsParRegion] {
        guard !rechercheUtilisateur.isEmpty else {
            return listeVinsParRegion
        }
        
        return listeVinsParRegion.compactMap { groupe in
            let vinsFiltres = groupe.listeVins.filter {
                $0.nomVin.lowercased().contains(rechercheUtilisateur.lowercased())
            }
            return vinsFiltres.isEmpty ? nil : ListeVinsParRegion(region: groupe.region, listeVins: vinsFiltres)
        }
    }
    
    // Méthode de suppression des vins
    func supprimerVin(_ vin: Vin, from context: ModelContext) {
        context.delete(vin) // Supprime l'objet du contexte
        do {
            try context.save() // Sauvegarde les changements
            chargerVins(from: context) // Recharge la liste après suppression
        } catch {
            print("Erreur lors de la suppression : \(error)")
        }
    }
    
}
