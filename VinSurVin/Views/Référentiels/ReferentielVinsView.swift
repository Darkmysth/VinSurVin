import SwiftData
import SwiftUI

struct ReferentielVinsView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = ReferentielVinsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.listeVinsParRegionFiltree) { groupe in
                Section(header: Text(groupe.region)) {
                    ForEach(groupe.listeVins, id: \.self) { vin in
                        Text(vin.nomVin)
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let vin = groupe.listeVins[offset]
                            viewModel.supprimerVin(vin, from: context)
                        }
                    }
                }
            }
        }
        .navigationTitle("Vins")
        .onAppear {
            viewModel.chargerVins(from: context)
        }
        .searchable(text: $viewModel.rechercheUtilisateur)
    }
}

#Preview {
    ReferentielVinsView()
        .modelContainer(SampleData.shared.modelContainer)
}
