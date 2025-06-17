import Foundation
import SwiftData

// Déclaration de l'entité 'Millesime' dans laquelle seront stockées les données
@Model
class Millesime {
    // Déclaration des attributs de l'entité
    var anneeMillesime: Int
    
    // Déclaration des relations n -> 1 de l'entité
    @Relationship(deleteRule: .nullify, inverse: \Vin.millesimes) var vin: Vin?
    
    // Déclaration des relations 1 -> n de l'entité
    @Relationship(deleteRule: .cascade) var bouteilles: [Bouteille]
    
    // Initialisation d'une instance de l'entité
    init(anneeMillesime: Int, vin: Vin) {
        self.anneeMillesime = anneeMillesime
        self.vin = vin
        self.bouteilles = []
    }
    
    // Création d'un sample data de millésimes utilisé pour les previews
    static func sampleTroisToitsMillesime2024(vin: Vin) -> Millesime {
        Millesime(
            anneeMillesime: 2024,
            vin: vin
        )
    }
    static func sampleLafiteRothschildMillesime1999(vin: Vin) -> Millesime {
        Millesime(
            anneeMillesime: 1999,
            vin: vin
        )
    }
}
