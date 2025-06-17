import SwiftUI
import SwiftData

struct CaveBouteillesView: View {
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveBouteillesViewModel()
    
    // Récupère la couleur et le vin choisis par l'utilisateur
    let couleurSelectionnee: Couleur?
    let appellationSelectionnee: Provenance?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.vinsEtBouteilles) { vinGroup in
                    Section(header: Text(vinGroup.vin?.nomVin ?? "Aucun vin lié au millésime")) {
                        ForEach(vinGroup.bouteilles) { bouteilleRecap in
                            /*NavigationLink(destination: BouteilleDetailsView(bouteilleSelectionnee: bouteilleRecap.bouteille)) {
                                HStack {
                                    VStack {
                                        HStack {
                                            Text("Millésime \(bouteilleRecap.bouteille.millesime?.anneeMillesime.description)")
                                            Spacer()
                                        }
                                        HStack {
                                            Text("\(bouteilleRecap.bouteille.taille.nomTaille)")
                                            Spacer()
                                        }
                                        HStack {
                                            Spacer()
                                            Text("\(bouteilleRecap.quantite) bouteille(s)")
                                        }
                                    }
                                }
                            }*/
                        }
                    }
                }
            }
            .navigationTitle("\(appellationSelectionnee?.nomProvenance ?? "Aucune appellation") -  \(couleurSelectionnee?.nomCouleur ?? "Aucune couleur")")
        }
        .onAppear {
            viewModel.chargerVinsEtBouteilles(couleurFiltre: couleurSelectionnee!, appellationFiltre: appellationSelectionnee!, from: context)
        }
    }
}

#Preview {
    CaveBouteillesView(couleurSelectionnee: .blanc, appellationSelectionnee: SampleData.shared.appellationMuscadet)
        .modelContainer(SampleData.shared.modelContainer)
}
