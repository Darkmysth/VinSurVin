import SwiftUI
import SwiftData

struct BouteilleView: View {
    
    // Récupère la bouteille sélectionnée par l'utilisateur
    let selectedBouteille: Bouteille
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Provenance")) {
                    HStack {
                        Text("Pays :")
                        Spacer()
                        Text("\(selectedBouteille.vin.provenance.paysParent?.nomProvenance ?? "Pays non renseigné")")
                    }
                    HStack {
                        Text("Région :")
                        Spacer()
                        Text("\(selectedBouteille.vin.provenance.regionParente?.nomProvenance ?? "Région non renseignée")")
                    }
                    HStack {
                        Text("Sous-région :")
                        Spacer()
                        Text("\(selectedBouteille.vin.provenance.sousRegionParente?.nomProvenance ?? "Sous-région non renseignée")")
                    }
                    HStack {
                        Text("Appellation :")
                        Spacer()
                        Text("\(selectedBouteille.vin.provenance.nomProvenance)")
                    }
                    if selectedBouteille.vin.vignoble != nil {
                        HStack {
                            Text("Vignoble :")
                            Spacer()
                            Text("\(selectedBouteille.vin.vignoble?.nomVignoble ?? "Vignoble non renseigné")")
                        }
                    }
                    HStack {
                        Text("Domaine :")
                        Spacer()
                        Text("\(selectedBouteille.vin.domaine.nomDomaine)")
                    }
                }
                Section(header: Text("Détails du vin")) {
                    HStack {
                        Text("Vin :")
                        Spacer()
                        Text("\(selectedBouteille.vin.nomVin)")
                    }
                    HStack {
                        Text("Couleur :")
                        Spacer()
                        Text("\(selectedBouteille.vin.couleur.nomCouleur)")
                    }
                    HStack {
                        Text("Sucrosité :")
                        Spacer()
                        Text("\(selectedBouteille.vin.sucrosite.nomSucrosite)")
                    }
                    HStack {
                        Text("Caractéristique :")
                        Spacer()
                        Text("\(selectedBouteille.vin.caracteristique.nomCaracteristique)")
                    }
                    if selectedBouteille.vin.classification != nil {
                        HStack {
                            Text("Classification :")
                            Spacer()
                            Text("\(selectedBouteille.vin.classification?.nomClassification ?? "Classification non renseignée")")
                        }
                    }
                }
                Section(header: Text("Détails de la bouteille")) {
                    HStack {
                        Text("Taille :")
                        Spacer()
                        Text("\(selectedBouteille.taille.volume.description) \(selectedBouteille.taille.uniteVolume)")
                    }
                    HStack {
                        Text("Millésime :")
                        Spacer()
                        Text("\(selectedBouteille.millesime.description)")
                    }
                    HStack {
                        Text("Stock :")
                        Spacer()
                        Text("\(selectedBouteille.quantiteBouteilles)")
                    }
                    VStack {
                        HStack {
                            Text("A consommer entre :")
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("\(selectedBouteille.dateConsommationMin.formatJJMMAAAA) et \(selectedBouteille.dateConsommationMax.formatJJMMAAAA)")
                        }
                    }
                }
            }
            .navigationTitle(selectedBouteille.vin.nomVin + " - " + selectedBouteille.millesime.description)
        }
    }
}

extension Date {
    var formatJJMMAAAA: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}

#Preview {
    BouteilleView(selectedBouteille: SampleData.shared.bouteilleTroisToits2024)
        .modelContainer(SampleData.shared.modelContainer)
}
