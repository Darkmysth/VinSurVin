import Foundation
import SwiftData

// Déclaration de l'entité 'Vignoble' dans laquelle seront stockées les données
@Model
class Vignoble {
    // Déclaration des attributs de l'entité
    var nomVignoble: String
    var typeVignoble: String
    
    // Déclaration des relations n -> 1 de l'entité
    @Relationship(deleteRule: .nullify, inverse: \Provenance.vignobles) var provenance: Provenance
    
    // Déclaration des relations 1 -> n de l'entité
    @Relationship(deleteRule: .cascade) var vins: [Vin]

    // Initialisation d'une instance de l'entité
    init(nomVignoble: String, typeVignoble: String, provenance: Provenance) {
        self.nomVignoble = nomVignoble
        self.typeVignoble = typeVignoble
        self.provenance = provenance
        self.vins = []
    }
    
    // Création d'un sample data de vignobles utilisé pour les previews
    static func sampleData(provenance: Provenance) -> Vignoble {
        Vignoble(nomVignoble: "Cru La Haye Fouassière", typeVignoble: "Cru Communal", provenance: provenance)
    }
}

// Déclaration de la structure 'VignobleCodable' qui va servir de réceptacle intermédiaire aux données contenues dans le fichier JSON
struct VignobleCodable: Codable {
    var nomVignoble: String
    var typeVignoble: String
    var typeParent: String
    var nomParent: String
}
