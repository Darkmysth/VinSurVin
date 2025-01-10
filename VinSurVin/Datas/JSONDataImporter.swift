import Foundation
import SwiftData

// Déclaration de la structure qui va gérer l'import des données des fichiers JSON dans leur structure codable intermédiaire
struct JSONDataImporter {
    // Déclaration d'une méthode d'intégration des données des fichiers JSON qui ne se lance qu'à la 1ère compilation
    static func insertInitialDataIfNeeded(context: ModelContext) {
        
        let alreadyImported = UserDefaults.standard.bool(forKey: "InitialDataImported")
        guard !alreadyImported else {
            print("Les données initiales ont déjà été importées.")
            return
        }
        
        // 1 - Chargement des données à partir des fichiers JSON dans la structure codable intermédiaire (déclarée dans le fichier où est déclaré le modèle correspondant)
        let classificationsData: [ClassificationCodable] = loadJSON(filename: "Classifications")
        let provenancesData: [ProvenanceCodable] = loadJSON(filename: "Provenances")
        let taillesData: [TailleCodable] = loadJSON(filename: "Tailles")
        let vignoblesData: [VignobleCodable] = loadJSON(filename: "Vignobles")
        
        // 2 - Chargement des données dans l'entité finale à partir de la structure intermédiaire dans la classe stockant les données
            // Provenances.json
                // Définir la hiérarchie des types
                let hierarchy: [String: String] = [
                    "appellation": "sousRegion",
                    "sousRegion": "region",
                    "region": "pays"
                ]
        
                // Créer un dictionnaire pour accéder facilement à chaque provenance par son nom
                var provenancesDict: [String: Provenance] = [:]
        
                // Insérer les entités sans parent (les racines)
                for provenanceData in provenancesData where provenanceData.parent?.isEmpty ?? true {
                    let provenance = Provenance(
                        nomProvenance: provenanceData.nomProvenance,
                        typeProvenance: provenanceData.typeProvenance
                    )
                    context.insert(provenance)
                    provenancesDict[provenanceData.nomProvenance] = provenance
                }
        
                // Fonction pour remonter la hiérarchie si le parent direct n'est pas trouvé
                func findParent(for provenanceData: ProvenanceCodable, in provenancesDict: [String: Provenance], using hierarchy: [String: String]) -> Provenance? {
                    var currentType = provenanceData.typeProvenance
                    var parentNom = provenanceData.parent
                    
                    while let parentName = parentNom {
                        // Recherche un parent dans le dictionnaire
                        if let parentProvenance = provenancesDict.values.first(where: {
                            $0.nomProvenance == parentName && $0.typeProvenance == currentType
                        }) {
                            return parentProvenance
                        }
                        
                        // Si aucun parent trouvé, remonter dans la hiérarchie
                        if let nextType = hierarchy[currentType] {
                            currentType = nextType
                            parentNom = provenancesDict.values.first(where: {
                                $0.nomProvenance == parentName && $0.typeProvenance == currentType
                            })?.nomProvenance
                        } else {
                            // Aucun niveau supérieur dans la hiérarchie
                            break
                        }
                    }
                    
                    // Aucun parent trouvé
                    return nil
                }
        
                // Fonction générique pour traiter les relations avec la remontée hiérarchique
                func assignRelations(for type: String) {
                    for provenanceData in provenancesData where provenanceData.typeProvenance == type {
                        if let parentProvenance = findParent(for: provenanceData, in: provenancesDict, using: hierarchy) {
                            let provenance = Provenance(
                                nomProvenance: provenanceData.nomProvenance,
                                typeProvenance: provenanceData.typeProvenance
                            )
                            provenance.parent = parentProvenance
                            context.insert(provenance)
                            provenancesDict[provenanceData.nomProvenance] = provenance
                        } else if let parentNom = provenanceData.parent {
                            print("Aucun parent valide trouvé pour '\(provenanceData.nomProvenance)' avec parent attendu '\(parentNom)'")
                        }
                    }
                }

                // Assigner les relations hiérarchiques
                assignRelations(for: "pays")
                assignRelations(for: "region")
                assignRelations(for: "sousRegion")
                assignRelations(for: "appellation")
        
            // Classifications.json
            for classificationData in classificationsData {
                // Récupérer la provenance associée à partir du dictionnaire
                guard let parentProvenance = provenancesDict[classificationData.parent] else {
                    print("Provenance \(classificationData.parent) introuvable pour la classification \(classificationData.nomClassification).")
                    continue
                }
                
                // Créer une nouvelle instance de Classification
                let classification = Classification(
                    nomClassification: classificationData.nomClassification,
                    provenance: parentProvenance
                )
                
                // Ajouter la classification à la liste des classifications de la provenance
                parentProvenance.classifications.append(classification)
                
                // Insérer la classification dans le contexte
                context.insert(classification)
            }
            // Tailles.json
            for tailleData in taillesData {
                let taille = Taille(
                    nomTaille: tailleData.nomTaille,
                    uniteVolume: tailleData.uniteVolume,
                    volume: tailleData.volume
                )
                context.insert(taille)
            }
            // Vignobles.json
            for vignobleData in vignoblesData {
                // Filtrer les provenances correspondant au type et au nom du parent
                guard let parentProvenance = provenancesDict[vignobleData.nomParent] else {
                    print("Provenance \(vignobleData.nomParent) introuvable pour le vignoble \(vignobleData.nomVignoble).")
                    continue
                }
                
                // Créer une nouvelle instance de Vignoble
                let vignoble = Vignoble(
                    nomVignoble: vignobleData.nomVignoble,
                    typeVignoble: vignobleData.typeVignoble,
                    provenance: parentProvenance
                )
                
                // Ajouter le vignoble à la liste des vignobles de la provenance
                parentProvenance.vignobles.append(vignoble)
                
                // Insérer le vignoble dans le contexte
                context.insert(vignoble)
            }
        
        // 3 - Sauvegarde des données
        do {
            try context.save()
            print("Données initiales importées avec succès.")
            UserDefaults.standard.set(true, forKey: "InitialDataImported")
        } catch {
            print("Erreur lors de la sauvegarde : \(error)")
        }
    }
    
    // Méthode qui permet de charger des données à partir d'un fichier JSON du bundle de l'application
    // Paramètre d'entrée : 'filename' => le nom du fichier JSON dans le bundle
    // Eléments en sortie : un tableau d'objets décodés du type spécifié
    private static func loadJSON<T: Codable>(filename: String) -> [T] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("Fichier \(filename).json introuvable dans le bundle.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([T].self, from: data)
            return decodedData
        } catch {
            fatalError("Erreur lors du décodage de \(filename).json : \(error)")
        }
    }
    
    // Méthode pour vider une entité
    static func deleteAll<T: PersistentModel>(ofType type: T.Type, context: ModelContext) {
        let fetchRequest = FetchDescriptor<T>()
        if let results = try? context.fetch(fetchRequest) {
            for object in results {
                context.delete(object)
            }
            try? context.save()
        } else {
            print("Erreur lors de la récupération des instances de \(T.self).")
        }
    }
    
    // Méthode de suppression des données des entités de la base (pour certains cas où ça peut s'avérer nécessaire)
    static func deleteAllEntities(context: ModelContext) {
        let allEntities: [any PersistentModel.Type] = [
            Bouteille.self,
            Classification.self,
            Domaine.self,
            Provenance.self,
            Taille.self,
            Vignoble.self,
            Vin.self
        ]
        
        for entity in allEntities {
            deleteAll(ofType: entity, context: context)
        }
    }
}
