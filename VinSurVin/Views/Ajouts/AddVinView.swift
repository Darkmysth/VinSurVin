import SwiftUI
import SwiftData

struct AjoutVinView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = AjoutVinViewModel()
    
    // Création des variables d'état de la vue
    @State private var choixClassification = false
    @State private var choixVignoble = false

    @Binding var vinSelectionne: Vin?
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Pour gérer la fermeture de la vue
    @Environment(\.presentationMode) var presentationMode
    
    // Initialise quelques propriétés par défaut
    private func initialiserValeursDefaut() {
        if viewModel.sucrositeSelectionnee == nil {
            viewModel.sucrositeSelectionnee = Sucrosite.sec
        }
        if viewModel.couleurSelectionnee == nil {
            viewModel.couleurSelectionnee = Couleur.rouge
        }
        if viewModel.caracteristiqueSelectionnee == nil {
            viewModel.caracteristiqueSelectionnee = Caracteristique.tranquille
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails du vin")) {
                    
                    // Nom du vin
                    TextField("Nom", text: $viewModel.nomVin)
                    
                    // Sélection de l'appellation
                    NavigationLink(destination: SelectAppellationView(appellationSelectionnee: $viewModel.appellationSelectionnee)) {
                        HStack {
                            Text("Appellation")
                            Spacer()
                            Text(viewModel.appellationSelectionnee?.nomProvenance ?? "Aucune appellation sélectionnée")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection du vignoble
                    if choixVignoble == true {
                        NavigationLink(
                            destination: {SelectVignobleView(listeVignoblesRegroupesParProvenance: viewModel.listeVignoblesRegroupesParProvenance, vignobleSelectionne: $viewModel.vignobleSelectionne)},
                            label: {
                                HStack {
                                    Text("Vignoble")
                                    Spacer()
                                    Text(viewModel.vignobleSelectionne?.nomVignoble ?? "Aucun vignoble sélectionné")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                        .disabled(viewModel.appellationSelectionnee == nil)
                    }
                    
                    // Sélection du domaine
                    NavigationLink(
                        destination: {SelectDomaineView(regionSelectionnee: viewModel.regionSelectionnee, domaineSelectionne: $viewModel.domaineSelectionne)},
                        label: {
                            HStack {
                                Text("Domaine")
                                Spacer()
                                Text(viewModel.domaineSelectionne?.nomDomaine ?? "Aucun domaine sélectionné")
                                    .foregroundColor(.gray)
                            }
                        }
                    )
                    .disabled(viewModel.appellationSelectionnee == nil)
                    
                    // Sélection de la classification
                    if choixClassification == true {
                        NavigationLink(
                            destination: {SelectClassificationView(listeClassificationsRegroupeesParProvenance: viewModel.listeClassificationsRegroupeesParProvenance, classificationSelectionnee: $viewModel.classificationSelectionnee)},
                            label: {
                                HStack {
                                    Text("Classification")
                                    Spacer()
                                    Text(viewModel.classificationSelectionnee?.nomClassification ?? "Aucune classification sélectionnée")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                        .disabled(viewModel.appellationSelectionnee == nil)
                    }
                    
                    // Sélection de la sucrosité du vin
                    VStack {
                        HStack {
                            Text("Sucrosité")
                            Spacer()
                        }
                        Picker("", selection: $viewModel.sucrositeSelectionnee) {
                            ForEach(Sucrosite.allCases) { sucrosite in
                                Text(sucrosite.nomSucrosite).tag(sucrosite)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                    }
                    
                    // Sélection de la couleur du vin
                    VStack {
                        HStack {
                            Text("Couleur")
                            Spacer()
                        }
                        Picker("", selection: $viewModel.couleurSelectionnee) {
                            ForEach(Couleur.allCases) { couleur in
                                Text(couleur.nomCouleur).tag(couleur)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    
                    // Sélection de la caractéristique spécifique du vin
                    VStack {
                        HStack {
                            Text("Caractéristique spécifique")
                            Spacer()
                        }
                        Picker("", selection: $viewModel.caracteristiqueSelectionnee) {
                            ForEach(Caracteristique.allCases) { caracteristique in
                                Text(caracteristique.nomCaracteristique).tag(caracteristique)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    }
                }
                
                Section {
                    Button("Enregistrer") {
                        if let nouveauVin = viewModel.enregistrerVin(dans: context) {
                            vinSelectionne = nouveauVin
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(!viewModel.isFormComplete)
                }
            }
            .onChange(of: viewModel.appellationSelectionnee) {
                viewModel.chargerClassifications(from: context)
                viewModel.filtrerlisteClassificationsRegroupeesParProvenance()
                choixClassification = !viewModel.listeClassificationsRegroupeesParProvenance.isEmpty
                viewModel.chargerVignobles(from: context)
                viewModel.filtrerlisteVignoblesRegroupesParProvenance()
                choixVignoble = !viewModel.listeVignoblesRegroupesParProvenance.isEmpty
            }
            .onAppear (perform: initialiserValeursDefaut)
            .navigationTitle("Nouveau vin")
            .navigationBarItems(trailing: Button("Fermer") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    // Crée une variable @State pour le binding
    @Previewable @State var vinSelectionne: Vin? = nil

    return AjoutVinView(vinSelectionne: $vinSelectionne)
        .modelContainer(SampleData.shared.modelContainer)
}
