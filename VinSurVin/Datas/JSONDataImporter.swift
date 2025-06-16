import Foundation
import SwiftData

// Déclaration de la structure qui va gérer l'import des données des fichiers JSON dans leur structure codable intermédiaire
struct JSONDataImporter {
    // Déclaration d'une méthode d'intégration des données des fichiers JSON qui ne se lance qu'à la 1ère compilation
    static func insertInitialDataIfNeeded(context: ModelContext) {
        
        // 1 - Chargement des données à partir des fichiers JSON dans la structure codable intermédiaire (déclarée dans le fichier où est déclaré le modèle correspondant)
        let classificationsData: [ClassificationCodable] = loadJSON(filename: "Classifications")
        let provenancesData: [ProvenanceCodable] = loadJSON(filename: "Provenances")
        let taillesData: [TailleCodable] = loadJSON(filename: "Tailles")
        let vignoblesData: [VignobleCodable] = loadJSON(filename: "Vignobles")
        
        // 2 - Chargement des données dans l'entité finale à partir de la structure intermédiaire dans la classe stockant les données
        // Provenances.json
        // Charge toutes les provenances déjà en base dans un dictionnaire
        var provenancesEnBase: [Provenance] = chargerProvenancesEnBase(context: context)
        // Crée un dictionnaire pour accéder facilement à chaque provenance
        var provenancesEnBaseAvecCle = [String: Provenance]() // Crée un tableau vide nommé 'provenances' dont les éléments seront de type 'Provenance'
        for provenanceData in provenancesData { // Parcourt toutes les instances de 'provenancesData' et pour chacune crée une nouvelle instance de 'Provenance' grâce aux données récupérées
            let cle = "\(provenanceData.nomProvenance.lowercased())|\(provenanceData.typeProvenance.lowercased())|\(provenanceData.parent.lowercased())|\(provenanceData.typeParent.lowercased())"
            if provenancesEnBase.first(where: {
                $0.nomProvenance == provenanceData.nomProvenance &&
                $0.typeProvenance == provenanceData.typeProvenance &&
                (($0.sousRegionParente?.nomProvenance ?? "" == provenanceData.parent && provenanceData.typeParent == "sousRegion") ||
                 ($0.regionParente?.nomProvenance ?? "" == provenanceData.parent && provenanceData.typeParent == "region") ||
                 ($0.paysParent?.nomProvenance ?? "" == provenanceData.parent && provenanceData.typeParent == "pays") ||
                 (provenanceData.typeParent == ""))
            }) == nil {
                let provenance = Provenance(
                    nomProvenance: provenanceData.nomProvenance,
                    typeProvenance: provenanceData.typeProvenance
                )
                context.insert(provenance) // Insère l'entité dans le contexte
                provenancesEnBaseAvecCle[cle] = provenance
            }
        }
        // Recharge toutes les provenances en base dans un dictionnaire pour prendre en compte celles nouvellement intégrées
        provenancesEnBase = chargerProvenancesEnBase(context: context)
        // Affecte les relations parent-enfant
        for provenanceData in provenancesData {
            let cleEnfant = "\(provenanceData.nomProvenance.lowercased())|\(provenanceData.typeProvenance.lowercased())|\(provenanceData.parent.lowercased())|\(provenanceData.typeParent.lowercased())"
            let cleParent = "\(provenanceData.parent.lowercased())|\(provenanceData.typeParent.lowercased())|||"

            if let enfant = provenancesEnBaseAvecCle[cleEnfant],
               let parent = provenancesEnBaseAvecCle[cleParent] ?? provenancesEnBase.first(where: {
                   $0.nomProvenance.lowercased() == provenanceData.parent.lowercased() &&
                   $0.typeProvenance.lowercased() == provenanceData.typeParent.lowercased()
               }) {
                enfant.parent = parent
            }
        }
        
        // Classifications.json
        // Charge toutes les classifications déjà en base dans un dictionnaire
        let classificationsEnBase: [Classification] = chargerClassificationsEnBase(context: context)
        // Crée un dictionnaire pour accéder facilement à chaque classification
        for classificationData in classificationsData {
            if classificationsEnBase.first(where: {
                $0.nomClassification == classificationData.nomClassification &&
                $0.provenance?.nomProvenance == classificationData.parent
            }) == nil {
                // Vérifie si la provenance parent existe
                if let parentProvenance = provenancesEnBase.first(where: {
                    $0.nomProvenance == classificationData.parent &&
                    $0.typeProvenance == classificationData.typeParent
                }) {
                    // Crée et lie la classification
                    let classification = Classification(
                        nomClassification: classificationData.nomClassification,
                        provenance: parentProvenance // Lien avec le parent
                    )
                    parentProvenance.classifications.append(classification)
                    context.insert(classification)
                }
            }
        }
    
        // Tailles.json
        // Charge toutes les tailles déjà en base dans un dictionnaire
        let taillesEnBase: [Taille] = chargerTaillesEnBase(context: context)
        // Crée un dictionnaire pour accéder facilement à chaque taille
        for tailleData in taillesData {
            if taillesEnBase.first(where: {
                $0.nomTaille == tailleData.nomTaille
            }) == nil {
                let taille = Taille(
                    nomTaille: tailleData.nomTaille,
                    uniteVolume: tailleData.uniteVolume,
                    volume: tailleData.volume
                )
                context.insert(taille)
            }
        }
    
        // Vignobles.json
        // Charge tous les vignobles déjà en base dans un dictionnaire
        let vignoblesEnBase: [Vignoble] = chargerVignoblesEnBase(context: context)
        // Crée un dictionnaire pour accéder facilement à chaque vignoble
        for vignobleData in vignoblesData {
            if vignoblesEnBase.first(where: {
                $0.nomVignoble == vignobleData.nomVignoble &&
                $0.provenance.nomProvenance == vignobleData.nomParent
            }) == nil {
                // Vérifie si la provenance parent existe
                if let parentProvenance = provenancesEnBase.first(where: {
                    $0.nomProvenance == vignobleData.nomParent &&
                    $0.typeProvenance == vignobleData.typeParent
                }) {
                    // Crée et lie le vignoble
                    let vignoble = Vignoble(
                        nomVignoble: vignobleData.nomVignoble,
                        typeVignoble: vignobleData.typeVignoble,
                        provenance: parentProvenance // Lien avec le parent
                    )
                    parentProvenance.vignobles.append(vignoble)
                    context.insert(vignoble)
                }
            }
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
    
    // Méthode pour récupérer toutes les provenances en base
    static func chargerProvenancesEnBase(context: ModelContext) -> [Provenance] {
        let fetchDescriptor = FetchDescriptor<Provenance>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Erreur lors de la récupération des provenances en base : ", error)
            return []
        }
    }
        
    // Méthode pour récupérer toutes les classifications en base
    static func chargerClassificationsEnBase(context: ModelContext) -> [Classification] {
        let fetchDescriptor = FetchDescriptor<Classification>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Erreur lors de la récupération des classifications en base : ", error)
            return []
        }
    }
    
    // Méthode pour récupérer toutes les tailles en base
    static func chargerTaillesEnBase(context: ModelContext) -> [Taille] {
        let fetchDescriptor = FetchDescriptor<Taille>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Erreur lors de la récupération des tailles en base : ", error)
            return []
        }
    }
    
    // Méthode pour récupérer tous les millésimes en base
    static func chargerMillesimesEnBase(context: ModelContext) -> [Millesime] {
        let fetchDescriptor = FetchDescriptor<Millesime>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Erreur lors de la récupération des millésimes en base : ", error)
            return []
        }
    }
    
    // Méthode pour récupérer tous les vignobles en base
    static func chargerVignoblesEnBase(context: ModelContext) -> [Vignoble] {
        let fetchDescriptor = FetchDescriptor<Vignoble>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Erreur lors de la récupération des vignobles en base : ", error)
            return []
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
            Millesime.self,
            Taille.self,
            Millesime.self,
            Vin.self,
            Domaine.self,
            Classification.self,
            Vignoble.self,
            Provenance.self
        ]
        
        for entity in allEntities {
            deleteAll(ofType: entity, context: context)
        }
    }
}
