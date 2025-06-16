import SwiftUI
import SwiftData

struct CaveAppellationsView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveAppellationsViewModel()
    
    // Récupère la couleur et la région sélectionnées
    let couleurSelectionnee: Couleur
    let regionSelectionnee: Provenance
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sousRegionsEtAppellations) { sousRegionGroup in
                    Section(header: Text(sousRegionGroup.sousRegion?.nomProvenance ?? "")) {
                        ForEach(sousRegionGroup.appellations) { appellationRecap in
                            NavigationLink(destination: CaveBouteillesView(couleurSelectionnee: couleurSelectionnee, appellationSelectionnee: appellationRecap.appellation)) {
                                HStack {
                                    Text(appellationRecap.appellation.nomProvenance)
                                    Spacer()
                                    Text("\(appellationRecap.quantite) bouteille(s)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(regionSelectionnee.nomProvenance + " - " + couleurSelectionnee.nomCouleur)
        }
        .onAppear {
            viewModel.chargerSousRegionsEtAppellations(couleurFiltre: couleurSelectionnee, regionFiltre: regionSelectionnee, from: context)
        }
    }
}

#Preview {
    CaveAppellationsView(couleurSelectionnee: .blanc, regionSelectionnee: SampleData.shared.regionLoire)
        .modelContainer(SampleData.shared.modelContainer)
}
