import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    // Propriétés publiques pour les previews
    var regionLoire: Provenance!
    var sousRegionPaysNantais: Provenance!
    var appellationMuscadet: Provenance!
    var vinTroisToits: Vin!
    var troisToitsMillesime2024: Millesime!
    var bouteillesTroisToitsMillesime2024: Bouteille!
    var regionBordeaux: Provenance!
    var sousRegionMedoc: Provenance!
    var appellationPauillac: Provenance!
    var vinLafiteRothschild: Vin!
    var lafiteRothschildMillesime1999: Millesime!
    var bouteillesLafiteRothschildMillesime1999: Bouteille!
    var regionBeaujolais: Provenance!
    var sousRegionBeaujolais: Provenance!
    var appellationBeaujolaisVillages: Provenance!
    var vinCroixDeLAnge: Vin!
    var croixDeLAngeMillesime2020: Millesime!
    var bouteillesCroixDeLAngeMillesime2020: Bouteille!
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            Millesime.self,
            Classification.self,
            Domaine.self,
            Provenance.self,
            Taille.self,
            Vignoble.self,
            Vin.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            insertSampleData(in: context)
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    // Méthode d'insertion du sample data
    private func insertSampleData(in context: ModelContext) {
        // Création et insertion de la hiérarchie 'Provenance' dans le contexte SwiftData
        let racineProvenance = Provenance.sampleData()
        insertProvenance(racineProvenance, in: context)
        // Récupération des appellations pour les lier aux vins
        guard
            let loire = racineProvenance.enfants.first(where: { $0.nomProvenance == "Vallée de la Loire"}),
            let paysNantais = loire.enfants.first(where: { $0.nomProvenance == "Pays Nantais"}),
            let muscadet = paysNantais.enfants.first(where: { $0.nomProvenance == "Muscadet Sèvre-et-Maine"}),
            let bordeaux = racineProvenance.enfants.first(where: { $0.nomProvenance == "Bordeaux"}),
            let medoc = bordeaux.enfants.first(where: { $0.nomProvenance == "Médoc"}),
            let pauillac = medoc.enfants.first(where: { $0.nomProvenance == "Pauillac"})

        else { return }
        
        // Rend ces provenances accessibles en Preview
        self.regionLoire = loire
        self.regionBordeaux = bordeaux
        self.sousRegionPaysNantais = paysNantais
        self.sousRegionMedoc = medoc
        self.appellationMuscadet = muscadet
        self.appellationPauillac = pauillac
        
        // Création et insertion d'une classification pour le Pauillac
        let classficationPauillac = Classification.sampleData(provenance: pauillac)
        context.insert(classficationPauillac)
        
        // Création et insertion d'une taille
        let taille = Taille.sampleData().first!
        context.insert(taille)
        
        // Création et insertion des domaines
        let domaineTroisToits = Domaine.sampleTroisToits(provenance: paysNantais)
        let domaineRothschild = Domaine.sampleRothschild(provenance: medoc)
        context.insert(domaineTroisToits)
        context.insert(domaineRothschild)
        
        // Création et insertion d'un vignoble
        let vignobleCruHayeFouassiere = Vignoble.sampleData(provenance: paysNantais)
        context.insert(vignobleCruHayeFouassiere)
        
        // Création et insertion des vins
        let vinTroisToits = Vin.sampleVinTroisToits(provenance: muscadet, domaine: domaineTroisToits)
        context.insert(vinTroisToits)
        self.vinTroisToits = vinTroisToits
        let vinLafiteRothschild = Vin.sampleVinLafiteRothschild(provenance: pauillac, domaine: domaineRothschild)
        context.insert(vinLafiteRothschild)
        
        // Création et insertion des millésimes
        let troisToitsMillesime2024 = Millesime.sampleTroisToitsMillesime2024(vin: vinTroisToits)
        context.insert(troisToitsMillesime2024)
        let lafiteRothschildMillesime1999 = Millesime.sampleLafiteRothschildMillesime1999(vin: vinLafiteRothschild)
        context.insert(lafiteRothschildMillesime1999)
        
        // Création et insertion des bouteilles
        self.bouteillesTroisToitsMillesime2024 = Bouteille(
            quantite: 12,
            dateConsommationMin: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
            dateConsommationMax: Calendar.current.date(from: DateComponents(year: 2028, month: 12, day: 31))!,
            millesime: troisToitsMillesime2024,
            taille: taille
        )
        context.insert(bouteillesTroisToitsMillesime2024)
        self.bouteillesLafiteRothschildMillesime1999 = Bouteille(
            quantite: 6,
            dateConsommationMin: Calendar.current.date(from: DateComponents(year: 2009, month: 1, day: 1))!,
            dateConsommationMax: Calendar.current.date(from: DateComponents(year: 2029, month: 12, day: 31))!,
            millesime: lafiteRothschildMillesime1999,
            taille: taille
        )
        context.insert(bouteillesLafiteRothschildMillesime1999)
    }
    
    // Création d'une méthode d'insertion récursive spécifique à l'entité 'Provenance'
    private func insertProvenance(_ provenance: Provenance, in context: ModelContext) {
        context.insert(provenance)
        provenance.enfants.forEach { insertProvenance($0, in: context) }
    }
}
