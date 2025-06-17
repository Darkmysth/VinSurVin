import SwiftUI
import SwiftData

struct BouteilleDetailsView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = DetourageViewModel()
    
    // Récupère la bouteille sélectionnée par l'utilisateur
    @Bindable var bouteilleSelectionnee: Bouteille
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // États pour gérer l'affichage de l'appareil photo
    @State private var afficheCamera = false
    @State private var imageEnEntree: UIImage?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Photo") {
                    // Affiche la photo si elle existe
                    if let photoData = bouteilleSelectionnee.photo, let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    // Le bouton pour prendre ou changer la photo
                    Button(bouteilleSelectionnee.photo == nil ? "Ajouter une photo" : "Changer la photo") {
                        bouteilleSelectionnee.photo = nil
                        self.afficheCamera = true
                    }
                }
                Section(header: Text("Détails de la bouteille")) {
                    HStack {
                        Text("Taille :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.taille?.volume.description ?? "Volume inconnu") \(bouteilleSelectionnee.taille?.uniteVolume ?? "Unité inconnue")")
                    }
                    HStack {
                        Text("Année :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.anneeMillesime.description ?? "Année inconnue")")
                    }
                    HStack {
                        Text("Stock :")
                        Stepper(value: $bouteilleSelectionnee.quantite, in: 0...100) {
                            Text("\(bouteilleSelectionnee.quantite) bouteille(s)")
                        }
                        .onChange(of: bouteilleSelectionnee.quantite) { _, _ in
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
                            Text("\(bouteilleSelectionnee.dateConsommationMin.formatJJMMAAAA) et \(bouteilleSelectionnee.dateConsommationMax.formatJJMMAAAA)")
                        }
                    }
                }
                Section(header: Text("Provenance")) {
                    HStack {
                        Text("Pays :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.provenance.paysParent?.nomProvenance ?? "Pays non renseigné")")
                    }
                    HStack {
                        Text("Région :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.provenance.regionParente?.nomProvenance ?? "Région non renseignée")")
                    }
                    HStack {
                        Text("Sous-région :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.provenance.sousRegionParente?.nomProvenance ?? "Sous-région non renseignée")")
                    }
                    HStack {
                        Text("Appellation :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.provenance.nomProvenance ?? "Appellation inconnue")")
                    }
                    if bouteilleSelectionnee.millesime?.vin?.vignoble != nil {
                        HStack {
                            Text("Vignoble :")
                            Spacer()
                            Text("\(bouteilleSelectionnee.millesime?.vin?.vignoble?.nomVignoble ?? "Vignoble non renseigné")")
                        }
                    }
                    HStack {
                        Text("Domaine :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.domaine?.nomDomaine ?? "Domaine inconnu")")
                    }
                }
                Section(header: Text("Détails du vin")) {
                    HStack {
                        Text("Vin :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.nomVin ?? "Vin inconnu")")
                    }
                    HStack {
                        Text("Couleur :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.couleur.nomCouleur ?? "Couleur inconnue")")
                    }
                    HStack {
                        Text("Sucrosité :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.sucrosite.nomSucrosite ?? "Sucrosité inconnue")")
                    }
                    HStack {
                        Text("Caractéristique :")
                        Spacer()
                        Text("\(bouteilleSelectionnee.millesime?.vin?.caracteristique.nomCaracteristique ?? "Caractéristique inconnue")")
                    }
                    if bouteilleSelectionnee.millesime?.vin?.classification != nil {
                        HStack {
                            Text("Classification :")
                            Spacer()
                            Text("\(bouteilleSelectionnee.millesime?.vin?.classification?.nomClassification ?? "Classification non renseignée")")
                        }
                    }
                }
            }
            .navigationTitle(
                (bouteilleSelectionnee.millesime?.vin?.nomVin ?? "Vin inconnu")
                + " - " +
                (bouteilleSelectionnee.millesime?.anneeMillesime.description ?? "Année inconnue")
                )
            .sheet(isPresented: $afficheCamera) {
                // Affiche la vue de l'appareil photo
                ImagePicker(image: $imageEnEntree)
            }
            // Quand une image a été prise, lance le traitement
            .onChange(of: imageEnEntree) { _, newImage in
                guard let image = newImage else { return }
                viewModel.supprimerArrierePlan(from: image)
                
            }
            // Quand l’image détourée est prête, on la sauvegarde dans SwiftData
            .onChange(of: viewModel.imageDetouree) { _, nouvelleImage in
                if let imageFinale = nouvelleImage {
                    bouteilleSelectionnee.photo = imageFinale.jpegData(compressionQuality: 0.8)
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
    BouteilleDetailsView(bouteilleSelectionnee: SampleData.shared.bouteillesTroisToitsMillesime2024)
        .modelContainer(SampleData.shared.modelContainer)
}
