import SwiftUI
import SwiftData

struct AddDomaineView: View {
    
    let selectedRegion: Provenance?
    
    // Création des variables d'état de la vue
    @State private var nomDomaine: String = ""
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Pour gérer la fermeture de la vue
    @Environment(\.presentationMode) var presentationMode
    
    // Vérifie si toutes les données sont remplies
    var isFormComplete: Bool {
        !nomDomaine.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails du domaine")) {
                    
                    // Nom du domaine
                    TextField("Nom", text: $nomDomaine)
                }
                
                Section {
                    Button(action: {
                        saveDomaine()
                    }) {
                        Text("Enregistrer")
                    }
                    .disabled(!isFormComplete)
                }
            }
            .navigationTitle("Nouveau domaine")
            .navigationBarItems(trailing: Button("Fermer") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    // Fonction pour créer et sauvegarder un nouveau domaine
    private func saveDomaine() {
        guard let region = selectedRegion else {
            print("Aucune région sélectionnée pour le domaine.")
            return
        }
        
        // Créer une nouvelle instance de Domaine en le rattachant à une région
        let newDomaine = Domaine(
            nomDomaine: nomDomaine,
            provenance: region
        )
        
        // Ajouter le domaine au contexte
        context.insert(newDomaine)
        
        // Sauvegarder le contexte si nécessaire
        do {
            try context.save()
            print("Domaine sauvegardé avec succès.")
        } catch {
            print("Erreur lors de la sauvegarde du domaine : \(error)")
        }
        
        // Fermer la vue
        presentationMode.wrappedValue.dismiss()
    }
}
