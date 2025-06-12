import SwiftUI
import SwiftData

struct CaveBouteillesView: View {
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveBouteillesViewModel()
    
    // Récupère la couleur et le vin choisis par l'utilisateur
    let selectedCouleur: Couleur?
    let selectedAppellation: Provenance?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.vinsEtBouteilles) { vinGroup in
                    Section(header: Text(vinGroup.vin?.nomVin ?? "Aucun vin lié à la bouteille")) {
                        ForEach(vinGroup.bouteilles) { bouteilleRecap in
                            NavigationLink(destination: BouteilleDetailsView(selectedBouteille: bouteilleRecap.bouteille)) {
                                HStack {
                                    Text("Millésime \(bouteilleRecap.bouteille.millesime.description)")
                                    Spacer()
                                    Text("\(bouteilleRecap.quantite) bouteille(s)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(selectedAppellation?.nomProvenance ?? "Aucune appellation") -  \(selectedCouleur?.nomCouleur ?? "Aucune couleur")")
        }
        .onAppear {
            viewModel.chargerVinsEtBouteilles(couleurFiltre: selectedCouleur!, appellationFiltre: selectedAppellation!, from: context)
        }
    }
}

#Preview {
    CaveBouteillesView(selectedCouleur: .blanc, selectedAppellation: SampleData.shared.appellationMuscadet)
        .modelContainer(SampleData.shared.modelContainer)
}
