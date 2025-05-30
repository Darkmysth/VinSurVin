import SwiftUI
import SwiftData

struct CaveView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveViewModel()
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.couleursEtRegions) { couleurGroup in
                    Section(header: Text(couleurGroup.couleur.nomCouleur)) {
                        ForEach(couleurGroup.regions) { regionRecap in
                            NavigationLink(destination: CaveAppellationsView(selectedCouleur: couleurGroup.couleur, selectedRegion: regionRecap.region)) {
                                HStack {
                                    Text(regionRecap.region.nomProvenance)
                                    Spacer()
                                    Text("\(regionRecap.quantite) bouteille(s)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Ma cave"))
        }
        .onAppear {
            viewModel.chargerCouleursEtRegions(from: context)
        }
    }
}

#Preview {
    CaveView()
        .modelContainer(SampleData.shared.modelContainer)
}
