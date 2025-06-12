import SwiftUI
import SwiftData

struct MillesimeDetailsView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = DetourageViewModel()
    
    // Récupère le millésime sélectionné par l'utilisateur
    @Bindable var selectedMillesime: Millesime
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // États pour gérer l'affichage de l'appareil photo
    @State private var showingCamera = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Photo") {
                    // Affiche la photo si elle existe
                    if let photoData = selectedMillesime.photo, let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    // Le bouton pour prendre ou changer la photo
                    Button(selectedMillesime.photo == nil ? "Ajouter une photo" : "Changer la photo") {
                        selectedMillesime.photo = nil
                        self.showingCamera = true
                    }
                }
                /*Section(header: Text("Détails du millésime")) {
                    HStack {
                        Text("Taille :")
                        Spacer()
                        Text("\(selectedMillesime.taille.volume.description) \(selectedMillesime.taille.uniteVolume)")
                    }
                    HStack {
                        Text("Année :")
                        Spacer()
                        Text("\(selectedMillesime.anneeMillesime.description)")
                    }
                    HStack {
                        Text("Stock :")
                        Stepper(value: $selectedMillesime.quantiteBouteilles, in: 0...100) {
                            Text("\(selectedMillesime.quantiteBouteilles) bouteille(s)")
                        }
                        .onChange(of: selectedMillesime.quantiteBouteilles) { _, _ in
                            try? context.save()
                        }
                    }
                    VStack {
                        HStack {
                            Text("A consommer entre :")
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("\(selectedMillesime.dateConsommationMin.formatJJMMAAAA) et \(selectedMillesime.dateConsommationMax.formatJJMMAAAA)")
                        }
                    }
                }
                Section(header: Text("Provenance")) {
                    HStack {
                        Text("Pays :")
                        Spacer()
                        Text("\(selectedMillesime.vin.provenance.paysParent?.nomProvenance ?? "Pays non renseigné")")
                    }
                    HStack {
                        Text("Région :")
                        Spacer()
                        Text("\(selectedMillesime.vin.provenance.regionParente?.nomProvenance ?? "Région non renseignée")")
                    }
                    HStack {
                        Text("Sous-région :")
                        Spacer()
                        Text("\(selectedMillesime.vin.provenance.sousRegionParente?.nomProvenance ?? "Sous-région non renseignée")")
                    }
                    HStack {
                        Text("Appellation :")
                        Spacer()
                        Text("\(selectedMillesime.vin.provenance.nomProvenance)")
                    }
                    if selectedMillesime.vin.vignoble != nil {
                        HStack {
                            Text("Vignoble :")
                            Spacer()
                            Text("\(selectedMillesime.vin.vignoble?.nomVignoble ?? "Vignoble non renseigné")")
                        }
                    }
                    HStack {
                        Text("Domaine :")
                        Spacer()
                        Text("\(selectedMillesime.vin.domaine.nomDomaine)")
                    }
                }
                Section(header: Text("Détails du vin")) {
                    HStack {
                        Text("Vin :")
                        Spacer()
                        Text("\(selectedMillesime.vin.nomVin)")
                    }
                    HStack {
                        Text("Couleur :")
                        Spacer()
                        Text("\(selectedMillesime.vin.couleur.nomCouleur)")
                    }
                    HStack {
                        Text("Sucrosité :")
                        Spacer()
                        Text("\(selectedMillesime.vin.sucrosite.nomSucrosite)")
                    }
                    HStack {
                        Text("Caractéristique :")
                        Spacer()
                        Text("\(selectedMillesime.vin.caracteristique.nomCaracteristique)")
                    }
                    if selectedMillesime.vin.classification != nil {
                        HStack {
                            Text("Classification :")
                            Spacer()
                            Text("\(selectedMillesime.vin.classification?.nomClassification ?? "Classification non renseignée")")
                        }
                    }
                }*/
            }
            .navigationTitle(selectedMillesime.vin.nomVin + " - " + selectedMillesime.anneeMillesime.description)
            .sheet(isPresented: $showingCamera) {
                // Affiche la vue de l'appareil photo
                ImagePicker(image: $inputImage)
            }
            // Quand une image a été prise, lance le traitement
            .onChange(of: inputImage) { _, newImage in
                guard let image = newImage else { return }
                viewModel.removeBackground(from: image)
                
            }
            // Quand l’image détourée est prête, on la sauvegarde dans SwiftData
            .onChange(of: viewModel.imageDetouree) { _, nouvelleImage in
                if let imageFinale = nouvelleImage {
                    selectedMillesime.photo = imageFinale.jpegData(compressionQuality: 0.8)
                    try? context.save()
                }
            }
        }
    }
}

extension Date {
    var formatJJMMAAAA: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}

#Preview {
    MillesimeDetailsView(selectedMillesime: SampleData.shared.millesimeTroisToits2024)
        .modelContainer(SampleData.shared.modelContainer)
}
