import Foundation
import SwiftData

@Model
class Classification {
    // Déclaration des attributs de l'entité
    var nomClassification: String
    
    // Déclaration du lien n -> 1 avec l'entité 'Provenance'
    var provenance: Provenance?
    
    // Déclaration de la relation 1 -> n avec l'entité 'Vin'
    @Relationship(deleteRule: .cascade) var vins: [Vin]
    
    // Initialisation de l'entité
    init (nomClassification: String, provenance: Provenance? = nil) {
        self.nomClassification = nomClassification
        self.provenance = provenance
        self.vins = []
    }
}
