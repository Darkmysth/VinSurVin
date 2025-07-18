import Foundation
import SwiftData

// Déclaration de l'entité 'Domaine' dans laquelle seront stockées les données
@Model
class Domaine {
    // Déclaration des attributs de l'entité
    var nomDomaine: String
    
    // Déclaration des relations n -> 1 de l'entité
    @Relationship(deleteRule: .nullify, inverse: \Provenance.domaines) var provenance: Provenance
    
    // Déclaration des relations 1 -> n de l'entité
    @Relationship(deleteRule: .cascade) var vins: [Vin]
    
    // Initialisation de l'entité
    init(nomDomaine: String, provenance: Provenance) {
        self.nomDomaine = nomDomaine
        self.provenance = provenance
        self.vins = []
    }
    
    // Création d'un sample data de domaines utilisé pour les previews
    static func sampleTroisToits(provenance: Provenance) -> Domaine {
        Domaine(nomDomaine: "Domaine des Trois Toits", provenance: provenance)
    }
    static func sampleRothschild(provenance: Provenance) -> Domaine {
        Domaine(nomDomaine: "Domaine Barons de Rothschild", provenance: provenance)
    }
    
}
