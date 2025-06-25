import SwiftUI
import SwiftData

struct BouteillesCaveView: View {
    
    // Paramètre reçu en entrée de la vue
    let statutParametre: ConservationViewModel.StatutConservation? = nil
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel: ConservationViewModel
    
    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    init(viewModel: ConservationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(viewModel.bouteillesFiltreesSelonStatutAvecRechercheGroupeesParCouleur, id: \.couleur) { groupe in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(groupe.couleur)
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: gridColumns, spacing: 16) {
                                ForEach(groupe.bouteilles, id: \.bouteille) { recap in
                                    BouteilleCardView(bouteilleSelectionnee: recap.bouteille)
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
}

#Preview {
    BouteillesCaveView(viewModel: ConservationViewModel(statut: nil))
        .modelContainer(SampleData.shared.modelContainer)
}
