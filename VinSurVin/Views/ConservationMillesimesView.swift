import SwiftUI
import SwiftData

struct ConservationMillesimesView: View {
    
    // Paramètre reçu en entrée de la vue
    let statutParametre: ConservationViewModel.StatutConservation?
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel: ConservationViewModel
    
    init(statut: ConservationViewModel.StatutConservation) {
        self.statutParametre = statut
        _viewModel = StateObject(wrappedValue: ConservationViewModel(statut: statut))
    }
    
    var body: some View {
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
        .searchable(text: $viewModel.searchQuery)
        .navigationTitle(viewModel.titre)
    }
}

#Preview {
    ConservationMillesimesView(statut:.apogee)
        .modelContainer(SampleData.shared.modelContainer)
}
