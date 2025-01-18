import Foundation
import SwiftData

// Déclaration de l'entité 'Classification' dans laquelle seront stockées les données
@Model
class Classification {
    // Déclaration des attributs de l'entité
    var nomClassification: String
    
    // Déclaration du lien n -> 1 avec l'entité 'Provenance'
    var provenance: Provenance
    
    // Déclaration de la relation 1 -> n avec l'entité 'Vin'
    @Relationship(deleteRule: .cascade) var vins: [Vin]
    
    // Initialisation de l'entité
    init (nomClassification: String, provenance: Provenance) {
        self.nomClassification = nomClassification
        self.provenance = provenance
        self.vins = []
    }
}

// Déclaration de la structure 'ClassificationCodable' qui va servir de réceptacle intermédiaire aux données contenues dans le fichier JSON
struct ClassificationCodable: Codable {
    var nomClassification: String
    var typeParent: String
    var parent: String
}
