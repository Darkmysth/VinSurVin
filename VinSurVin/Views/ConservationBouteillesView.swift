import SwiftUI
import SwiftData

struct ConservationBouteillesView: View {
    
    // Paramètre reçu en entrée de la vue
    let statutParametre: ConservationViewModel.StatutConservation?
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel: ConservationViewModel
    
    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    init(statut: ConservationViewModel.StatutConservation) {
        self.statutParametre = statut
        _viewModel = StateObject(wrappedValue: ConservationViewModel(statut: statut))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.bouteillesFiltreesSelonStatutAvecRechercheGroupeesParCouleur, id: \.couleur) { section in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(section.couleur)
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        LazyVGrid(columns: gridColumns, spacing: 16) {
                            ForEach(section.bouteilles, id: \.bouteille.id) { bouteille in
                                BouteilleCardView(bouteilleSelectionnee: bouteille.bouteille)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .searchable(text: $viewModel.rechercheUtilisateur)
        .navigationTitle(viewModel.titre)
        .onAppear {
            viewModel.chargerBouteillesLimiteConservation(from: context)
        }
    }
}

#Preview {
    ConservationBouteillesView(statut:.apogee)
        .modelContainer(SampleData.shared.modelContainer)
}
