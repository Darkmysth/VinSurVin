import SwiftUI
import SwiftData

struct AddDomaineView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = AddDomaineViewModel()
    
    // Création des variables de région : 'selectedRegion' est fourni avec l'appel de la vue par 'AddVinView' tandis que 'selectedRegionReferentiel' est utilisée pour l'appel de la vue depuis le menu des référentiels (par défaut à nil)
    let selectedRegion: Provenance?
    @State private var selectedRegionReferentiel: Provenance?
    
    // Création des variables d'état de la vue
    @Binding var selectedDomaine: Domaine?
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    @Query(filter: #Predicate<Provenance> {$0.typeProvenance == "region"}) private var regions: [Provenance]
    
    // Pour gérer la fermeture de la vue
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails du domaine")) {
                    // Sélection de la région
                    if let selectedRegion {
                        // Région imposée : affichage simple
                        HStack {
                            Text("Région")
                            Spacer()
                            Text(selectedRegion.nomProvenance)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        // Région sélectionnable
                        HStack {
                            Text("Région")
                            Picker("", selection: $selectedRegionReferentiel) {
                                ForEach(regions) { region in
                                    Text(region.nomProvenance).tag(region as Provenance?)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    // Nom du domaine
                    TextField("Nom", text: $viewModel.nomDomaine)
                }
                
                Section {
                    Button("Enregistrer") {
                        let selectedRegionFinale = selectedRegion ?? selectedRegionReferentiel
                        if let nouveauDomaine = viewModel.enregistrerDomaine(selectedRegion: selectedRegionFinale, dans: context) {
                            selectedDomaine = nouveauDomaine
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(!viewModel.isFormComplete)
                }
            }
            .navigationTitle("Nouveau domaine")
            .navigationBarItems(trailing: Button("Fermer") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    AddDomaineView(selectedRegion: nil, selectedDomaine: .constant(nil))
}
