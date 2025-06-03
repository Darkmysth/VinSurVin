import SwiftData
import SwiftUI

@MainActor
class AddDomaineViewModel: ObservableObject {
    
    // Déclare les propriétés qui seront exposées à la vue 'AddDomaineView', toutes les instances de classe sont optionnelles pour ne pas avoir à gérer d'initialiseur
    @Published var nomDomaine: String = ""
    @Published var selectedRegion: Provenance?
    
    // Propriété calculée servant à tester si le formulaire d'ajout de domaine est valide
    var isFormComplete: Bool {
        !nomDomaine.isEmpty
    }
    
    // Méthode permettant à 'AddDomaineView' d'enregistrer un nouveau domaine
    func enregistrerDomaine(selectedRegion: Provenance?, dans context: ModelContext) -> Domaine? {
        
        // Vérifie que les données sont bien récupérées de la vue
        guard let region = selectedRegion else {
            return nil
        }
        
        // Crée le nouveau domaine
        let nouveauDomaine = Domaine(
            nomDomaine: nomDomaine,
            provenance: region
        )
        // Ajoute le nouveau domaine au contexte
        context.insert(nouveauDomaine)
        
        // Sauvegarde le contexte si nécessaire
        do {
            try context.save()
            return nouveauDomaine
        } catch {
            return nil
        }
    }
    
}
