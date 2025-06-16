import SwiftUI
import SwiftData

@MainActor
<<<<<<< Updated upstream:VinSurVin/ViewModels/AddMillesimeViewModel.swift
class AddMillesimeViewModel: ObservableObject {
=======
class AjoutBouteilleViewModel: ObservableObject {
>>>>>>> Stashed changes:VinSurVin/ViewModels/AjoutBouteilleViewModel.swift
    
    // Déclare les propriétés qui seront exposées à la vue 'AjoutBouteilleView'
    @Published var vinSelectionne: Vin?
    @Published var tailleSelectionnee: Taille?
    @Published var quantiteSelectionnee: Int = 1
    @Published var conservationMinSelectionnee: Int = 0
    @Published var conservationMaxSelectionnee: Int = 1
    @Published var anneeSelectionnee: Int = Int(Calendar.current.component(.year, from: Date()))
    @Published var photoSelectionnee: UIImage?
    
    // Déclare une propriété calculée exposée à la vue 'AddMillesimeView' servant à tester si le formulaire d'ajout de millésime est valide
    var isFormComplete: Bool {
        vinSelectionne != nil && tailleSelectionnee != nil && quantiteSelectionnee > 0 && conservationMinSelectionnee <= conservationMaxSelectionnee
    }
    
<<<<<<< Updated upstream:VinSurVin/ViewModels/AddMillesimeViewModel.swift
    func enregistrerMillesime(dans context: ModelContext) -> Bool {
        guard let vin = selectedVin,
              let taille = selectedTaille,
              let dateMin = Date.from(day: 1, month: 1, year: selectedYear + selectedConservationMin),
              let dateMax = Date.from(day: 1, month: 1, year: selectedYear + selectedConservationMax)
=======
    func enregistrerBouteille(dans context: ModelContext) -> Bool {
        guard let dateMin = Date.from(jour: 1, mois: 1, annee: anneeSelectionnee + conservationMinSelectionnee),
              let dateMax = Date.from(jour: 1, mois: 1, annee: anneeSelectionnee + conservationMaxSelectionnee)
>>>>>>> Stashed changes:VinSurVin/ViewModels/AjoutBouteilleViewModel.swift
        else {
            return false
        }

<<<<<<< Updated upstream:VinSurVin/ViewModels/AddMillesimeViewModel.swift
        // Crée le nouveau millésime
        let nouveauMillesime = Millesime(
            anneeMillesime: selectedYear,
            quantiteBouteilles: selectedQuantite,
            dateConsommationMin: dateMin,
            dateConsommationMax: dateMax,
            taille: taille,
            vin: vin
        )
        
        // S'il y a une photo détourée, on l'enregistre
        if let image = selectedPhoto {
            nouveauMillesime.photo = image.jpegData(compressionQuality: 0.8)
=======
        // Crée la nouvelle bouteille
        let nouvelleBouteille = Bouteille(
            quantite: quantiteSelectionnee,
            dateConsommationMin: dateMin,
            dateConsommationMax: dateMax,
            millesime: nouveauMillesime!,
            taille: tailleSelectionnee!
        )
        
        // S'il y a une photo détourée, on l'enregistre
        if let image = photoSelectionnee {
            nouvelleBouteille.photo = image.jpegData(compressionQuality: 0.8)
>>>>>>> Stashed changes:VinSurVin/ViewModels/AjoutBouteilleViewModel.swift
        }
        
        // Ajoute le nouveau millésime au contexte
        context.insert(nouveauMillesime)
        
        // Sauvegarde le contexte si nécessaire
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
<<<<<<< Updated upstream:VinSurVin/ViewModels/AddMillesimeViewModel.swift
=======
    func enregistrerMillesime(dans context: ModelContext) -> Millesime? {
        guard let vin = vinSelectionne else {
            return nil
        }
        let nouveauMillesime = Millesime(
            anneeMillesime: anneeSelectionnee,
            vin: vin)
        context.insert(nouveauMillesime)
        return nouveauMillesime
    }
    
>>>>>>> Stashed changes:VinSurVin/ViewModels/AjoutBouteilleViewModel.swift
}
