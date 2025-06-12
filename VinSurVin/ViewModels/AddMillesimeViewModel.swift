import SwiftUI
import SwiftData

@MainActor
class AddMillesimeViewModel: ObservableObject {
    
    // Déclare les propriétés qui seront exposées à la vue 'AddMillesimeView'
    @Published var selectedVin: Vin?
    @Published var selectedTaille: Taille?
    @Published var selectedQuantite: Int = 1
    @Published var selectedConservationMin: Int = 0
    @Published var selectedConservationMax: Int = 1
    @Published var selectedYear: Int = Int(Calendar.current.component(.year, from: Date()))
    @Published var selectedPhoto: UIImage?
    
    // Déclare une propriété calculée exposée à la vue 'AddMillesimeView' servant à tester si le formulaire d'ajout de millésime est valide
    var isFormComplete: Bool {
        selectedVin != nil && selectedTaille != nil && selectedQuantite > 0 && selectedConservationMin <= selectedConservationMax
    }
    
    func enregistrerMillesime(dans context: ModelContext) -> Bool {
        guard let vin = selectedVin,
              let taille = selectedTaille,
              let dateMin = Date.from(day: 1, month: 1, year: selectedYear + selectedConservationMin),
              let dateMax = Date.from(day: 1, month: 1, year: selectedYear + selectedConservationMax)
        else {
            return false
        }

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
    
}
