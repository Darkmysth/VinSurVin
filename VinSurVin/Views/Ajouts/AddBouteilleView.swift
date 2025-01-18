import SwiftUI
import SwiftData
import Foundation

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
    @State private var selectedVin: Vin? = nil
    @State private var selectedTaille: Taille? = nil
    @State private var selectedYear: Int = Int(Calendar.current.component(.year, from: Date()))
    let years: [Int] = Array(Int(1950)...Int(Calendar.current.component(.year, from: Date())))
    @State private var selectedQuantite: Int = 1
    @State private var selectedConservationMin: Int = 1
    @State private var selectedConservationMax: Int = 1
    @State private var searchText: String = ""
    
    // Accès au contexte de gestion des objets Core Data
    @Environment(\.modelContext) private var context
    
    var isFormComplete: Bool {
        selectedVin != nil && selectedTaille != nil && selectedQuantite > 0 && selectedConservationMin <= selectedConservationMax
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails de la bouteille")) {
                    
                    // Sélection du vin de la bouteille
                    NavigationLink(destination: SelectVinView(selectedVin: $selectedVin)) {
                        HStack {
                            Text("Vin")
                            Spacer()
                            Text(selectedVin?.nomVin ?? "Aucun vin sélectionné")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Sélection de la taille de la bouteille (demi-bouteille, 75 cL, magnum, etc.)
                    NavigationLink(destination: SelectTailleView(selectedTaille: $selectedTaille)) {
                        HStack {
                            Text("Taille")
                            Spacer()
                            Text(selectedTaille?.nomTaille ?? "Aucune taille sélectionnée")
                                .foregroundColor(.gray)
                        }
                    }
                    
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
                        saveBouteille()
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
    
    // Fonction pour créer et sauvegarder un nouveau vin
    private func saveBouteille() {
        
        // Créer une nouvelle instance de Bouteille en le rattachant à un vin et une taille
        let newBouteille = Bouteille(
            quantiteBouteilles: selectedQuantite,
            millesime: selectedYear,
            dateConsommationMin: Date.from(day: 1, month: 1, year: selectedYear + selectedConservationMin)!,
            dateConsommationMax: Date.from(day: 1, month: 1, year: selectedYear + selectedConservationMax)!,
            taille: selectedTaille!,
            vin: selectedVin!
        )
        
        // Ajouter le domaine au contexte
        context.insert(newBouteille)
        
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
