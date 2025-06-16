import SwiftUI
import SwiftData

struct AjoutDomaineView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = AjoutDomaineViewModel()
    
    // Création des variables de région : 'regionSelectionnee' est fourni avec l'appel de la vue par 'AjoutVinView' tandis que 'regionReferentielSelectionnee' est utilisée pour l'appel de la vue depuis le menu des référentiels (par défaut à nil)
    let regionSelectionnee: Provenance?
    @State private var regionReferentielSelectionnee: Provenance?
    
    // Création des variables d'état de la vue
    @Binding var domaineSelectionne: Domaine?
    
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
                    if let regionSelectionnee {
                        // Région imposée : affichage simple
                        HStack {
                            Text("Région")
                            Spacer()
                            Text(regionSelectionnee.nomProvenance)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        // Région sélectionnable
                        HStack {
                            Text("Région")
                            Picker("", selection: $regionReferentielSelectionnee) {
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
                        let regionSelectionneeFinale = regionSelectionnee ?? regionReferentielSelectionnee
                        if let nouveauDomaine = viewModel.enregistrerDomaine(regionSelectionnee: regionSelectionneeFinale, dans: context) {
                            domaineSelectionne = nouveauDomaine
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
    AjoutDomaineView(regionSelectionnee: nil, domaineSelectionne: .constant(nil))
}
