import SwiftData
import SwiftUI

@MainActor
class ConservationViewModel: ObservableObject {
    
    // Création de la propriété listant les différents statuts de conservation
    enum StatutConservation {
        case conservation
        case apogee
        case derniereAnneeApogee
        case declin
    }
    // Création de la structure du tableau qui sera renvoyé par la fonction de chargement des bouteilles
    struct LimiteConservationBouteille {
        let bouteille: Bouteille
        let statut: StatutConservation
    }
    
    // Création de la structure utilisée pour afficher le stock de bouteilles par statut de conservation
    struct QuantiteParStatut {
        let statut: StatutConservation
        let quantite: Int
    }
    
    // Propriétés permettant de gérer les dates
    let componentDay = DateComponents(day: 1)
    let calendar = Calendar.current
    
    // Création des variables qui seront envoyées à la vue
    @Published var searchQuery: String = ""
    @Published private(set) var bouteillesFiltreesSelonStatut: [LimiteConservationBouteille] = []
    
    // Création de la propriété correspondant au paramètre envoyé à l'ouverture de la vue
    private let statutFiltre: StatutConservation?
    init(statut: StatutConservation? = nil) {
        self.statutFiltre = statut
    }
    
    // Méthode chargeant toutes les bouteilles en stock avec leur statut de conservation
    func chargerBouteillesLimiteConservation(from context: ModelContext) {
        do {
            let listeBouteilles = try context.fetch(FetchDescriptor<Bouteille>(
                predicate: #Predicate<Bouteille> { $0.quantiteBouteilles > 0 }
            ))
            let listeBouteillesAvecStatut = listeBouteilles.map { bouteille -> LimiteConservationBouteille in
                let maintenant = Date()
                let statut: StatutConservation
                if maintenant < bouteille.dateConsommationMin {
                    statut = .conservation
                } else if let unAnAvantApogeeMax = calendar.date(byAdding: .year, value: -1, to: bouteille.dateConsommationMax), maintenant <= unAnAvantApogeeMax {
                    statut = .apogee
                } else if maintenant <= bouteille.dateConsommationMax {
                    statut = .derniereAnneeApogee
                } else {
                    statut = .declin
                }
                return LimiteConservationBouteille(bouteille: bouteille, statut: statut)
            }
            let listeBouteillesFiltreesSelonStatut = statutFiltre != nil
                ? listeBouteillesAvecStatut.filter { $0.statut == statutFiltre }
                : listeBouteillesAvecStatut
            self.bouteillesFiltreesSelonStatut = listeBouteillesFiltreesSelonStatut
        } catch {
            print("Erreur : \(error)")
        }
    }
    
    // Propriété calculée permettant d'afficher le stock de bouteilles par statut de conservation
    var quantitesParStatut: [QuantiteParStatut] {
        let grouped = Dictionary(grouping: bouteillesFiltreesSelonStatut) { $0.statut }
        return grouped.map { (statut, bouteilles) in
            let total = bouteilles.reduce(0) { $0 + $1.bouteille.quantiteBouteilles }
            return QuantiteParStatut(statut: statut, quantite: total)
        }
    }
    
    var bouteillesFiltreesSelonStatutAvecRecherche: [LimiteConservationBouteille] {
        guard !searchQuery.isEmpty else {
            return bouteillesFiltreesSelonStatut
        }
        let recherche = searchQuery.lowercased()
        return bouteillesFiltreesSelonStatut.filter {
            let b = $0.bouteille
            return b.vin.nomVin.lowercased().contains(recherche)
                || b.millesime.description.lowercased().contains(recherche)
                || b.vin.provenance.nomProvenance.lowercased().contains(recherche)
                || b.vin.provenance.sousRegionParente?.nomProvenance.lowercased().contains(recherche) == true
                || b.vin.provenance.regionParente?.nomProvenance.lowercased().contains(recherche) == true
        }
    }
    
    var bouteillesFiltreesSelonStatutAvecRechercheGroupeesParCouleur: [(couleur: String, bouteilles: [LimiteConservationBouteille])] {
        let groupes = Dictionary(grouping: bouteillesFiltreesSelonStatutAvecRecherche) { $0.bouteille.vin.couleur.nomCouleur }
        return groupes
            .map { (key, value) in (couleur: key, bouteilles: value) }
            .sorted { $0.couleur < $1.couleur }
    }
    
    // Gestion du titre
    var titre: String {
        switch statutFiltre {
        case .conservation:
            return "Bouteilles à conserver"
        case .apogee:
            return "Bouteilles à leur apogée"
        case .derniereAnneeApogee:
            return "Bouteilles dans leur dernière année"
        case .declin:
            return "Bouteilles en declin"
        case .none:
            return "Toutes les bouteilles"
        }
    }
}
