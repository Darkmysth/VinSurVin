import Foundation
import SwiftData

@Model
class Bouteille {
    // Déclaration des attributs de l'entité
    var quantiteBouteilles: Int
    var millesime: Int
    var dateConsommationMin: Date
    var dateConsommationMax: Date
    
    // Déclaration des relations n -> 1 de l'entité
    var taille: Taille?
    var vin: Vin?

    // Initialisation d'une instance de l'entité
    init(quantiteBouteilles: Int, millesime: Int, dateConsommationMin: Date, dateConsommationMax: Date, taille: Taille? = nil, vin: Vin? = nil) {
        self.quantiteBouteilles = quantiteBouteilles
        self.millesime = millesime
        self.dateConsommationMin = dateConsommationMin
        self.dateConsommationMax = dateConsommationMax
        self.taille = taille
        self.vin = vin
    }
}
