import Foundation
import SwiftData

@Model
class Taille {
    // Déclaration des attributs de l'entité 'Taille'
    var nomTaille: String
    var volume: Double
    var uniteVolume: String
    
    // Déclaration de la relation 1->n avec l'entité 'Bouteille' <=> plusieurs bouteilles peuvent avoir la même taille
    @Relationship(deleteRule: .cascade) var bouteilles: [Bouteille]

    // Initialisation d'une instance de l'entité
    init(nomTaille: String, volume: Double, uniteVolume: String) {
        self.nomTaille = nomTaille
        self.volume = volume
        self.uniteVolume = uniteVolume
        self.bouteilles = []
    }
}
