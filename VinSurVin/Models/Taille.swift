import Foundation
import SwiftData

// Déclaration de l'entité 'Taille' dans laquelle seront stockées les données
@Model
class Taille {
    // Déclaration des attributs de l'entité
    var nomTaille: String
    var uniteVolume: String
    var volume: Double
    
    // Déclaration des relations 1 -> n de l'entité
    @Relationship(deleteRule: .cascade) var bouteilles: [Bouteille]

    // Initialisation d'une instance de l'entité
    init(nomTaille: String, uniteVolume: String, volume: Double) {
        self.nomTaille = nomTaille
        self.uniteVolume = uniteVolume
        self.volume = volume
        self.bouteilles = []
    }
}

// Déclaration de la structure 'TailleCodable' qui va servir de réceptacle intermédiaire aux données contenues dans le fichier JSON
struct TailleCodable: Codable {
    var nomTaille: String
    var uniteVolume: String
    var volume: Double
}
