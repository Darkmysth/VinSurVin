import SwiftUI
import SwiftData

struct CaveAppellationsView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveAppellationsViewModel()
    
    // Récupère la couleur et la région sélectionnées
    let selectedCouleur: Couleur
    let selectedRegion: Provenance
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sousRegionsEtAppellations) { sousRegionGroup in
                    Section(header: Text(sousRegionGroup.sousRegion?.nomProvenance ?? "")) {
                        ForEach(sousRegionGroup.appellations) { appellationRecap in
                            NavigationLink(destination: CaveMillesimesView(selectedCouleur: selectedCouleur, selectedAppellation: appellationRecap.appellation)) {
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
            .navigationTitle(selectedRegion.nomProvenance + " - " + selectedCouleur.nomCouleur)
        }
        .onAppear {
            viewModel.chargerSousRegionsEtAppellations(couleurFiltre: selectedCouleur, regionFiltre: selectedRegion, from: context)
        }
    }
}

#Preview {
    CaveAppellationsView(selectedCouleur: .blanc, selectedRegion: SampleData.shared.regionLoire)
        .modelContainer(SampleData.shared.modelContainer)
}
