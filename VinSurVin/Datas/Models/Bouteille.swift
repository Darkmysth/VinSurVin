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
    
    // Déclaration de la propriété dédiée à la photo de la bouteille
    @Attribute(.externalStorage) // Permet de stocker les données volumineuses dans un fichier séparé de la base de données principale pour optimiser les performances
    var photo: Data?
    
    // Déclaration des relations n -> 1 de l'entité
    @Relationship(deleteRule: .nullify, inverse: \Taille.bouteilles) var taille: Taille
    @Relationship(deleteRule: .nullify, inverse: \Vin.bouteilles) var vin: Vin
    
    // Initialisation d'une instance de l'entité
    init(quantiteBouteilles: Int, millesime: Int, dateConsommationMin: Date, dateConsommationMax: Date, taille: Taille, vin: Vin, photo: Data? = nil) {
        self.quantiteBouteilles = quantiteBouteilles
        self.millesime = millesime
        self.dateConsommationMin = dateConsommationMin
        self.dateConsommationMax = dateConsommationMax
        self.taille = taille
        self.vin = vin
        self.photo = photo
    }
    
    // Création d'un sample data de bouteilles utilisé pour les previews
    static func sampleBouteilleTroisToits(vin: Vin, taille: Taille) -> Bouteille {
        Bouteille(
            quantiteBouteilles: 12,
            millesime: 2024,
            dateConsommationMin: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
            dateConsommationMax: Calendar.current.date(from: DateComponents(year: 2026, month: 12, day: 31))!,
            taille: taille,
            vin: vin
        )
    }
    static func sampleBouteilleLafiteRothschild(vin: Vin, taille: Taille) -> Bouteille {
        Bouteille(
            quantiteBouteilles: 6,
            millesime: 1999,
            dateConsommationMin: Calendar.current.date(from: DateComponents(year: 2010, month: 1, day: 1))!,
            dateConsommationMax: Calendar.current.date(from: DateComponents(year: 2040, month: 12, day: 31))!,
            taille: taille,
            vin: vin
        )
    }
}
