import Foundation
import SwiftData

@Model
class Vignoble {
    // Déclaration des attributs de l'entité
    var nomVignoble: String
    var typeVignoble: String
    
    // Déclaration des relations n -> 1 de l'entité
    var provenance: Provenance?

    // Initialisation d'une instance de l'entité
    init(nomVignoble: String, typeVignoble: String, provenance: Provenance? = nil) {
        self.nomVignoble = nomVignoble
        self.typeVignoble = typeVignoble
        self.provenance = provenance
    }
}

// Déclaration de la structure 'VignobleCodable' qui va servir de réceptacle intermédiaire aux données contenues dans le fichier JSON
struct VignobleCodable: Codable {
    var nomVignoble: String
    var typeVignoble: String
}
