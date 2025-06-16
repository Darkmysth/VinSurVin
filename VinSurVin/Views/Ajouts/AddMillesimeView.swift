import SwiftUI
import SwiftData
import Foundation

struct AddMillesimeView: View {
    
    // Relie cette vue avec son ViewModel
<<<<<<< Updated upstream:VinSurVin/Views/Ajouts/AddMillesimeView.swift
    @StateObject private var viewModel = AddMillesimeViewModel()
=======
    @StateObject private var viewModel = AjoutBouteilleViewModel()
>>>>>>> Stashed changes:VinSurVin/Views/Ajouts/AjoutBouteilleView.swift
    @StateObject private var detourageViewModel = DetourageViewModel()
    
    // Prépare les variables d'état recueillant les saisies de l'utilisateur
    @State private var afficheVin = false
    @State private var afficheTaille = false
    @State private var afficheAnneeMillesime = false
    @State private var afficheQuantite = false
    @State private var afficheConservation = false
    @State private var shouldRefreshVinList: Bool = false
    let years: [Int] = Array(Int(1950)...Int(Calendar.current.component(.year, from: Date())))
    @State private var searchText: String = ""
    @State private var afficheCamera = false
    @State private var imageEnEntree: UIImage?
    
    // Permet de revenir à la vue précédente
    @Environment(\.presentationMode) var presentationMode
    
    // Accès au contexte de gestion des objets Core Data
    @Environment(\.modelContext) private var context
    
    // Initialise la taille par défaut
    private func initializeDefaultTaille() {
        if viewModel.tailleSelectionnee == nil {
            if let tailleDefaut = try? context.fetch(FetchDescriptor<Taille>(predicate: #Predicate { $0.nomTaille == "Bouteille standard" })).first {
                viewModel.tailleSelectionnee = tailleDefaut
            } else {
                print("Erreur : impossible de trouver la taille par défaut.")
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails du millésime")) {
                    
                    // Sélection du vin du millésime
                    NavigationLink(destination: SelectVinView(vinSelectionne: $viewModel.vinSelectionne)) {
                        HStack {
                            Text("Vin")
                            Spacer()
                            Text(viewModel.vinSelectionne?.nomVin ?? "Aucun vin sélectionné")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection de la taille du millésime (demi-bouteille, 75 cL, magnum, etc.)
                    NavigationLink(destination: SelectTailleView(tailleSelectionnee: $viewModel.tailleSelectionnee)) {
                        HStack {
                            Text("Taille")
                            Spacer()
                            Text(viewModel.tailleSelectionnee?.nomTaille ?? "Aucune taille sélectionnée")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection de l'année du millésime
                    VStack {
                        HStack {
                            Text("Année \(viewModel.anneeSelectionnee.withoutThousandSeparator)")
                            Spacer()
                        }
                        Picker("Année", selection: $viewModel.anneeSelectionnee) {
                            ForEach(years, id: \.self) { year in
                                Text(year.withoutThousandSeparator).tag(year)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    // Sélection de la quantité de bouteilles ajoutées
                    VStack {
                        HStack {
                            Text("Quantité")
                            Spacer()
                        }
                        Stepper(value: $viewModel.quantiteSelectionnee, in: 1...100) {
                            Text("\(viewModel.quantiteSelectionnee) bouteille(s)")
                            }
                    }
                    
                    // Sélection de la durée de conservation du millésime (en attendant un algorithme ou une requête vers Apple Intelligence ou ChatGPT
                    VStack {
                        HStack {
                            Text("Durée de conservation")
                            Spacer()
                        }
                        HStack {
                            Stepper(value: $viewModel.conservationMinSelectionnee, in: 0...100) {
                                Text("Entre \(viewModel.conservationMinSelectionnee) an(s)")
                                }
                            .onChange(of: viewModel.conservationMinSelectionnee) {
                                if viewModel.conservationMinSelectionnee > viewModel.conservationMaxSelectionnee {
                                    viewModel.conservationMaxSelectionnee = viewModel.conservationMinSelectionnee
                                    }
                                }
                        }
                        HStack {
                            Stepper(value: $viewModel.conservationMaxSelectionnee, in: 1...100) {
                                Text("et \(viewModel.conservationMaxSelectionnee) an(s)")
                                }
                            .onChange(of: viewModel.conservationMaxSelectionnee) {
                                if viewModel.conservationMaxSelectionnee < viewModel.conservationMinSelectionnee {
                                    viewModel.conservationMinSelectionnee = viewModel.conservationMaxSelectionnee
                                    }
                                }
                        }
                    }
                    // Sélection de la photo de la bouteille du millésime
                    Section() {
                        // Affiche la photo si elle existe
                        if let image = detourageViewModel.imageDetouree {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        // Le bouton pour prendre ou changer la photo
                        Button(detourageViewModel.imageDetouree == nil ? "Ajouter une photo" : "Changer la photo") {
                         self.afficheCamera = true
                         }
                    }
                }
                
                Section {
                    Button("Enregistrer") {
                        if viewModel.enregistrerMillesime(dans: context) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(!viewModel.isFormComplete)
                }
            }
            .onAppear(perform: initializeDefaultTaille) // Initialise la taille par défaut
<<<<<<< Updated upstream:VinSurVin/Views/Ajouts/AddMillesimeView.swift
            .navigationTitle("Nouveau millésime")
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $inputImage)
=======
            .navigationTitle("Nouvelle bouteille")
            .sheet(isPresented: $afficheCamera) {
                ImagePicker(image: $imageEnEntree)
>>>>>>> Stashed changes:VinSurVin/Views/Ajouts/AjoutBouteilleView.swift
            }
            .onChange(of: imageEnEntree) { _, newImage in
                guard let newImage else {
                    return
                }
                detourageViewModel.supprimerArrierePlan(from: newImage)
            }
            .onChange(of: detourageViewModel.imageDetouree) { _, nouvelleImage in
                viewModel.photoSelectionnee = nouvelleImage
            }
        }
    }
}

// Extension pour formater l'affichage des années sans séparateur de milliers
extension Int {
    var withoutThousandSeparator: String {
        return String(format: "%d", self)
    }
}

extension Date {
    static func from(jour: Int, mois: Int, annee: Int) -> Date? {
        var components = DateComponents()
        components.day = jour
        components.month = mois
        components.year = annee
        return Calendar.current.date(from: components)
    }
}

#Preview {
<<<<<<< Updated upstream:VinSurVin/Views/Ajouts/AddMillesimeView.swift
    AddMillesimeView()
=======
    AjoutBouteilleView()
>>>>>>> Stashed changes:VinSurVin/Views/Ajouts/AjoutBouteilleView.swift
}
