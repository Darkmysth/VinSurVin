import Foundation
import SwiftData

class Domaine {
    // Déclaration des attributs de l'entité
    var nomDomaine: String
    
    // Déclaration du lien n -> 1 avec l'entité 'Provenance'
    var provenance: Provenance?
    // Déclaration de la relation 1 -> n avec l'entité 'Vin'
    @Relationship(deleteRule: .cascade) var vins: [Vin]
    
    // Initialisation de l'entité
    init(nomDomaine: String, provenance: Provenance? = nil) {
        self.nomDomaine = nomDomaine
        self.provenance = provenance
        self.vins = []
    }
}
