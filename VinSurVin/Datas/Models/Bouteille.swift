import Foundation
import SwiftData

// Déclaration de l'entité 'Bouteille' dans laquelle seront stockées les données
@Model
class Bouteille {
    // Déclaration des attributs de l'entité
    var quantiteBouteilles: Int
    var millesime: Int
    var dateConsommationMin: Date
    var dateConsommationMax: Date
    
    // Déclaration des relations n -> 1 de l'entité
    @Relationship(deleteRule: .nullify, inverse: \Taille.bouteilles) var taille: Taille
    @Relationship(deleteRule: .nullify, inverse: \Vin.bouteilles) var vin: Vin

    // Initialisation d'une instance de l'entité
    init(quantiteBouteilles: Int, millesime: Int, dateConsommationMin: Date, dateConsommationMax: Date, taille: Taille, vin: Vin, context: ModelContext) {
        self.quantiteBouteilles = quantiteBouteilles
        self.millesime = millesime
        self.dateConsommationMin = dateConsommationMin
        self.dateConsommationMax = dateConsommationMax
        self.taille = taille
        self.vin = vin
    }
}
