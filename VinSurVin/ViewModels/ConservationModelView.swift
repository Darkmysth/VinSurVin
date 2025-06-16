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
    // Création de la structure du tableau qui sera renvoyé par la fonction de chargement des millésimes
    struct LimiteConservationMillesime {
        let millesime: Millesime
        let statut: StatutConservation
    }
    
    // Création de la structure utilisée pour afficher le stock de millésimes par statut de conservation
    struct QuantiteParStatut {
        let statut: StatutConservation
        let quantite: Int
    }
    
    // Propriétés permettant de gérer les dates
    let componentDay = DateComponents(day: 1)
    let calendar = Calendar.current
    
    // Création des variables qui seront envoyées à la vue
<<<<<<< Updated upstream:VinSurVin/ViewModels/ConservationModelView.swift
    @Published var searchQuery: String = ""
    @Published private(set) var millesimesFiltreesSelonStatut: [LimiteConservationMillesime] = []
=======
    @Published var rechercheUtilisateur: String = ""
    @Published private(set) var bouteillesFiltreesSelonStatut: [LimiteConservationBouteille] = []
>>>>>>> Stashed changes:VinSurVin/ViewModels/ConservationViewModel.swift
    
    // Création de la propriété correspondant au paramètre envoyé à l'ouverture de la vue
    private let statutFiltre: StatutConservation?
    init(statut: StatutConservation? = nil) {
        self.statutFiltre = statut
    }
    
    // Méthode chargeant tous les millésimes en stock avec leur statut de conservation
    func chargerMillesimesLimiteConservation(from context: ModelContext) {
        do {
            let listeMillesimes = try context.fetch(FetchDescriptor<Millesime>(
                predicate: #Predicate<Millesime> { $0.quantiteBouteilles > 0 }
            ))
            let listeMillesimesAvecStatut = listeMillesimes.map { millesime -> LimiteConservationMillesime in
                let maintenant = Date()
                let statut: StatutConservation
                if maintenant < millesime.dateConsommationMin {
                    statut = .conservation
                } else if let unAnAvantApogeeMax = calendar.date(byAdding: .year, value: -1, to: millesime.dateConsommationMax), maintenant <= unAnAvantApogeeMax {
                    statut = .apogee
                } else if maintenant <= millesime.dateConsommationMax {
                    statut = .derniereAnneeApogee
                } else {
                    statut = .declin
                }
                return LimiteConservationMillesime(millesime: millesime, statut: statut)
            }
            let listeMillesimesFiltreesSelonStatut = statutFiltre != nil
                ? listeMillesimesAvecStatut.filter { $0.statut == statutFiltre }
                : listeMillesimesAvecStatut
            self.millesimesFiltreesSelonStatut = listeMillesimesFiltreesSelonStatut
        } catch {
            print("Erreur : \(error)")
        }
    }
    
    // Propriété calculée permettant d'afficher le stock de millésimes par statut de conservation
    var quantitesParStatut: [QuantiteParStatut] {
        let grouped = Dictionary(grouping: millesimesFiltreesSelonStatut) { $0.statut }
        return grouped.map { (statut, millesimes) in
            let total = millesimes.reduce(0) { $0 + $1.millesime.quantiteBouteilles }
            return QuantiteParStatut(statut: statut, quantite: total)
        }
    }
    
<<<<<<< Updated upstream:VinSurVin/ViewModels/ConservationModelView.swift
    var millesimesFiltreesSelonStatutAvecRecherche: [LimiteConservationMillesime] {
        guard !searchQuery.isEmpty else {
            return millesimesFiltreesSelonStatut
        }
        let recherche = searchQuery.lowercased()
        return millesimesFiltreesSelonStatut.filter {
            let b = $0.millesime
            return b.vin.nomVin.lowercased().contains(recherche)
                || b.anneeMillesime.description.lowercased().contains(recherche)
                || b.vin.provenance.nomProvenance.lowercased().contains(recherche)
                || b.vin.provenance.sousRegionParente?.nomProvenance.lowercased().contains(recherche) == true
                || b.vin.provenance.regionParente?.nomProvenance.lowercased().contains(recherche) == true
=======
    var bouteillesFiltreesSelonStatutAvecRecherche: [LimiteConservationBouteille] {
        guard !rechercheUtilisateur.isEmpty else {
            return bouteillesFiltreesSelonStatut
        }
        let recherche = rechercheUtilisateur.lowercased()
        return bouteillesFiltreesSelonStatut.filter {
            let b = $0.bouteille
            return b.millesime.vin.nomVin.lowercased().contains(recherche)
            || b.millesime.anneeMillesime.description.lowercased().contains(recherche)
            || b.millesime.vin.provenance.nomProvenance.lowercased().contains(recherche)
            || b.millesime.vin.provenance.sousRegionParente?.nomProvenance.lowercased().contains(recherche) == true
            || b.millesime.vin.provenance.regionParente?.nomProvenance.lowercased().contains(recherche) == true
>>>>>>> Stashed changes:VinSurVin/ViewModels/ConservationViewModel.swift
        }
    }
    
    var millesimesFiltreesSelonStatutAvecRechercheGroupeesParCouleur: [(couleur: String, millesimes: [LimiteConservationMillesime])] {
        let groupes = Dictionary(grouping: millesimesFiltreesSelonStatutAvecRecherche) { $0.millesime.vin.couleur.nomCouleur }
        return groupes
            .map { (key, value) in (couleur: key, millesimes: value) }
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
