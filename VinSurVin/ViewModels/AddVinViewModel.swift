import SwiftUI
import SwiftData

@MainActor
class AjoutVinViewModel: ObservableObject {
    
    // Déclare les propriétés qui seront exposées à la vue 'AddVinView', toutes les instances de classe sont optionnelles pour ne pas avoir à gérer d'initialiseur
    @Published var nomVin: String = ""
    @Published var sucrositeSelectionnee: Sucrosite?
    @Published var couleurSelectionnee: Couleur?
    @Published var caracteristiqueSelectionnee: Caracteristique?
    @Published var vignobleSelectionne: Vignoble?
    @Published var domaineSelectionne: Domaine?
    @Published var appellationSelectionnee: Provenance?
    @Published var classificationSelectionnee: Classification?
    @Published var listeVignobles: [Vignoble] = []
    @Published var listeClassifications: [Classification] = []
    @Published var listeVignoblesRegroupesParProvenance: [Vignoble] = []
    @Published var listeClassificationsRegroupeesParProvenance: [Classification] = []
    
    // Propriété calculée qui déduit la région et la sous-région de l'appellation sélectionnée
    var regionSelectionnee: Provenance? {
        appellationSelectionnee?.regionParente
    }
    var sousRegionSelectionnee: Provenance? {
        appellationSelectionnee?.sousRegionParente
    }
    
    // Récupère les classifications éligibles à l'appellation choisie par l'utilisateur
    
        // Méthode permettant de récupérer la liste de toutes les classifications
        func chargerClassifications(from context: ModelContext) {
            let fetchDescriptor = FetchDescriptor<Classification>(sortBy: [SortDescriptor(\Classification.nomClassification)])
            do {
                let results = try context.fetch(fetchDescriptor)
                listeClassifications = results
            } catch {
                print("Erreur : \(error)")
                listeClassifications = []
            }
        }
    
        // Méthode qui retourne un tableau de type [Classification] des classifications filtrées selon la recherche de l'utilisateur
        func filtrerlisteClassificationsRegroupeesParProvenance() {
            listeClassificationsRegroupeesParProvenance = []
            let classifications = listeClassifications.filter { $0.provenance == appellationSelectionnee }
            if !classifications.isEmpty {
                listeClassificationsRegroupeesParProvenance = classifications
            } else {
                let classifications = listeClassifications.filter { $0.provenance == sousRegionSelectionnee }
                if !classifications.isEmpty {
                    listeClassificationsRegroupeesParProvenance = classifications
                } else {
                    let classifications = listeClassifications.filter { $0.provenance == regionSelectionnee }
                    if !classifications.isEmpty {
                        listeClassificationsRegroupeesParProvenance = classifications
                    }
                }
            }
        }
    
    // Récupère les vignobles éligibles à l'appellation choisie par l'utilisateur
    
        // Méthode permettant de récupérer la liste de tous les vignobles
        func chargerVignobles(from context: ModelContext) {
            let fetchDescriptor = FetchDescriptor<Vignoble>(sortBy: [SortDescriptor(\Vignoble.nomVignoble)])
            do {
                let results = try context.fetch(fetchDescriptor)
                listeVignobles = results
            } catch {
                print("Erreur : \(error)")
                listeVignobles = []
            }
        }
        
        // Méthode qui retourne un tableau de type [Vignoble] des vignobles filtrés selon la recherche de l'utilisateur
        func filtrerlisteVignoblesRegroupesParProvenance() {
            listeVignoblesRegroupesParProvenance = []
            let vignobles = listeVignobles.filter { $0.provenance == appellationSelectionnee }
            if !vignobles.isEmpty {
                listeVignoblesRegroupesParProvenance = vignobles
            } else {
                let vignobles = listeVignobles.filter { $0.provenance == sousRegionSelectionnee }
                if !vignobles.isEmpty {
                    listeVignoblesRegroupesParProvenance = vignobles
                } else {
                    let vignobles = listeVignobles.filter { $0.provenance == regionSelectionnee }
                    if !vignobles.isEmpty {
                        listeVignoblesRegroupesParProvenance = vignobles
                    }
                }
            }
        }
    
    // Propriété calculée servant à tester si le formulaire d'ajout de vin est valide
    var isFormComplete: Bool {
        return(!nomVin.isEmpty && appellationSelectionnee != nil && domaineSelectionne != nil)
    }
    
    // Méthode permettant à 'AddVinView' d'enregistrer un nouveau vin
    func enregistrerVin(dans context: ModelContext) -> Vin? {
        
        // Vérifie que les données sont bien récupérées de la vue
        guard let sucrosite = sucrositeSelectionnee,
              let couleur = couleurSelectionnee,
              let caracteristique = caracteristiqueSelectionnee,
              let appellation = appellationSelectionnee,
              let domaine = domaineSelectionne else {
            return nil
        }
        
        let classification = classificationSelectionnee
        let vignoble = vignobleSelectionne
        
        // Crée le nouveau vin
        let nouveauVin = Vin(
            nomVin: nomVin,
            sucrosite: sucrosite,
            couleur: couleur,
            caracteristique: caracteristique,
            provenance: appellation,
            classification: classification,
            domaine: domaine,
            vignoble: vignoble
        )
        
        // Ajoute le nouveau vin au contexte
        context.insert(nouveauVin)
        
        // Sauvegarde le contexte si nécessaire
        do {
            try context.save()
            return nouveauVin
        } catch {
            return nil
        }
    }
}
