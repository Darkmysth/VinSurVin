import SwiftUI
import SwiftData

struct CaveView: View {
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = CaveViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.bouteillesFiltreesParRegion.keys.sorted(), id: \.self) { region in
                    Section(header: Text(region)) {
                        ForEach(viewModel.bouteillesFiltreesParRegion[region] ?? [], id: \.self) { bouteille in
                            HStack {
                                Text("\(bouteille.vin.provenance.nomProvenance) - \(bouteille.vin.nomVin) - \(bouteille.millesime) (\(bouteille.quantiteBouteilles))")
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.rechercheUtilisateur, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Ma cave")
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
        .onAppear {
            viewModel.listeBouteilles(from: modelContext) // Récupère les bouteilles avec SwiftData
        }
    }
}
