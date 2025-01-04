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
        //let provenancesData: [ProvenanceCodable] = loadJSON(filename: "Provenances")
        let taillesData: [TailleCodable] = loadJSON(filename: "Tailles")
        //let vignoblesData: [VignobleCodable] = loadJSON(filename: "Classifications")
        
        // 2 - Chargement des données à partir de la structure intermédiaire dans la classe stockant les données
            // Classifications.json
            for classificationData in classificationsData {
                let classification = Classification(
                    nomClassification: classificationData.nomClassification
                )
                context.insert(classification)
            }
            // Provenances.json
            /*for provenanceData in provenancesData {
                let provenance = Provenance(
                    nomProvenance: provenanceData.nomProvenance,
                    typeProvenance: provenanceData.typeProvenance
                )
                context.insert(provenance)
            }*/
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
            /*for vignobleData in vignoblesData {
                let vignoble = Vignoble(
                    nomVignoble: vignobleData.nomVignoble,
                    typeVignoble: vignobleData.typeVignoble
                )
                context.insert(vignoble)
            }*/
        
        // 3 - Sauvegarde des données
        do {
            try context.save()
            print("Données initiales importées avec succès.")
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
}
