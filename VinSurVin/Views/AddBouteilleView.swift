import SwiftUI
import SwiftData

struct AddBouteilleView: View {
    
    // Prépare les variables d'état recueillant les saisies de l'utilisateur
    @State private var showVin = false
    @State private var showTaille = false
    @State private var showMillesime = false
    @State private var showQuantite = false
    @State private var showConservation = false
    @State private var shouldRefreshVinList: Bool = false
    
    // Permet de revenir à la vue précédente
    @Environment(\.presentationMode) var presentationMode

    // Variables pour stocker les sélections
    @State private var selectedVin: String = ""
    @State private var selectedTaille: String = ""
    @State private var selectedYear: Int16 = Int16(Calendar.current.component(.year, from: Date()))
    let years: [Int16] = Array(Int16(1950)...Int16(Calendar.current.component(.year, from: Date())))
    @State private var selectedQuantite: Int16 = 1
    @State private var selectedConservationMin: Int = 1
    @State private var selectedConservationMax: Int = 1
    @State private var searchText: String = ""
    
    // Accès au contexte de gestion des objets Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    var isFormComplete: Bool {
        !selectedVin.isEmpty && !selectedTaille.isEmpty && selectedQuantite > 0 && selectedConservationMin <= selectedConservationMax
    }


    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails de la bouteille")) {
                    
                    // Sélection du vin de la bouteille
                    
                    // Sélection de la taille de la bouteille (demi-bouteille, 75 cL, magnum, etc.)
                    
                    // Sélection du millésime de la bouteille
                    VStack {
                        HStack {
                            Text("Millésime \(selectedYear.withoutThousandSeparator)")
                            Spacer()
                        }
                        Picker("Millésime", selection: $selectedYear) {
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
                        Stepper(value: $selectedQuantite, in: 1...100) {
                            Text("\(selectedQuantite) bouteille(s)")
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
                                if selectedConservationMin > 0 {
                                    selectedConservationMin -= 1
                                    if selectedConservationMin > selectedConservationMax {
                                        selectedConservationMax = selectedConservationMin
                                    }
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            
                            Text("Entre \(selectedConservationMin) an(s)")
                            
                            Button(action: {
                                if selectedConservationMin < 100 {
                                    selectedConservationMin += 1
                                    if selectedConservationMin > selectedConservationMax {
                                        selectedConservationMax = selectedConservationMin
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
                            Stepper(value: $selectedConservationMin, in: 0...100) {
                                Text("Entre \(selectedConservationMin) an(s)")
                            }
                            .onChange(of: selectedConservationMin) {
                                if selectedConservationMin > selectedConservationMax {
                                    selectedConservationMax = selectedConservationMin
                                }
                            }
#endif
                        }
                        HStack {
#if os(tvOS)
                            // tvOS : Boutons Incrémenter/Décrémenter
                            Button(action: {
                                if selectedConservationMax > selectedConservationMin {
                                    selectedConservationMax -= 1
                                    if selectedConservationMax < selectedConservationMin {
                                        selectedConservationMin = selectedConservationMax
                                    }
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            
                            Text("et \(selectedConservationMax) an(s)")
                            
                            Button(action: {
                                if selectedConservationMax < 100 {
                                    selectedConservationMax += 1
                                    if selectedConservationMax < selectedConservationMin {
                                        selectedConservationMin = selectedConservationMax
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
                            Stepper(value: $selectedConservationMax, in: selectedConservationMin...100) {
                                Text("et \(selectedConservationMax) an(s)")
                            }
                            .onChange(of: selectedConservationMax) {
                                if selectedConservationMax < selectedConservationMin {
                                    selectedConservationMin = selectedConservationMax
                                }
                            }
#endif
                        }
                    }
                    
                }
                
                Section {
                    Button(action: {
                        //saveBouteille()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Enregistrer")
                    }
                    .disabled(!isFormComplete)
                }
            }
            .navigationTitle("Nouvelle bouteille")
        }
    }
}

struct AddBouteilleView_Previews: PreviewProvider {
    static var previews: some View {
        AddBouteilleView()
    }
}


// Extension pour formater l'affichage des années sans séparateur de milliers
extension Int16 {
    var withoutThousandSeparator: String {
        return String(format: "%d", self)
    }
}
