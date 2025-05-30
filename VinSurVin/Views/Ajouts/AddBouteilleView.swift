import SwiftUI
import SwiftData
import Foundation

struct AddBouteilleView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = AddBouteilleViewModel()
    
    // Prépare les variables d'état recueillant les saisies de l'utilisateur
    @State private var showVin = false
    @State private var showTaille = false
    @State private var showMillesime = false
    @State private var showQuantite = false
    @State private var showConservation = false
    @State private var shouldRefreshVinList: Bool = false
    let years: [Int] = Array(Int(1950)...Int(Calendar.current.component(.year, from: Date())))
    @State private var searchText: String = ""
    
    // Permet de revenir à la vue précédente
    @Environment(\.presentationMode) var presentationMode
    
    // Accès au contexte de gestion des objets Core Data
    @Environment(\.modelContext) private var context
    
    // Initialise la taille par défaut
    private func initializeDefaultTaille() {
        if viewModel.selectedTaille == nil {
            if let tailleDefaut = try? context.fetch(FetchDescriptor<Taille>(predicate: #Predicate { $0.nomTaille == "Bouteille" })).first {
                viewModel.selectedTaille = tailleDefaut
            } else {
                print("Erreur : impossible de trouver la taille par défaut.")
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails de la bouteille")) {
                    
                    // Sélection du vin de la bouteille
                    NavigationLink(destination: SelectVinView(selectedVin: $viewModel.selectedVin)) {
                        HStack {
                            Text("Vin")
                            Spacer()
                            Text(viewModel.selectedVin?.nomVin ?? "Aucun vin sélectionné")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection de la taille de la bouteille (demi-bouteille, 75 cL, magnum, etc.)
                    NavigationLink(destination: SelectTailleView(selectedTaille: $viewModel.selectedTaille)) {
                        HStack {
                            Text("Taille")
                            Spacer()
                            Text(viewModel.selectedTaille?.nomTaille ?? "Aucune taille sélectionnée")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection du millésime de la bouteille
                    VStack {
                        HStack {
                            Text("Millésime \(viewModel.selectedYear.withoutThousandSeparator)")
                            Spacer()
                        }
                        Picker("Millésime", selection: $viewModel.selectedYear) {
                            ForEach(years, id: \.self) { year in
                                Text(year.withoutThousandSeparator).tag(year)
                            }
                        }
                        #if os(tvOS)
                            // Style adapté pour tvOS (par défaut, sans WheelPickerStyle)
                            .pickerStyle(.automatic)
                        #else
                            // Style roue pour iOS
                            .pickerStyle(WheelPickerStyle())
                        #endif
                    }
                    
                    // Sélection de la quantité de bouteilles ajoutées
                    VStack {
                        HStack {
                            Text("Quantité")
                            Spacer()
                        }
                        #if os(tvOS)
                            // tvOS : Boutons Incrémenter/Décrémenter
                            HStack {
                                Button(action: {
                                    if selectedQuantite > 1 {
                                        selectedQuantite -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.title)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                                
                                Text("\(selectedQuantite) bouteille(s)")
                                
                                Button(action: {
                                    if selectedQuantite < 100 {
                                        selectedQuantite += 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        #else
                            // iOS / iPadOS : Stepper standard
                        Stepper(value: $viewModel.selectedQuantite, in: 1...100) {
                            Text("\(viewModel.selectedQuantite) bouteille(s)")
                            }
                        #endif
                    }
                    
                    // Sélection de la durée de conservation de la bouteille (en attendant un algorithme ou une requête vers Apple Intelligence ou ChatGPT
                    VStack {
                        HStack {
                            Text("Durée de conservation")
                            Spacer()
                        }
                        HStack {
                            #if os(tvOS)
                                // tvOS : Boutons Incrémenter/Décrémenter
                                Button(action: {
                                    if viewModel.selectedConservationMin > 0 {
                                        viewModel.selectedConservationMin -= 1
                                        if viewModel.selectedConservationMin > viewModel.selectedConservationMax {
                                            viewModel.selectedConservationMax = viewModel.selectedConservationMin
                                        }
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.title)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                                
                            Text("Entre \(viewModel.selectedConservationMin) an(s)")
                                
                                Button(action: {
                                    if viewModel.selectedConservationMin < 100 {
                                        viewModel.selectedConservationMin += 1
                                        if viewModel.selectedConservationMin > viewModel.selectedConservationMax {
                                            viewModel.selectedConservationMax = viewModel.selectedConservationMin
                                        }
                                    }
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            #else
                                // iOS / iPadOS : Stepper standard
                            Stepper(value: $viewModel.selectedConservationMin, in: 0...100) {
                                Text("Entre \(viewModel.selectedConservationMin) an(s)")
                                }
                            .onChange(of: viewModel.selectedConservationMin) {
                                if viewModel.selectedConservationMin > viewModel.selectedConservationMax {
                                    viewModel.selectedConservationMax = viewModel.selectedConservationMin
                                    }
                                }
                            #endif
                        }
                        HStack {
                            #if os(tvOS)
                                // tvOS : Boutons Incrémenter/Décrémenter
                                Button(action: {
                                    if viewModel.selectedConservationMax > viewModel.selectedConservationMin {
                                        viewModel.selectedConservationMax -= 1
                                        if viewModel.selectedConservationMax < viewModel.selectedConservationMin {
                                            viewModel.selectedConservationMin = viewModel.selectedConservationMax
                                        }
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.title)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                                
                            Text("et \(viewModel.selectedConservationMax) an(s)")
                                
                                Button(action: {
                                    if viewModel.selectedConservationMax < 100 {
                                        viewModel.selectedConservationMax += 1
                                        if viewModel.selectedConservationMax < viewModel.selectedConservationMin {
                                            viewModel.selectedConservationMin = viewModel.selectedConservationMax
                                        }
                                    }
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            #else
                                // iOS / iPadOS : Stepper standard
                            Stepper(value: $viewModel.selectedConservationMax, in: 1...100) {
                                Text("et \(viewModel.selectedConservationMax) an(s)")
                                }
                            .onChange(of: viewModel.selectedConservationMax) {
                                if viewModel.selectedConservationMax < viewModel.selectedConservationMin {
                                    viewModel.selectedConservationMin = viewModel.selectedConservationMax
                                    }
                                }
                            #endif
                        }
                    }         
                }
                
                Section {
                    Button("Enregistrer") {
                        if viewModel.enregistrerBouteille(dans: context) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(!viewModel.isFormComplete)
                }
            }
            .onAppear(perform: initializeDefaultTaille) // Initialise la taille par défaut
            .navigationTitle("Nouvelle bouteille")
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
    AddBouteilleView()
}
