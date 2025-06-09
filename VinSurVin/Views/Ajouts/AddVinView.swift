import SwiftUI
import SwiftData

struct AddVinView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = AddVinViewModel()
    
    // Création des variables d'état de la vue
    @State private var choixClassification = false
    @State private var choixVignoble = false

    @Binding var selectedVin: Vin?
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Pour gérer la fermeture de la vue
    @Environment(\.presentationMode) var presentationMode
    
    // Initialise quelques propriétés par défaut
    private func initialiserValeursDefaut() {
        if viewModel.selectedSucrosite == nil {
            viewModel.selectedSucrosite = Sucrosite.sec
        }
        if viewModel.selectedCouleur == nil {
            viewModel.selectedCouleur = Couleur.rouge
        }
        if viewModel.selectedCaracteristique == nil {
            viewModel.selectedCaracteristique = Caracteristique.tranquille
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails du vin")) {
                    
                    // Nom du vin
                    TextField("Nom", text: $viewModel.nomVin)
                    
                    // Sélection de l'appellation
                    NavigationLink(destination: SelectAppellationView(selectedAppellation: $viewModel.selectedAppellation)) {
                        HStack {
                            Text("Appellation")
                            Spacer()
                            Text(viewModel.selectedAppellation?.nomProvenance ?? "Aucune appellation sélectionnée")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection du vignoble
                    if choixVignoble == true {
                        NavigationLink(
                            destination: {SelectVignobleView(vignoblesByProvenance: viewModel.vignoblesByProvenance, selectedVignoble: $viewModel.selectedVignoble)},
                            label: {
                                HStack {
                                    Text("Vignoble")
                                    Spacer()
                                    Text(viewModel.selectedVignoble?.nomVignoble ?? "Aucun vignoble sélectionné")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                        .disabled(viewModel.selectedAppellation == nil)
                    }
                    
                    // Sélection du domaine
                    NavigationLink(
                        destination: {SelectDomaineView(selectedRegion: viewModel.selectedRegion, selectedDomaine: $viewModel.selectedDomaine)},
                        label: {
                            HStack {
                                Text("Domaine")
                                Spacer()
                                Text(viewModel.selectedDomaine?.nomDomaine ?? "Aucun domaine sélectionné")
                                    .foregroundColor(.gray)
                            }
                        }
                    )
                    .disabled(viewModel.selectedAppellation == nil)
                    
                    // Sélection de la classification
                    if choixClassification == true {
                        NavigationLink(
                            destination: {SelectClassificationView(classificationsByProvenance: viewModel.classificationsByProvenance, selectedClassification: $viewModel.selectedClassification)},
                            label: {
                                HStack {
                                    Text("Classification")
                                    Spacer()
                                    Text(viewModel.selectedClassification?.nomClassification ?? "Aucune classification sélectionnée")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                        .disabled(viewModel.selectedAppellation == nil)
                    }
                    
                    // Sélection de la sucrosité du vin
                    VStack {
                        HStack {
                            Text("Sucrosité")
                            Spacer()
                        }
                        Picker("", selection: $viewModel.selectedSucrosite) {
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
                        Picker("", selection: $viewModel.selectedCouleur) {
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
                        Picker("", selection: $viewModel.selectedCaracteristique) {
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
                            selectedVin = nouveauVin
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(!viewModel.isFormComplete)
                }
            }
            .onChange(of: viewModel.selectedAppellation) {
                viewModel.chargerClassifications(from: context)
                viewModel.filtrerClassificationsByProvenance()
                choixClassification = !viewModel.classificationsByProvenance.isEmpty
                viewModel.chargerVignobles(from: context)
                viewModel.filtrerVignoblesByProvenance()
                choixVignoble = !viewModel.vignoblesByProvenance.isEmpty
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
    @Previewable @State var selectedVin: Vin? = nil

    return AddVinView(selectedVin: $selectedVin)
        .modelContainer(SampleData.shared.modelContainer)
}
