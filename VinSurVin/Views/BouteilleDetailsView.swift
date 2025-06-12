import SwiftUI
import SwiftData

struct BouteilleDetailsView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = DetourageViewModel()
    
    // Récupère la bouteille sélectionnée par l'utilisateur
    @Bindable var selectedBouteille: Bouteille
    
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
                    if let photoData = selectedBouteille.photo, let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    // Le bouton pour prendre ou changer la photo
                    Button(selectedBouteille.photo == nil ? "Ajouter une photo" : "Changer la photo") {
                        selectedBouteille.photo = nil
                        self.showingCamera = true
                    }
                }
                Section(header: Text("Détails de la bouteille")) {
                    HStack {
                        Text("Taille :")
                        Spacer()
                        Text("\(selectedBouteille.taille.volume.description) \(selectedBouteille.taille.uniteVolume)")
                    }
                    HStack {
                        Text("Millésime :")
                        Spacer()
                        Text("\(selectedBouteille.millesime.description)")
                    }
                    HStack {
                        Text("Stock :")
                        Stepper(value: $selectedBouteille.quantiteBouteilles, in: 0...100) {
                            Text("\(selectedBouteille.quantiteBouteilles) bouteille(s)")
                        }
                        .onChange(of: selectedBouteille.quantiteBouteilles) { _, _ in
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
                            Text("\(selectedBouteille.dateConsommationMin.formatJJMMAAAA) et \(selectedBouteille.dateConsommationMax.formatJJMMAAAA)")
                        }
                    }
                }
                Section(header: Text("Provenance")) {
                    HStack {
                        Text("Pays :")
                        Spacer()
                        Text("\(selectedBouteille.vin.provenance.paysParent?.nomProvenance ?? "Pays non renseigné")")
                    }
                    HStack {
                        Text("Région :")
                        Spacer()
                        Text("\(selectedBouteille.vin.provenance.regionParente?.nomProvenance ?? "Région non renseignée")")
                    }
                    HStack {
                        Text("Sous-région :")
                        Spacer()
                        Text("\(selectedBouteille.vin.provenance.sousRegionParente?.nomProvenance ?? "Sous-région non renseignée")")
                    }
                    HStack {
                        Text("Appellation :")
                        Spacer()
                        Text("\(selectedBouteille.vin.provenance.nomProvenance)")
                    }
                    if selectedBouteille.vin.vignoble != nil {
                        HStack {
                            Text("Vignoble :")
                            Spacer()
                            Text("\(selectedBouteille.vin.vignoble?.nomVignoble ?? "Vignoble non renseigné")")
                        }
                    }
                    HStack {
                        Text("Domaine :")
                        Spacer()
                        Text("\(selectedBouteille.vin.domaine.nomDomaine)")
                    }
                }
                Section(header: Text("Détails du vin")) {
                    HStack {
                        Text("Vin :")
                        Spacer()
                        Text("\(selectedBouteille.vin.nomVin)")
                    }
                    HStack {
                        Text("Couleur :")
                        Spacer()
                        Text("\(selectedBouteille.vin.couleur.nomCouleur)")
                    }
                    HStack {
                        Text("Sucrosité :")
                        Spacer()
                        Text("\(selectedBouteille.vin.sucrosite.nomSucrosite)")
                    }
                    HStack {
                        Text("Caractéristique :")
                        Spacer()
                        Text("\(selectedBouteille.vin.caracteristique.nomCaracteristique)")
                    }
                    if selectedBouteille.vin.classification != nil {
                        HStack {
                            Text("Classification :")
                            Spacer()
                            Text("\(selectedBouteille.vin.classification?.nomClassification ?? "Classification non renseignée")")
                        }
                    }
                }
            }
            .navigationTitle(selectedBouteille.vin.nomVin + " - " + selectedBouteille.millesime.description)
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
                    selectedBouteille.photo = imageFinale.jpegData(compressionQuality: 0.8)
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
    BouteilleDetailsView(selectedBouteille: SampleData.shared.bouteilleTroisToits2024)
        .modelContainer(SampleData.shared.modelContainer)
}
