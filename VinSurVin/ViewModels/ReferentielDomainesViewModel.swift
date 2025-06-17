import SwiftUI
import SwiftData

@MainActor
class ReferentielDomainesViewModel: ObservableObject {
    
    // Structure regroupant les domaines par région
    struct ListeDomainesParRegion: Identifiable {
        let id = UUID()
        let region: String
        let listeDomaines: [Domaine]
    }
    
    // Liste qui sera exposée à la vue
    @Published var rechercheUtilisateur: String = ""
    @Published var listeDomainesParRegion: [ListeDomainesParRegion] = []
    
    // Méthode de chargement des vins
    func chargerDomaines(from context: ModelContext) {
        do {
            let listeDomaines = try context.fetch(FetchDescriptor<Domaine>())
            // Regroupement des domaines par région
            let listeDomainesRegroupesParRegion = Dictionary(grouping: listeDomaines) { domaine in
                domaine.provenance.regionParente?.nomProvenance ?? "Région inconnue"
            }
            // Conversion en tableau structuré et trié
            let listeDomainesParRegion = listeDomainesRegroupesParRegion
                .map { (region, domaines) in
                    ListeDomainesParRegion(region: region, listeDomaines: domaines.sorted { $0.nomDomaine < $1.nomDomaine })
                }
                .sorted { $0.region < $1.region }
            self.listeDomainesParRegion = listeDomainesParRegion
        } catch {
            print("Erreur lors du chargement des domaines : \(error)")
            self.listeDomainesParRegion = []
        }
    }
    
    // Propriété calculée qui sera renvoyée
    var listeDomainesParRegionFiltree: [ListeDomainesParRegion] {
        guard !rechercheUtilisateur.isEmpty else {
            return listeDomainesParRegion
        }
        
        return listeDomainesParRegion.compactMap { groupe in
            let domainesFiltres = groupe.listeDomaines.filter {
                $0.nomDomaine.lowercased().contains(rechercheUtilisateur.lowercased())
            }
            return domainesFiltres.isEmpty ? nil : ListeDomainesParRegion(region: groupe.region, listeDomaines: domainesFiltres)
        }
    }
    
    // Méthode de suppression des domaines
    func supprimerDomaine(_ domaine: Domaine, from context: ModelContext) {
        context.delete(domaine) // Supprime l'objet du contexte
        do {
            try context.save() // Sauvegarde les changements
            chargerDomaines(from: context) // Recharge la liste après suppression
        } catch {
            print("Erreur lors de la suppression : \(error)")
        }
    }
    
}
