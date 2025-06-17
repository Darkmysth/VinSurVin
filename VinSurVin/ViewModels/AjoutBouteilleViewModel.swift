import SwiftUI
import SwiftData

@MainActor
class AjoutBouteilleViewModel: ObservableObject {
    
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
        vinSelectionne != nil &&
        tailleSelectionnee != nil &&
        quantiteSelectionnee > 0 &&
        conservationMinSelectionnee <= conservationMaxSelectionnee
    }
    

    func enregistrerBouteille(dans context: ModelContext) -> Bool {
        
        // Vérifie la validité des données
        guard let dateMin = Date.from(jour: 1, mois: 1, annee: anneeSelectionnee + conservationMinSelectionnee),
              let dateMax = Date.from(jour: 1, mois: 1, annee: anneeSelectionnee + conservationMaxSelectionnee)
        else {
            return false
        }
        
        // Recherche un millésime existant pour ce vin
        guard let vin = vinSelectionne else { return false }
        let annee = anneeSelectionnee
        let vinID = vin.persistentModelID

        let fetch = FetchDescriptor<Millesime>(
            predicate: #Predicate<Millesime> { millesime in
                millesime.vin?.persistentModelID == vinID && millesime.anneeMillesime == annee
            }
        )
        let millesimeTrouve: Millesime?
        do {
            millesimeTrouve = try context.fetch(fetch).first
        } catch {
            print("Erreur lors de la recherche du millésime : \(error)")
            return false
        }
        
        // Crée un nouveau millésime s’il n’existe pas encore
        let nouveauMillesime = millesimeTrouve ?? {
            let nouveau = Millesime(anneeMillesime: anneeSelectionnee, vin: vin)
            context.insert(nouveau)
            return nouveau
        }()

        // Crée la nouvelle bouteille
        let nouvelleBouteille = Bouteille(
            quantite: quantiteSelectionnee,
            dateConsommationMin: dateMin,
            dateConsommationMax: dateMax,
            millesime: nouveauMillesime,
            taille: tailleSelectionnee!
        )
        if let image = photoSelectionnee {
            nouvelleBouteille.photo = image.jpegData(compressionQuality: 0.8)
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
