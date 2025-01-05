import Foundation
import SwiftData

// Déclaration de l'entité 'Vin' dans laquelle seront stockées les données
@Model
class Vin {
    // Déclaration des attributs de l'entité
    var nomVin: String
    var sucrosite: String
    var couleur: String
    var caracteristique: String
    
    // Déclaration des relations n -> 1 de l'entité
    var provenance: Provenance
    var classification: Classification
    var domaine: Domaine
    
    // Déclaration des relations 1 -> de l'entité
    @Relationship(deleteRule: .cascade) var bouteilles: [Bouteille]
    
    // Initialisation de l'entité
    init(nomVin: String, sucrosite: String, couleur: String, caracteristique: String, provenance: Provenance, classification: Classification, domaine: Domaine) {
        self.nomVin = nomVin
        self.sucrosite = sucrosite
        self.couleur = couleur
        self.caracteristique = caracteristique
        self.provenance = provenance
        self.classification = classification
        self.domaine = domaine
        self.bouteilles = []
    }
}
