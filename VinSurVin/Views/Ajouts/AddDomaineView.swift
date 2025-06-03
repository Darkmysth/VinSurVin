import SwiftUI
import SwiftData

struct AddDomaineView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = AddDomaineViewModel()
    
    let selectedRegion: Provenance?
    
    // Création des variables d'état de la vue
    @Binding var selectedDomaine: Domaine?
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Pour gérer la fermeture de la vue
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails du domaine")) {
                    // Nom du domaine
                    TextField("Nom", text: $viewModel.nomDomaine)
                }
                
                Section {
                    Button("Enregistrer") {
                        if let nouveauDomaine = viewModel.enregistrerDomaine(selectedRegion: selectedRegion, dans: context) {
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
