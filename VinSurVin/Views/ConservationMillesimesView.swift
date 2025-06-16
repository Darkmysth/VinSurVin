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
<<<<<<< Updated upstream:VinSurVin/Views/ConservationMillesimesView.swift
                                        Text("\(millesime.millesime.vin.provenance.nomProvenance)")
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(millesime.millesime.vin.nomVin) - \(millesime.millesime.anneeMillesime.description)")
=======
                                        Text("\(bouteille.bouteille.millesime.vin.provenance.regionParente?.nomProvenance ?? "")")
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(bouteille.bouteille.millesime.vin.provenance.nomProvenance)")
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(bouteille.bouteille.millesime.vin.nomVin)")
                                        Spacer()
                                    }
                                    HStack {
                                        Text("Millésime \(bouteille.bouteille.millesime.anneeMillesime.description) - \(bouteille.bouteille.taille.nomTaille)")
>>>>>>> Stashed changes:VinSurVin/Views/ConservationBouteillesView.swift
                                        Spacer()
                                    }
                                }
                                HStack {
                                    Spacer()
<<<<<<< Updated upstream:VinSurVin/Views/ConservationMillesimesView.swift
                                    Text("\(millesime.millesime.quantiteBouteilles.description) bouteille(s)")
=======
                                    Text("\(bouteille.bouteille.quantite.description) bouteille(s)")
>>>>>>> Stashed changes:VinSurVin/Views/ConservationBouteillesView.swift
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

#Preview {
    ConservationMillesimesView(statut:.apogee)
        .modelContainer(SampleData.shared.modelContainer)
}
