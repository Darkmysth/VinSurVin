import SwiftUI
import SwiftData

struct BouteilleCardView: View {
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveBouteillesViewModel()
    
    // Récupère la couleur et le vin choisis par l'utilisateur
    let bouteilleSelectionnee: Bouteille
    
    var body: some View {
        NavigationLink(destination: BouteilleDetailsView(bouteilleSelectionnee: bouteilleSelectionnee)) {
            VStack(alignment: .leading) {
                if let photoData = bouteilleSelectionnee.photo, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 185, height: 185)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .frame(width: 185, height: 185)
                        .cornerRadius(12)
                }
                Text(bouteilleSelectionnee.millesime?.vin?.nomVin ?? "Vin inconnu")
                    .font(.caption)
                    .bold()
                    .lineLimit(1)
                
                Text("Millésime \(bouteilleSelectionnee.millesime?.anneeMillesime.description ?? "Millésime inconnu")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 185)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BouteilleCardView(bouteilleSelectionnee: SampleData.shared.bouteillesLafiteRothschildMillesime1999)
        .modelContainer(SampleData.shared.modelContainer)
}
