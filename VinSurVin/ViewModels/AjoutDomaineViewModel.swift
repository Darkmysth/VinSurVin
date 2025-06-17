import SwiftData
import SwiftUI

@MainActor
class AjoutDomaineViewModel: ObservableObject {
    
    // Déclare les propriétés qui seront exposées à la vue 'AjoutDomaineView', toutes les instances de classe sont optionnelles pour ne pas avoir à gérer d'initialiseur
    @Published var nomDomaine: String = ""
    @Published var regionSelectionnee: Provenance?
    
    // Propriété calculée servant à tester si le formulaire d'ajout de domaine est valide
    var isFormComplete: Bool {
        !nomDomaine.isEmpty
    }
    
    // Méthode permettant à 'AjoutDomaineView' d'enregistrer un nouveau domaine
    func enregistrerDomaine(dans context: ModelContext) -> Domaine? {
        
        // Vérifie que les données sont bien récupérées de la vue
        guard let region = regionSelectionnee else {
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
