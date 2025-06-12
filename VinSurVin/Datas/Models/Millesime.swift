import Foundation
import SwiftData

// Déclaration de l'entité 'Millesime' dans laquelle seront stockées les données
@Model
class Millesime {
    // Déclaration des attributs de l'entité
    var anneeMillesime: Int
    var quantiteBouteilles: Int
    var dateConsommationMin: Date
    var dateConsommationMax: Date
    
    // Déclaration de la propriété dédiée à la photo de la bouteille du millésime
    @Attribute(.externalStorage) // Permet de stocker les données volumineuses dans un fichier séparé de la base de données principale pour optimiser les performances
    var photo: Data?
    
    // Déclaration des relations n -> 1 de l'entité
    @Relationship(deleteRule: .nullify, inverse: \Taille.millesimes) var taille: Taille
    @Relationship(deleteRule: .nullify, inverse: \Vin.millesimes) var vin: Vin
    
    // Initialisation d'une instance de l'entité
    init(anneeMillesime: Int, quantiteBouteilles: Int, dateConsommationMin: Date, dateConsommationMax: Date, taille: Taille, vin: Vin, photo: Data? = nil) {
        self.anneeMillesime = anneeMillesime
        self.quantiteBouteilles = quantiteBouteilles
        self.dateConsommationMin = dateConsommationMin
        self.dateConsommationMax = dateConsommationMax
        self.taille = taille
        self.vin = vin
        self.photo = photo
    }
    
    // Création d'un sample data de millesimes utilisé pour les previews
    static func sampleMillesimeTroisToits(vin: Vin, taille: Taille) -> Millesime {
        Millesime(
            anneeMillesime: 2024,
            quantiteBouteilles: 12,
            dateConsommationMin: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
            dateConsommationMax: Calendar.current.date(from: DateComponents(year: 2026, month: 12, day: 31))!,
            taille: taille,
            vin: vin
        )
    }
    static func sampleMillesimeLafiteRothschild(vin: Vin, taille: Taille) -> Millesime {
        Millesime(
            anneeMillesime: 1999,
            quantiteBouteilles: 6,
            dateConsommationMin: Calendar.current.date(from: DateComponents(year: 2010, month: 1, day: 1))!,
            dateConsommationMax: Calendar.current.date(from: DateComponents(year: 2040, month: 12, day: 31))!,
            taille: taille,
            vin: vin
        )
    }
}
