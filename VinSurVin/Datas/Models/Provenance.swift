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
    @Relationship(deleteRule: .cascade, inverse: \Provenance.parent) var enfants: [Provenance]
    
    // Propriété calculée permettant de récupérer les parents
        // Pays
        var paysParent: Provenance? {
            var current = self
            while let parent = current.parent {
                if parent.typeProvenance == "pays" {
                    return parent
                }
                current = parent
            }
            return nil
        }
        // Région
        var regionParente: Provenance? {
            var current = self
            while let parent = current.parent {
                if parent.typeProvenance == "region" {
                    return parent
                }
                current = parent
            }
            return nil
        }
        // Sous-région
        var sousRegionParente: Provenance? {
            var current = self
            while let parent = current.parent {
                if parent.typeProvenance == "sousRegion" {
                    return parent
                }
                current = parent
            }
            return nil
        }
    
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
    
    // Initialisation du sample de datas
    static func sampleData() -> Provenance {
        
        //Déclaration des différentes instances du sample data
        let france = Provenance(nomProvenance: "France", typeProvenance: "pays")
        let loire = Provenance(nomProvenance: "Vallée de la Loire", typeProvenance: "region")
        let bordeaux = Provenance(nomProvenance: "Bordeaux", typeProvenance: "region")
        let paysNantais = Provenance(nomProvenance: "Pays Nantais", typeProvenance: "sousRegion")
        let medoc = Provenance(nomProvenance: "Médoc", typeProvenance: "sousRegion")
        let muscadet = Provenance(nomProvenance: "Muscadet Sèvre-et-Maine", typeProvenance: "appellation")
        let pauillac = Provenance(nomProvenance: "Pauillac", typeProvenance: "appellation")
        
        // Liens hiérarchiques
        // Pays <-> Région
        france.enfants.append(loire)
        loire.parent = france
        france.enfants.append(bordeaux)
        bordeaux.parent = france
        // Région <-> Sous-région
        loire.enfants.append(paysNantais)
        paysNantais.parent = loire
        bordeaux.enfants.append(medoc)
        medoc.parent = bordeaux
        // Sous-région <-> Appellation
        paysNantais.enfants.append(muscadet)
        muscadet.parent = paysNantais
        medoc.enfants.append(pauillac)
        pauillac.parent = medoc
        
        return france
        
    }
    
}

// Déclaration de la structure 'ProvenanceCodable' qui va servir de réceptacle intermédiaire aux données contenues dans le fichier JSON
struct ProvenanceCodable: Codable {
    var nomProvenance: String
    var typeProvenance: String
    var parent: String
    var typeParent: String
}
