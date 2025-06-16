import Foundation
import SwiftData

// Déclaration de l'entité 'Bouteille' dans laquelle seront stockées les données
@Model
class Bouteille {
    // Déclaration des attributs de l'entité
    var quantite: Int
    var dateConsommationMin: Date
    var dateConsommationMax: Date
    
    // Déclaration de la propriété dédiée à la photo de la bouteille du millésime
    @Attribute(.externalStorage) // Permet de stocker les données volumineuses dans un fichier séparé de la base de données principale pour optimiser les performances
    var photo: Data?
    
    // Déclaration des relations n -> 1 de l'entité
    @Relationship(deleteRule: .nullify, inverse: \Millesime.bouteilles) var millesime: Millesime
    @Relationship(deleteRule: .nullify, inverse: \Taille.bouteilles) var taille: Taille
    
    // Initialisation d'une instance de l'entité
    init(quantite: Int, dateConsommationMin: Date, dateConsommationMax: Date, photo: Data? = nil, millesime: Millesime, taille: Taille) {
        self.quantite = quantite
        self.dateConsommationMin = dateConsommationMin
        self.dateConsommationMax = dateConsommationMax
        self.millesime = millesime
        self.taille = taille
        self.photo = photo
    }
    
    // Création d'un sample data de bouteilles utilisé pour les previews
    static func sampleBouteillesTroisToitsMillesime2024(millesime: Millesime, taille: Taille) -> Bouteille {
        Bouteille(
            quantite: 12,
            dateConsommationMin: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
            dateConsommationMax: Calendar.current.date(from: DateComponents(year: 2026, month: 12, day: 31))!,
            millesime: millesime,
            taille: taille
        )
    }
    static func sampleBouteillesLafiteRothschildMillesime1999(millesime: Millesime, taille: Taille) -> Bouteille {
        Bouteille(
            quantite: 6,
            dateConsommationMin: Calendar.current.date(from: DateComponents(year: 2010, month: 1, day: 1))!,
            dateConsommationMax: Calendar.current.date(from: DateComponents(year: 2040, month: 12, day: 31))!,
            millesime: millesime,
            taille: taille
        )
    }
}
