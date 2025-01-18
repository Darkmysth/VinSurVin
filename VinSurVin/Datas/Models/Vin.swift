import Foundation
import SwiftData

// Déclaration des enums des attributs de l'entité 'Vin'
// 'Couleur'
enum Couleur: Int, Codable, CaseIterable, Identifiable {
    case blanc = 1
    case rouge = 2
    case rose = 3
    var id: Int {
        rawValue
    }
}
extension Couleur {
    var nomCouleur: String {
        switch self {
        case .blanc:
            return "Blanc"
        case .rouge:
            return "Rouge"
        case .rose:
            return "Rosé"
        }
    }
}

// 'Caracteristique'
enum Caracteristique: Int, Codable, CaseIterable, Identifiable {
    case paille = 1
    case raisinsSurmuris = 2
    case grainsNobles = 3
    case trieesSuccessives = 4
    case vendangesTardives = 5
    case doux = 6
    case vinJaune = 7
    case mousseux = 8
    case petillant = 9
    case primeur = 10
    case surLie = 11
    case tranquille = 12
    var id: Int {
        rawValue
    }
}
extension Caracteristique {
    var nomCaracteristique: String {
        switch self {
        case .paille:
            return "Vin de paille"
        case .raisinsSurmuris:
            return "Vin de raisins surmuris"
        case .grainsNobles:
            return "Vin de sélection de grains nobles"
        case .trieesSuccessives:
            return "Vin de triées successives"
        case .vendangesTardives:
            return "Vin de vendanges tardives"
        case .doux:
            return "Vin doux naturel"
        case .vinJaune:
            return "Vin jaune"
        case .mousseux:
            return "Vin mousseux"
        case .petillant:
            return "Vin pétillant"
        case .primeur:
            return "Vin primeur"
        case .surLie:
            return "Vin sur lie"
        case .tranquille:
            return "Vin tranquille"
        }
    }
}

// 'Sucrosite'
enum Sucrosite: Int, Codable, CaseIterable, Identifiable  {
    case sec = 1
    case demiSec = 2
    case doux = 3
    case moelleux = 4
    var id: Int {
        self.rawValue
    }
}
extension Sucrosite {
    var nomSucrosite: String {
        switch self {
        case .sec:
            return "Sec"
        case .demiSec:
            return "Demi-sec"
        case .doux:
            return "Doux"
        case .moelleux:
            return "Moelleux"
        }
    }
}


// Déclaration de l'entité 'Vin' dans laquelle seront stockées les données
@Model
class Vin {
    // Déclaration des attributs de l'entité
    var nomVin: String
    var sucrosite: Sucrosite
    var couleur: Couleur
    var caracteristique: Caracteristique
    
    // Déclaration des relations n -> 1 de l'entité
    var provenance: Provenance
    var classification: Classification
    var domaine: Domaine
    
    // Déclaration des relations 1 -> de l'entité
    @Relationship(deleteRule: .cascade) var bouteilles: [Bouteille]
    
    // Initialisation de l'entité
    init(nomVin: String, sucrosite: Sucrosite, couleur: Couleur, caracteristique: Caracteristique, provenance: Provenance, classification: Classification, domaine: Domaine) {
        self.nomVin = nomVin
        self.sucrosite = sucrosite
        self.couleur = couleur
        self.caracteristique = caracteristique
        self.provenance = provenance
        self.classification = classification
        self.domaine = domaine
        self.bouteilles = []
    }
}
