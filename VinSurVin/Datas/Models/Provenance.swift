import Foundation
import SwiftData

// Déclaration de l'entité 'Provenance' dans laquelle seront stockées les données
@Model
class Provenance {
    // Déclaration des attributs de l'entité 'Provenance'
    var nomProvenance: String
    var typeProvenance: String
    
    // Déclaration des relations 1 -> n avec d'autres entités
    @Relationship(deleteRule: .cascade) var classifications: [Classification]
    @Relationship(deleteRule: .cascade) var domaines: [Domaine]
    @Relationship(deleteRule: .cascade) var vins: [Vin]
    @Relationship(deleteRule: .cascade) var vignobles: [Vignoble]
    
    // Relation vers le parent (facultatif)
    @Relationship(deleteRule: .nullify) var parent: Provenance?
    
    // Relation inverse persistante pour les enfants
    @Relationship(deleteRule: .nullify, inverse: \Provenance.parent)
    var enfants: [Provenance]
    
    
    // Initialisation d'une instance de l'entité
    init(nomProvenance: String, typeProvenance: String) {
        self.nomProvenance = nomProvenance
        self.typeProvenance = typeProvenance
        self.classifications = []
        self.domaines = []
        self.vins = []
        self.vignobles = []
        self.parent = nil
        self.enfants = []
    }
    var enfantArray: [Provenance] {
        // Filtre les Provenance ayant ce `self` comme parent
        let allProvenances = try? modelContext?.fetch(FetchDescriptor<Provenance>())
        return allProvenances?.filter { $0.parent == self } ?? []
    }
    
}

// Déclaration de la structure 'ProvenanceCodable' qui va servir de réceptacle intermédiaire aux données contenues dans le fichier JSON
struct ProvenanceCodable: Codable {
    var nomProvenance: String
    var typeProvenance: String
    var parent: String?
}
