import SwiftUI
import SwiftData

struct CaveMillesimesView: View {
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveMillesimesViewModel()
    
    // Récupère la couleur et le vin choisis par l'utilisateur
    let selectedCouleur: Couleur?
    let selectedAppellation: Provenance?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.vinsEtMillesimes) { vinGroup in
                    Section(header: Text(vinGroup.vin?.nomVin ?? "Aucun vin lié au millésime")) {
                        ForEach(vinGroup.millesimes) { millesimeRecap in
                            NavigationLink(destination: MillesimeDetailsView(selectedMillesime: millesimeRecap.millesime)) {
                                HStack {
                                    Text("Année \(millesimeRecap.millesime.anneeMillesime.description)")
                                    Spacer()
                                    Text("\(millesimeRecap.quantite) bouteille(s)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(selectedAppellation?.nomProvenance ?? "Aucune appellation") -  \(selectedCouleur?.nomCouleur ?? "Aucune couleur")")
        }
        .onAppear {
            viewModel.chargerVinsEtMillesimes(couleurFiltre: selectedCouleur!, appellationFiltre: selectedAppellation!, from: context)
        }
    }
}

#Preview {
    CaveMillesimesView(selectedCouleur: .blanc, selectedAppellation: SampleData.shared.appellationMuscadet)
        .modelContainer(SampleData.shared.modelContainer)
}
