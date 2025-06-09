import SwiftUI
import SwiftData

struct ConservationBouteillesView: View {
    
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
            ForEach(viewModel.bouteillesFiltreesSelonStatutAvecRechercheGroupeesParCouleur, id: \.couleur) { section in
                Section(header: Text(section.couleur)) {
                    ForEach(section.bouteilles, id: \.bouteille.id) { bouteille in
                        NavigationLink(destination: BouteilleView(selectedBouteille: bouteille.bouteille)) {
                            VStack {
                                VStack {
                                    HStack {
                                        Text("\(bouteille.bouteille.vin.provenance.nomProvenance)")
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(bouteille.bouteille.vin.nomVin) - \(bouteille.bouteille.millesime.description)")
                                        Spacer()
                                    }
                                }
                                HStack {
                                    Spacer()
                                    Text("\(bouteille.bouteille.quantiteBouteilles.description) bouteille(s)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.chargerBouteillesLimiteConservation(from: context)
        }
        .searchable(text: $viewModel.searchQuery)
        .navigationTitle(viewModel.titre)
    }
}

#Preview {
    ConservationBouteillesView(statut:.apogee)
        .modelContainer(SampleData.shared.modelContainer)
}
