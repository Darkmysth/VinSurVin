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
        
            // Crée un dictionnaire pour accéder facilement à chaque provenance
            var provenances = [Provenance]() // Crée un tableau vide nommé 'provenances' dont les éléments seront de type 'Provenance'
            for provenanceData in provenancesData { // Parcourt toutes les instances de 'provenancesData' et pour chacune crée une nouvelle instance de 'Provenance' grâce aux données récupérées
                let provenance = Provenance(
                    nomProvenance: provenanceData.nomProvenance,
                    typeProvenance: provenanceData.typeProvenance
                )
                context.insert(provenance) // Insère l'entité dans le contexte
                provenances.append(provenance) // Ajoute à la liste locale
            }
            // Crée un dictionnaire 'provenancesDict' dont chaque clé sera un String et chaque valeur une instance de 'Provenance'
            let provenancesDict: [String: Provenance] = Dictionary(
                // Instancie le dictionnaire avec des paires clé-valeur grâce à la méthode 'map' qui va retourner une paire 'key' - 'provenance' (instance de 'Provenance')
                uniqueKeysWithValues: provenances.map { provenance in
                    let key = "\(provenance.nomProvenance.lowercased())|\(provenance.typeProvenance.lowercased())"
                    return (key, provenance)
                }
            )
            // Affecte les relations parent-enfant
            for provenanceData in provenancesData {
                if let parent = provenancesDict["\(provenanceData.parent.lowercased())|\(provenanceData.typeParent.lowercased())"] {
                    let provenanceKey = "\(provenanceData.nomProvenance.lowercased())|\(provenanceData.typeProvenance.lowercased())"
                    if let provenance = provenancesDict[provenanceKey] {
                        provenance.parent = parent // Affecte le parent
                    }
                }
            }
        
            // Classifications.json
            for classificationData in classificationsData {
                // Crée la clé pour trouver la provenance parent
                let parentKey = "\(classificationData.parent.lowercased())|\(classificationData.typeParent.lowercased())"
                
                // Vérifie si la provenance parent existe
                guard let parentProvenance = provenancesDict[parentKey] else {
                    print("Provenance \(classificationData.parent) introuvable pour la classification \(classificationData.nomClassification).")
                    continue
                }
                
                // Crée et lie la classification
                let classification = Classification(
                    nomClassification: classificationData.nomClassification,
                    provenance: parentProvenance // Lien avec le parent
                )
                
                // Ajoute la classification au parent
                parentProvenance.classifications.append(classification)
                
                // Insère dans le contexte
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
                // Crée la clé pour trouver la provenance parent
                let parentKey = "\(vignobleData.nomParent.lowercased())|\(vignobleData.typeParent.lowercased())"
                
                // Vérifie si la provenance parent existe
                guard let parentProvenance = provenancesDict[parentKey] else {
                    print("Provenance \(vignobleData.nomParent) introuvable pour le vignoble \(vignobleData.nomVignoble).")
                    continue
                }
                
                // Crée et lie le vignoble
                let vignoble = Vignoble(
                    nomVignoble: vignobleData.nomVignoble,
                    typeVignoble: vignobleData.typeVignoble,
                    provenance: parentProvenance // Lien avec le parent
                )
                
                // Ajoute le vignoble au parent
                parentProvenance.vignobles.append(vignoble)
                
                // Insère dans le contexte
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
