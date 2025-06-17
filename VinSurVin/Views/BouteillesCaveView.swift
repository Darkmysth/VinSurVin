import SwiftUI
import SwiftData

struct BouteillesCaveView: View {
    
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
                ForEach(viewModel.bouteillesFiltreesSelonStatutAvecRechercheGroupeesParCouleur, id: \.couleur) { section in
                    Section(header: Text(section.couleur)) {
                        ForEach(section.bouteilles, id: \.bouteille.id) { bouteille in
                            NavigationLink(destination: BouteilleDetailsView(bouteilleSelectionnee: bouteille.bouteille)) {
                                VStack {
                                    VStack {
                                        HStack {
                                            Text("\(bouteille.bouteille.millesime?.vin?.provenance.regionParente?.nomProvenance ?? "Région inconnue")")
                                            Spacer()
                                        }
                                        HStack {
                                            Text("\(bouteille.bouteille.millesime?.vin?.provenance.nomProvenance ?? "Appellation inconnue")")
                                            Spacer()
                                        }
                                        HStack {
                                            Text("\(bouteille.bouteille.millesime?.vin?.nomVin ?? "Vin inconnu")")
                                            Spacer()
                                        }
                                        HStack {
                                            Text("Millésime \(bouteille.bouteille.millesime?.anneeMillesime.description ?? "Millésime inconnu")")
                                            Spacer()
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        Text("\(bouteille.bouteille.quantite.description) bouteille(s)")
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
            .searchable(text: $viewModel.rechercheUtilisateur)
            .navigationTitle(viewModel.titre)
        }
    }
}

#Preview {
    BouteillesCaveView(viewModel: ConservationViewModel(statut: nil))
        .modelContainer(SampleData.shared.modelContainer)
}
