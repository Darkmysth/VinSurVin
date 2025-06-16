import SwiftUI
import SwiftData

struct CaveBouteillesView: View {
    
    // Paramètre reçu en entrée de la vue
    let statutParametre: ConservationViewModel.StatutConservation? = nil
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel: ConservationViewModel
    init(viewModel: ConservationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.millesimesFiltreesSelonStatutAvecRechercheGroupeesParCouleur, id: \.couleur) { section in
                    Section(header: Text(section.couleur)) {
                        ForEach(section.millesimes, id: \.millesime.id) { millesime in
                            NavigationLink(destination: MillesimeDetailsView(selectedMillesime: millesime.millesime)) {
                                VStack {
                                    VStack {
                                        HStack {
                                            Text("\(millesime.millesime.vin.provenance.nomProvenance)")
                                            Spacer()
                                        }
                                        HStack {
                                            Text("\(millesime.millesime.vin.nomVin) - \(millesime.millesime.anneeMillesime.description)")
                                            Spacer()
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        Text("\(millesime.millesime.quantiteBouteilles.description) bouteille(s)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.chargerMillesimesLimiteConservation(from: context)
            }
            .searchable(text: $viewModel.rechercheUtilisateur)
            .navigationTitle(viewModel.titre)
        }
    }
}

#Preview {
    CaveBouteillesView(viewModel: ConservationViewModel(statut: nil))
        .modelContainer(SampleData.shared.modelContainer)
}
