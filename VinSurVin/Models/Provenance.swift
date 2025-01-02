import Foundation
import SwiftData

@Model
class Provenance {
    // Déclaration des attributs de l'entité 'Provenance'
    var nomProvenance: String
    var typeProvenance: String
    
    // Déclaration des relations 1 -> n avec d'autres entités
    @Relationship(deleteRule: .cascade) var classifications: [Classification]
    @Relationship(deleteRule: .cascade) var domaines: [Domaine]
    @Relationship(deleteRule: .cascade) var vins: [Vin]
    
    // Initialisation d'une instance de l'entité
    init(nomProvenance: String, provenance: String) {
        self.nomProvenance = nomProvenance
        self.typeProvenance = typeProvenance
        self.classifications = []
        self.domaines = []
        self.vins = []
    }
}
