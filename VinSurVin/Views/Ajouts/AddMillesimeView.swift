import SwiftUI
import SwiftData
import Foundation

struct AddMillesimeView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = AddMillesimeViewModel()
    @StateObject private var detourageViewModel = DetourageViewModel()
    
    // Prépare les variables d'état recueillant les saisies de l'utilisateur
    @State private var showVin = false
    @State private var showTaille = false
    @State private var showAnneeMillesime = false
    @State private var showQuantite = false
    @State private var showConservation = false
    @State private var shouldRefreshVinList: Bool = false
    let years: [Int] = Array(Int(1950)...Int(Calendar.current.component(.year, from: Date())))
    @State private var searchText: String = ""
    @State private var showingCamera = false
    @State private var inputImage: UIImage?
    
    // Permet de revenir à la vue précédente
    @Environment(\.presentationMode) var presentationMode
    
    // Accès au contexte de gestion des objets Core Data
    @Environment(\.modelContext) private var context
    
    // Initialise la taille par défaut
    private func initializeDefaultTaille() {
        if viewModel.selectedTaille == nil {
            if let tailleDefaut = try? context.fetch(FetchDescriptor<Taille>(predicate: #Predicate { $0.nomTaille == "Millésime" })).first {
                viewModel.selectedTaille = tailleDefaut
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
                    NavigationLink(destination: SelectVinView(selectedVin: $viewModel.selectedVin)) {
                        HStack {
                            Text("Vin")
                            Spacer()
                            Text(viewModel.selectedVin?.nomVin ?? "Aucun vin sélectionné")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection de la taille du millésime (demi-bouteille, 75 cL, magnum, etc.)
                    NavigationLink(destination: SelectTailleView(selectedTaille: $viewModel.selectedTaille)) {
                        HStack {
                            Text("Taille")
                            Spacer()
                            Text(viewModel.selectedTaille?.nomTaille ?? "Aucune taille sélectionnée")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection de l'année du millésime
                    VStack {
                        HStack {
                            Text("Année \(viewModel.selectedYear.withoutThousandSeparator)")
                            Spacer()
                        }
                        Picker("Année", selection: $viewModel.selectedYear) {
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
                        Stepper(value: $viewModel.selectedQuantite, in: 1...100) {
                            Text("\(viewModel.selectedQuantite) bouteille(s)")
                            }
                    }
                    
                    // Sélection de la durée de conservation du millésime (en attendant un algorithme ou une requête vers Apple Intelligence ou ChatGPT
                    VStack {
                        HStack {
                            Text("Durée de conservation")
                            Spacer()
                        }
                        HStack {
                            Stepper(value: $viewModel.selectedConservationMin, in: 0...100) {
                                Text("Entre \(viewModel.selectedConservationMin) an(s)")
                                }
                            .onChange(of: viewModel.selectedConservationMin) {
                                if viewModel.selectedConservationMin > viewModel.selectedConservationMax {
                                    viewModel.selectedConservationMax = viewModel.selectedConservationMin
                                    }
                                }
                        }
                        HStack {
                            Stepper(value: $viewModel.selectedConservationMax, in: 1...100) {
                                Text("et \(viewModel.selectedConservationMax) an(s)")
                                }
                            .onChange(of: viewModel.selectedConservationMax) {
                                if viewModel.selectedConservationMax < viewModel.selectedConservationMin {
                                    viewModel.selectedConservationMin = viewModel.selectedConservationMax
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
                         self.showingCamera = true
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
            .navigationTitle("Nouveau millésime")
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _, newImage in
                guard let newImage else {
                    return
                }
                detourageViewModel.removeBackground(from: newImage)
            }
            .onChange(of: detourageViewModel.imageDetouree) { _, nouvelleImage in
                viewModel.selectedPhoto = nouvelleImage
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
    static func from(day: Int, month: Int, year: Int) -> Date? {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        return Calendar.current.date(from: components)
    }
}

#Preview {
    AddMillesimeView()
}
