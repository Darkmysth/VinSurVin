    import SwiftUI
    import SwiftData

    struct AddVinView: View {
        
        // Création des variables d'état de la vue
        @State private var nomVin: String = ""
        @State private var selectedSucrosite: Sucrosite = .sec
        @State private var selectedCouleur: Couleur = .rouge
        @State private var selectedCaracteristique: Caracteristique = .tranquille
        @State private var selectedDomaine: Domaine? = nil
        @State private var selectedAppellation: Provenance? = nil
        @State private var selectedClassification: Classification? = nil
        var selectedRegion: Provenance? {
            selectedAppellation?.regionParente
        }
        var selectedSousRegion: Provenance? {
            selectedAppellation?.sousRegionParente
        }
        
        // Accès au contexte SwiftData
        @Environment(\.modelContext) private var context
        
        // Pour gérer la fermeture de la vue
        @Environment(\.presentationMode) var presentationMode
        
        // Vérifie si toutes les données sont remplies
        var isFormComplete: Bool {
            !nomVin.isEmpty && selectedAppellation != nil && selectedDomaine != nil && selectedClassification != nil
        }
        
        var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text("Détails du vin")) {
                        
                        // Nom du vin
                        TextField("Nom", text: $nomVin)
                        
                        // Sélection de l'appellation
                        NavigationLink(destination: SelectAppellationView(selectedAppellation: $selectedAppellation)) {
                            HStack {
                                Text("Appellation")
                                Spacer()
                                Text(selectedAppellation?.nomProvenance ?? "Aucune appellation sélectionnée")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Sélection du domaine
                        NavigationLink(
                            destination: {SelectDomaineView(selectedRegion: selectedRegion, selectedDomaine: $selectedDomaine)},
                            label: {
                                HStack {
                                    Text("Domaine")
                                    Spacer()
                                    Text(selectedDomaine?.nomDomaine ?? "Aucun domaine sélectionné")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                        .disabled(selectedAppellation == nil) 
                        
                        // Sélection de la classification
                        NavigationLink(
                            destination: {SelectClassificationView(selectedRegion: selectedRegion, selectedSousRegion: selectedSousRegion, selectedAppellation: selectedAppellation, selectedClassification: $selectedClassification)},
                            label: {
                                HStack {
                                    Text("Classification")
                                    Spacer()
                                    Text(selectedClassification?.nomClassification ?? "Aucune classification sélectionnée")
                                        .foregroundColor(.gray)
                                }
                            }
                        )
                        .disabled(selectedAppellation == nil)
                        
                        // Sélection de la sucrosité du vin
                        VStack {
                            HStack {
                                Text("Sucrosité")
                                Spacer()
                            }
                            Picker("", selection: $selectedSucrosite) {
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
                            Picker("", selection: $selectedCouleur) {
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
                            Picker("", selection: $selectedCaracteristique) {
                                ForEach(Caracteristique.allCases) { caracteristique in
                                    Text(caracteristique.nomCaracteristique).tag(caracteristique)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                        }
                    }
                    
                    Section {
                        Button(action: saveVin) {
                            Text("Enregistrer")
                        }
                        .disabled(!isFormComplete)
                    }
                }
                .navigationTitle("Nouveau vin")
                .navigationBarItems(trailing: Button("Fermer") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
        
        // Fonction pour créer et sauvegarder un nouveau vin
        private func saveVin() {
            
            // Créer une nouvelle instance de Vin en le rattachant à une région
            let newVin = Vin(
                nomVin: nomVin,
                sucrosite: selectedSucrosite,
                couleur: selectedCouleur,
                caracteristique: selectedCaracteristique,
                provenance: selectedAppellation!, // On force le déballage de 'selectedAppellation' parce qu'on est certain qu'il est renseigné grâce à 'isFormComplete'
                classification: selectedClassification!, // On force le déballage de 'selectedClassification' parce qu'on est certain qu'il est renseigné grâce à 'isFormComplete'
                domaine: selectedDomaine! // On force le déballage de 'selectedDomaine' parce qu'on est certain qu'il est renseigné grâce à 'isFormComplete'
            )
            
            // Ajouter le domaine au contexte
            context.insert(newVin)
            
            // Sauvegarder le contexte si nécessaire
            do {
                try context.save()
                print("Vin sauvegardé avec succès.")
            } catch {
                print("Erreur lors de la sauvegarde du vin : \(error)")
            }
            
            // Fermer la vue
            presentationMode.wrappedValue.dismiss()
        }
    }
