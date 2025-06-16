import SwiftData
import SwiftUI

struct ReferentielDomainesView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = ReferentielDomainesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.listeDomainesParRegionFiltree) { groupe in
                Section(header: Text(groupe.region)) {
                    ForEach(groupe.listeDomaines, id: \.self) { domaine in
                        Text(domaine.nomDomaine)
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let domaine = groupe.listeDomaines[offset]
                            viewModel.supprimerDomaine(domaine, from: context)
                        }
                    }
                }
            }
        }
        .navigationTitle("Domaines")
        .onAppear {
            viewModel.chargerDomaines(from: context)
        }
        .searchable(text: $viewModel.rechercheUtilisateur)
    }
}

#Preview {
    ReferentielDomainesView()
        .modelContainer(SampleData.shared.modelContainer)
}
