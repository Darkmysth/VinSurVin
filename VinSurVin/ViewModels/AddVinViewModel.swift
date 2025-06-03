import SwiftUI
import SwiftData

@MainActor
class AddVinViewModel: ObservableObject {
    
    // Déclare les propriétés qui seront exposées à la vue 'AddVinView', toutes les instances de classe sont optionnelles pour ne pas avoir à gérer d'initialiseur
    @Published var nomVin: String = ""
    @Published var selectedSucrosite: Sucrosite?
    @Published var selectedCouleur: Couleur?
    @Published var selectedCaracteristique: Caracteristique?
    @Published var selectedVignoble: Vignoble?
    @Published var selectedDomaine: Domaine?
    @Published var selectedAppellation: Provenance?
    @Published var selectedClassification: Classification?
    @Published var allVignobles: [Vignoble] = []
    @Published var allClassifications: [Classification] = []
    @Published var vignoblesByProvenance: [Vignoble] = []
    @Published var classificationsByProvenance: [Classification] = []
    @Published var hasVignobles: Bool = false
    @Published var hasClassifications: Bool = false
    
    // Propriété calculée qui déduit la région et la sous-région de l'appellation sélectionnée
    var selectedRegion: Provenance? {
        selectedAppellation?.regionParente
    }
    var selectedSousRegion: Provenance? {
        selectedAppellation?.sousRegionParente
    }
    
    // Récupère les classifications éligibles à l'appellation choisie par l'utilisateur
    
        // Méthode permettant de récupérer la liste de toutes les classifications
        func chargerClassifications(from context: ModelContext) {
            let fetchDescriptor = FetchDescriptor<Classification>(sortBy: [SortDescriptor(\Classification.nomClassification)])
            do {
                let results = try context.fetch(fetchDescriptor)
                allClassifications = results
            } catch {
                print("Erreur : \(error)")
                allClassifications = []
            }
        }
    
        // Méthode qui retourne un tableau de type [Classification] des classifications filtrées selon la recherche de l'utilisateur
        func filtrerClassificationsByProvenance() {
            classificationsByProvenance = []
            let classifications = allClassifications.filter { $0.provenance == selectedAppellation }
            if !classifications.isEmpty {
                classificationsByProvenance = classifications
            } else {
                let classifications = allClassifications.filter { $0.provenance == selectedSousRegion }
                if !classifications.isEmpty {
                    classificationsByProvenance = classifications
                } else {
                    let classifications = allClassifications.filter { $0.provenance == selectedRegion }
                    if !classifications.isEmpty {
                        classificationsByProvenance = classifications
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
                allVignobles = results
            } catch {
                print("Erreur : \(error)")
                allVignobles = []
            }
        }
        
        // Méthode qui retourne un tableau de type [Vignoble] des vignobles filtrés selon la recherche de l'utilisateur
        func filtrerVignoblesByProvenance() {
            vignoblesByProvenance = []
            let vignobles = allVignobles.filter { $0.provenance == selectedAppellation }
            if !vignobles.isEmpty {
                vignoblesByProvenance = vignobles
            } else {
                let vignobles = allVignobles.filter { $0.provenance == selectedSousRegion }
                if !vignobles.isEmpty {
                    vignoblesByProvenance = vignobles
                } else {
                    let vignobles = allVignobles.filter { $0.provenance == selectedRegion }
                    if !vignobles.isEmpty {
                        vignoblesByProvenance = vignobles
                    }
                }
            }
        }
    
    // Propriété calculée servant à tester si le formulaire d'ajout de vin est valide
    var isFormComplete: Bool {
        return(!nomVin.isEmpty && selectedAppellation != nil && selectedDomaine != nil)
    }
    
    // Méthode permettant à 'AddVinView' d'enregistrer un nouveau vin
    func enregistrerVin(dans context: ModelContext) -> Vin? {
        
        // Vérifie que les données sont bien récupérées de la vue
        guard let sucrosite = selectedSucrosite,
              let couleur = selectedCouleur,
              let caracteristique = selectedCaracteristique,
              let appellation = selectedAppellation,
              let domaine = selectedDomaine else {
            return nil
        }
        
        let classification = selectedClassification
        let vignoble = selectedVignoble
        
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
