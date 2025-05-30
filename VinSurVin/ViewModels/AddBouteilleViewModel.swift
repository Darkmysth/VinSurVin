import SwiftUI
import SwiftData

@MainActor
class AddBouteilleViewModel: ObservableObject {
    
    // Déclare les propriétés qui seront exposées à la vue 'AddBouteilleView'
    @Published var selectedVin: Vin?
    @Published var selectedTaille: Taille?
    @Published var selectedQuantite: Int = 1
    @Published var selectedConservationMin: Int = 0
    @Published var selectedConservationMax: Int = 1
    @Published var selectedYear: Int = Int(Calendar.current.component(.year, from: Date()))
    
    // Déclare une propriété calculée exposée à la vue 'AddBouteilleView' servant à tester si le formulaire d'ajout de bouteille est valide
    var isFormComplete: Bool {
        selectedVin != nil && selectedTaille != nil && selectedQuantite > 0 && selectedConservationMin <= selectedConservationMax
    }
    
    func enregistrerBouteille(dans context: ModelContext) -> Bool {
        guard let vin = selectedVin,
              let taille = selectedTaille,
              let dateMin = Date.from(day: 1, month: 1, year: selectedYear + selectedConservationMin),
              let dateMax = Date.from(day: 1, month: 1, year: selectedYear + selectedConservationMax)
        else {
            return false
        }

        // Crée la nouvelle bouteille
        let nouvelleBouteille = Bouteille(
            quantiteBouteilles: selectedQuantite,
            millesime: selectedYear,
            dateConsommationMin: dateMin,
            dateConsommationMax: dateMax,
            taille: taille,
            vin: vin
        )
        
        // Ajoute la nouvelle bouteille au contexte
        context.insert(nouvelleBouteille)
        
        // Sauvegarde le contexte si nécessaire
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
}
